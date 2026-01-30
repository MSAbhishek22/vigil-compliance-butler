import 'package:serverpod/serverpod.dart';
import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';
import 'src/services/job_scheduler.dart';

/// Starts the Vigil server
void run(List<String> args) async {
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );
  
  // Start the heartbeat (Active Oversight)
  final scheduler = JobScheduler(pod);
  scheduler.start();
  
  await pod.start();
  
  print('''
╔══════════════════════════════════════════════════════════════╗
║   🎩 VIGIL - The Compliance Butler                          ║
║   Server is now running and vigilant.                        ║
╚══════════════════════════════════════════════════════════════╝
  ''');
}
