import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

/// GeminiService - The "Intelligence" Layer of Vigil
/// 
/// This service handles communication with Google's Gemini API
/// to extract deadlines and requirements from unstructured text.
class GeminiService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
  
  // API Key - In production, use environment variables
  static const String _apiKey = 'AIzaSyBUIyHrudNdNuHK3_A0JH8IHBsYIw7JQ1w';

  /// Extract requirements and deadlines from document text
  /// 
  /// Returns a list of extracted requirements as JSON objects
  static Future<List<Map<String, dynamic>>> extractRequirements(
    Session session, 
    String documentText,
  ) async {
    session.log('🤖 Gemini: Beginning extraction from ${documentText.length} characters...');

    final prompt = _buildExtractionPrompt(documentText);
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.2,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 8192,
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_HARASSMENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            }
          ]
        }),
      );

      if (response.statusCode != 200) {
        session.log('Gemini API error: ${response.statusCode} - ${response.body}', 
          level: LogLevel.error);
        throw Exception('Gemini API returned ${response.statusCode}');
      }

      final jsonResponse = jsonDecode(response.body);
      final content = jsonResponse['candidates']?[0]?['content']?['parts']?[0]?['text'];
      
      if (content == null) {
        session.log('No content in Gemini response', level: LogLevel.warning);
        return [];
      }

      // Parse the JSON from Gemini's response
      final requirements = _parseGeminiResponse(session, content);
      
      session.log('✅ Gemini extracted ${requirements.length} requirements');
      return requirements;

    } catch (e, stackTrace) {
      session.log('Error calling Gemini API: $e', 
        level: LogLevel.error,
        exception: e as Exception,
        stackTrace: stackTrace
      );
      rethrow;
    }
  }

  /// Build the extraction prompt with specific instructions for Gemini
  static String _buildExtractionPrompt(String documentText) {
    return '''
You are Vigil, an expert compliance analyst AI. Your task is to analyze the following document and extract ALL deadlines, requirements, and mandatory actions.

DOCUMENT TO ANALYZE:
---
$documentText
---

EXTRACTION RULES:
1. Extract EVERY deadline, due date, or time-sensitive requirement
2. Identify if each requirement is MANDATORY or optional
3. For each deadline, calculate the actual date (use current year 2026 if not specified)
4. Identify dependencies (e.g., "video demo" depends on having a working app)
5. Rate importance: critical, high, medium, low

OUTPUT FORMAT (JSON array):
[
  {
    "title": "Brief task title (max 50 chars)",
    "description": "Detailed description of what needs to be done",
    "deadline": "YYYY-MM-DDTHH:mm:ss" (ISO 8601 format, or null if no specific deadline),
    "isMandatory": true/false,
    "importance": "critical/high/medium/low",
    "dependencies": ["list of things this depends on"],
    "estimatedEffort": "time estimate like '2 hours' or '1 day'"
  }
]

IMPORTANT:
- If a deadline mentions a timezone, convert to UTC
- If text says "before submission" or "at time of submission", use the main deadline
- Look for hidden requirements like "must include", "required to", "should provide"
- Extract even implicit deadlines (e.g., "video demo" implies you need time to record/edit)

Return ONLY the JSON array, no other text.
''';
  }

  /// Parse Gemini's text response into structured requirements
  static List<Map<String, dynamic>> _parseGeminiResponse(Session session, String content) {
    try {
      // Clean the response - Gemini sometimes wraps JSON in markdown
      String cleanContent = content.trim();
      
      // Remove markdown code blocks if present
      if (cleanContent.startsWith('```json')) {
        cleanContent = cleanContent.substring(7);
      } else if (cleanContent.startsWith('```')) {
        cleanContent = cleanContent.substring(3);
      }
      if (cleanContent.endsWith('```')) {
        cleanContent = cleanContent.substring(0, cleanContent.length - 3);
      }
      
      cleanContent = cleanContent.trim();
      
      final decoded = jsonDecode(cleanContent);
      
      if (decoded is List) {
        return decoded.cast<Map<String, dynamic>>();
      } else if (decoded is Map && decoded.containsKey('requirements')) {
        return (decoded['requirements'] as List).cast<Map<String, dynamic>>();
      }
      
      session.log('Unexpected Gemini response format: ${decoded.runtimeType}', 
        level: LogLevel.warning);
      return [];
      
    } catch (e) {
      session.log('Error parsing Gemini response: $e\nContent: $content', 
        level: LogLevel.error);
      return [];
    }
  }

  /// Fetch content from a URL for processing
  static Future<String> fetchUrlContent(Session session, String url) async {
    session.log('📥 Fetching content from: $url');
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Vigil-Butler/1.0 (Compliance Assistant)',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch URL: ${response.statusCode}');
      }

      // Basic HTML to text conversion
      String text = response.body;
      
      // Remove script and style tags
      text = text.replaceAll(RegExp(r'<script[^>]*>[\s\S]*?</script>', caseSensitive: false), '');
      text = text.replaceAll(RegExp(r'<style[^>]*>[\s\S]*?</style>', caseSensitive: false), '');
      
      // Remove HTML tags but keep text
      text = text.replaceAll(RegExp(r'<[^>]+>'), ' ');
      
      // Decode HTML entities
      text = text.replaceAll('&nbsp;', ' ')
                 .replaceAll('&amp;', '&')
                 .replaceAll('&lt;', '<')
                 .replaceAll('&gt;', '>')
                 .replaceAll('&quot;', '"');
      
      // Clean up whitespace
      text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
      
      session.log('📄 Fetched ${text.length} characters from URL');
      return text;

    } catch (e) {
      session.log('Error fetching URL: $e', level: LogLevel.error);
      rethrow;
    }
  }
}
