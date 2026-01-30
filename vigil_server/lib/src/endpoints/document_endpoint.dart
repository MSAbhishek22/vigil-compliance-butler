import 'package:serverpod/serverpod.dart';
import '../services/gemini_service.dart';

/// DocumentEndpoint - The main API endpoint for Vigil
class DocumentEndpoint extends Endpoint {
  
  /// Process a document URL (Real AI)
  Future<Map<String, dynamic>> processDocument(Session session, String url) async {
    try {
      session.log('Processing document: $url');
      
      // 1. Fetch content
      final content = await GeminiService.fetchUrlContent(session, url);
      
      // 2. Extract requirements
      final extracted = await GeminiService.extractRequirements(session, content);
      
      final now = DateTime.now();
      final nowStr = now.toIso8601String();
      
      // 3. Create Source Document
      final safeUrl = url.replaceAll("'", "''");
      // Use the first requirement title or generic
      final safeTitle = extracted.isNotEmpty ? 'Analysis of $safeUrl' : 'Analyzed Document'; 
      
      final docQuery = "INSERT INTO source_documents (user_id, url, file_type, status, title, created_at, updated_at) "
          "VALUES (1, '$safeUrl', 'url', 'active', '$safeTitle', '$nowStr', '$nowStr') RETURNING id";
      
      final docResult = await session.db.unsafeQuery(docQuery);
      if (docResult.isEmpty) throw Exception('Failed to insert document');
      
      final docId = docResult.first[0] as int;
      
      // 4. Insert Requirements
      for (final req in extracted) {
        final title = (req['title'] as String).replaceAll("'", "''");
        final desc = (req['description'] as String?)?.replaceAll("'", "''") ?? '';
        final deadlineStr = req['deadline'] as String?;
        final isMandatory = req['isMandatory'] as bool? ?? false;
        
        String deadlineSql = 'NULL';
        if (deadlineStr != null) {
             try {
                 DateTime.parse(deadlineStr); 
                 deadlineSql = "'$deadlineStr'";
             } catch (_) {}
        }
        
        final reqQuery = "INSERT INTO requirements (source_document_id, title, description, deadline, is_mandatory, status, created_at) "
            "VALUES ($docId, '$title', '$desc', $deadlineSql, $isMandatory, 'pending', '$nowStr') RETURNING id";
            
        final reqResult = await session.db.unsafeQuery(reqQuery);
        
        if (reqResult.isEmpty) continue;
        final reqId = reqResult.first[0] as int;
        
        // Schedule Reminders (Active Oversight)
        if (deadlineStr != null) {
           DateTime? deadline;
           try { deadline = DateTime.parse(deadlineStr).toUtc(); } catch (_) {}
           
           if (deadline != null && deadline.isAfter(DateTime.now().toUtc())) {
               final nowUtc = DateTime.now().toUtc();
               
               // Helper to schedule
               Future<void> schedule(String type, Duration offset) async {
                   final triggerTime = deadline!.subtract(offset);
                   if (triggerTime.isAfter(nowUtc)) {
                       final tStr = triggerTime.toIso8601String();
                       await session.db.unsafeQuery(
                           "INSERT INTO vigil_jobs (requirement_id, reminder_type, scheduled_at, status, created_at, updated_at) "
                           "VALUES ($reqId, '$type', '$tStr', 'pending', '$nowStr', '$nowStr')"
                       );
                   }
               }
               
               await schedule('1_week_warning', const Duration(days: 7));
               await schedule('24h_urgent', const Duration(hours: 24));
               await schedule('1h_critical', const Duration(hours: 1));
           }
        }
      }
      
      return {
        'id': docId,
        'userId': 1,
        'url': url,
        'fileType': 'url',
        'status': 'active',
        'title': safeTitle,
        'createdAt': nowStr,
        'updatedAt': nowStr,
      };

    } catch (e, stack) {
      session.log('Error processing document: $e', level: LogLevel.error, stackTrace: stack);
      rethrow;
    }
  }

  /// Get requirements for a document
  Future<List<Map<String, dynamic>>> getRequirements(Session session, int sourceDocumentId) async {
    try {
      final query = "SELECT id, source_document_id, title, description, deadline, is_mandatory, status, proof_url, created_at FROM requirements WHERE source_document_id = $sourceDocumentId";
      final result = await session.db.unsafeQuery(query);
      
      return result.map<Map<String, dynamic>>((row) => {
        'id': row[0],
        'sourceDocumentId': row[1],
        'title': row[2],
        'description': row[3],
        'deadline': (row[4] as DateTime?)?.toIso8601String(),
        'isMandatory': row[5],
        'status': row[6],
        'proofUrl': row[7],
        'createdAt': (row[8] as DateTime).toIso8601String(),
      }).toList();
    } catch (e) {
      session.log('Error getting requirements: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Complete a requirement
  Future<Map<String, dynamic>> completeRequirement(Session session, int requirementId, String? proofUrl) async {
    try {
      final query = "UPDATE requirements SET status = 'completed', proof_url = '${proofUrl ?? ''}' WHERE id = $requirementId RETURNING *";
      final result = await session.db.unsafeQuery(query);
       
      if (result.isNotEmpty) {
        final row = result.first;
        return {
          'id': row[0],
          // ... map other fields if needed for return ...
          'status': 'completed',
        };
      }
      throw Exception('Requirement not found');
    } catch (e) {
      session.log('Error completing requirement: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Get the "Vigilance Score" - percentage of requirements completed
  Future<Map<String, dynamic>> getVigilanceScore(Session session) async {
    try {
      final result = await session.db.unsafeQuery('SELECT status, COUNT(*) as count FROM requirements GROUP BY status');
      
      int total = 0;
      int completed = 0;
      int pending = 0;
      int missed = 0;
      
      for (final row in result) {
        final status = row[0] as String;
        final count = row[1] as int;
        total += count;
        
        switch (status) {
          case 'completed':
            completed = count;
            break;
          case 'pending':
            pending = count;
            break;
          case 'missed':
            missed = count;
            break;
        }
      }
      
      if (total == 0) {
        return {
          'score': 100,
          'total': 0,
          'completed': 0,
          'pending': 0,
          'missed': 0,
          'message': 'No requirements being tracked. Add a document to get started!',
        };
      }
      
      final score = ((completed / total) * 100).round();
      
      String message;
      if (score >= 90) {
        message = 'Excellent! You\'re in great shape. 🌟';
      } else if (score >= 70) {
        message = 'Good progress! Keep it up. 💪';
      } else if (score >= 50) {
        message = 'Halfway there. Stay focused! 📋';
      } else if (missed > 0) {
        message = '⚠️ You have missed requirements! Review immediately.';
      } else {
        message = 'You have work to do. The Butler is watching. 👁️';
      }

      return {
        'score': score,
        'total': total,
        'completed': completed,
        'pending': pending,
        'missed': missed,
        'message': message,
      };
    } catch (e) {
      session.log('Error getting vigilance score: $e', level: LogLevel.error);
      return {
        'score': 0,
        'total': 0,
        'completed': 0,
        'pending': 0,
        'missed': 0,
        'message': 'Error loading data',
      };
    }
  }

  /// Get all active source documents
  Future<List<Map<String, dynamic>>> getActiveDocuments(Session session) async {
    try {
      final result = await session.db.unsafeQuery(
        "SELECT id, title, status, created_at FROM source_documents WHERE status = 'active' ORDER BY created_at DESC"
      );
      
      return result.map<Map<String, dynamic>>((row) => {
        'id': row[0],
        'title': row[1] ?? 'Untitled',
        'status': row[2],
        'createdAt': (row[3] as DateTime).toIso8601String(),
      }).toList();
    } catch (e) {
      session.log('Error getting documents: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Get upcoming deadlines
  Future<List<Map<String, dynamic>>> getUpcomingDeadlines(Session session, {int limit = 5}) async {
    try {
      final now = DateTime.now();
      final nowStr = now.toIso8601String();
      final query = "SELECT id, title, deadline, is_mandatory FROM requirements WHERE deadline IS NOT NULL AND status = 'pending' AND deadline > '$nowStr' ORDER BY deadline ASC LIMIT $limit";
      
      final result = await session.db.unsafeQuery(query);
      
      return result.map<Map<String, dynamic>>((row) {
        final deadline = row[2] as DateTime;
        final hoursRemaining = deadline.difference(now).inHours;
        
        return {
          'id': row[0],
          'title': row[1],
          'deadline': deadline.toIso8601String(),
          'isMandatory': row[3],
          'hoursRemaining': hoursRemaining,
          'isUrgent': hoursRemaining < 24,
          'isCritical': hoursRemaining < 1,
        };
      }).toList();
    } catch (e) {
      session.log('Error getting deadlines: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Health check endpoint
  Future<String> ping(Session session) async {
    return 'pong';
  }
}
