import 'dart:async';
import 'package:serverpod/serverpod.dart';

/// JobScheduler - The "Heartbeat" of Vigil
/// 
/// Polls the database for scheduled jobs and executes them.
/// This ensures that reminders are sent even if the app handles are closed.
class JobScheduler {
  final Serverpod pod;
  Timer? _timer;

  JobScheduler(this.pod);

  void start() {
    print('🕰️ Vigil Scheduler: Started. Watching for deadlines...');
    // Check every 60 seconds
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _processPendingJobs();
    });
  }

  void stop() {
    _timer?.cancel();
    print('🛑 Vigil Scheduler: Stopped.');
  }

  Future<void> _processPendingJobs() async {
    final session = await pod.createSession(enableLogging: false);
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      
      // Find pending jobs
      // Note: We use raw SQL because our models are simplified
      // scheduled_at <= now AND executed_at IS NULL AND status = 'pending'
      final query = "SELECT id, requirement_id, reminder_type FROM vigil_jobs "
          "WHERE scheduled_at <= '$now' AND executed_at IS NULL AND status = 'pending' "
          "LIMIT 10"; // Process batch of 10
      
      final jobs = await session.db.unsafeQuery(query);
      
      if (jobs.isEmpty) return;
      
      print('🔔 Processing ${jobs.length} reminders...');
      
      for (final job in jobs) {
        final jobId = job[0] as int;
        final reqId = job[1] as int;
        final type = job[2] as String;
        
        await _executeJob(session, jobId, reqId, type);
      }
    } catch (e, stack) {
      print('Scheduler Error: $e');
      print(stack);
    } finally {
      session.close();
    }
  }

  Future<void> _executeJob(Session session, int jobId, int reqId, String type) async {
    try {
      // 1. Fetch Requirement details
      final reqQuery = "SELECT title, deadline FROM requirements WHERE id = $reqId";
      final reqResult = await session.db.unsafeQuery(reqQuery);
      
      if (reqResult.isNotEmpty) {
        final title = reqResult.first[0] as String;
        final deadline = reqResult.first[1] as DateTime?;
        
        // 2. "Send Notification" (Simulated with Log/Console)
        final message = "⚠️ REMINDER ($type): '$title' is due at $deadline";
        print('\n════════════════════════════════════════════════════════════');
        print(message);
        print('════════════════════════════════════════════════════════════\n');
        
        session.log(message, level: LogLevel.info);
      }

      // 3. Mark as Complete
      final now = DateTime.now().toUtc().toIso8601String();
      await session.db.unsafeQuery(
        "UPDATE vigil_jobs SET status = 'completed', executed_at = '$now', notification_sent = true "
        "WHERE id = $jobId"
      );
      
    } catch (e) {
      print('Job Execution Failed: $e');
      // Mark as failed to avoid infinite loop
      await session.db.unsafeQuery(
        "UPDATE vigil_jobs SET status = 'failed', error_message = '${e.toString()}' "
        "WHERE id = $jobId"
      );
    }
  }
}
