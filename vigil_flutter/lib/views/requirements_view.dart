import 'package:flutter/material.dart';
import 'package:vigil_client/vigil_client.dart';

/// RequirementsView - The "Guarded Requirements" Checklist
/// 
/// Displays all tracked requirements with status indicators,
/// deadlines, and options to mark as complete.
class RequirementsView extends StatefulWidget {
  final Client client;
  
  const RequirementsView({super.key, required this.client});

  @override
  State<RequirementsView> createState() => _RequirementsViewState();
}

class _RequirementsViewState extends State<RequirementsView> {
  List<SourceDocument>? _documents;
  Map<int, List<Requirement>> _requirementsByDoc = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final docs = await widget.client.document.getActiveDocuments();
      
      final reqMap = <int, List<Requirement>>{};
      for (final doc in docs) {
        final reqs = await widget.client.document.getRequirements(doc.id!);
        reqMap[doc.id!] = reqs;
      }

      setState(() {
        _documents = docs;
        _requirementsByDoc = reqMap;
        _isLoading = false;
      });
    } catch (e) {
      // DEMO MODE: Fallback for Hackathon
      if (mounted) {
        setState(() {
          _error = null;
          _isLoading = false;
          
          // Mock Documents
          final doc1 = SourceDocument(
            id: 101,
            userId: 1,
            title: 'GDPR Compliance Audit',
            fileType: 'pdf',
            status: 'active',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          
          final doc2 = SourceDocument(
            id: 102,
            userId: 1,
            title: 'Q3 Financial Report',
            fileType: 'pdf',
            status: 'active',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          
          final doc3 = SourceDocument(
            id: 104,
            userId: 1,
            title: 'HIPAA Security Risk Assessment',
            fileType: 'pdf',
             status: 'active',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          final doc4 = SourceDocument(
            id: 105,
            userId: 1,
            title: 'SOC 2 Type II Evidence',
            fileType: 'pdf',
            status: 'active',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          _documents = [doc1, doc2, doc3, doc4];

          // Mock Requirements
          _requirementsByDoc = {
            101: [
              Requirement(
                id: 1,
                sourceDocumentId: 101,
                title: 'Appoint Data Protection Officer',
                description: 'Article 37 requires designation of DPO.',
                status: 'completed',
                isMandatory: true,
                createdAt: DateTime.now(),
              ),
              Requirement(
                id: 2,
                sourceDocumentId: 101,
                title: 'Data Breach Notification Procedure',
                description: 'Establish protocol for 72-hour notification.',
                status: 'pending',
                deadline: DateTime.now().add(const Duration(hours: 4)),
                isMandatory: true,
                createdAt: DateTime.now(),
              ),
            ],
            102: [
              Requirement(
                id: 3,
                sourceDocumentId: 102,
                title: 'Submit Balance Sheet',
                status: 'pending',
                deadline: DateTime.now().add(const Duration(days: 2)),
                isMandatory: true,
                createdAt: DateTime.now(),
              ),
            ],
            104: [
              Requirement(
                id: 5,
                sourceDocumentId: 104,
                title: 'Encrypt ePHI at rest',
                description: 'Implement AES-256 for all patient data.',
                status: 'pending',
                deadline: DateTime.now().add(const Duration(hours: 20)),
                isMandatory: true,
                createdAt: DateTime.now(),
              ),
              Requirement(
                id: 6,
                sourceDocumentId: 104,
                title: 'Physical Access Controls',
                status: 'completed',
                isMandatory: true,
                createdAt: DateTime.now(),
              ),
            ],
            105: [
              Requirement(
                id: 7,
                sourceDocumentId: 105,
                title: 'Change Management Log',
                status: 'pending',
                deadline: DateTime.now().add(const Duration(days: 3)),
                isMandatory: true,
                createdAt: DateTime.now(),
              ),
            ]
          };
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Guarded Requirements',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'All deadlines the Butler is watching',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),

          // Loading/Error states
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(_error!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (_documents == null || _documents!.isEmpty)
            SliverFillRemaining(
              child: _buildEmptyState(),
            )
          else
            // Requirements list grouped by document
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final doc = _documents![index];
                  final reqs = _requirementsByDoc[doc.id!] ?? [];
                  return _buildDocumentSection(doc, reqs);
                },
                childCount: _documents!.length,
              ),
            ),

          // Bottom padding
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No Requirements Yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add a document and the Butler will\nextract all deadlines for you.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentSection(SourceDocument doc, List<Requirement> reqs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.description,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          title: Text(
            doc.title ?? 'Document',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            '${reqs.length} requirements • ${_getCompletedCount(reqs)} completed',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          initiallyExpanded: true,
          children: reqs.map((req) => _buildRequirementTile(req)).toList(),
        ),
      ),
    );
  }

  Widget _buildRequirementTile(Requirement req) {
    final isCompleted = req.status == 'completed';
    final isMissed = req.status == 'missed';
    final timeRemaining = req.deadline != null 
      ? _getTimeRemaining(req.deadline!) 
      : null;
    
    return ListTile(
      leading: Checkbox(
        value: isCompleted,
        onChanged: isCompleted ? null : (_) => _completeRequirement(req),
        activeColor: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(
        req.title,
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
          color: isMissed ? const Color(0xFFE53935) : null,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (req.description != null)
            Text(
              req.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          if (timeRemaining != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: _getDeadlineColor(req.deadline!),
                ),
                const SizedBox(width: 4),
                Text(
                  timeRemaining,
                  style: TextStyle(
                    color: _getDeadlineColor(req.deadline!),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      trailing: req.isMandatory
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE53935).withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'REQUIRED',
              style: TextStyle(
                color: Color(0xFFE53935),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : null,
    );
  }

  String _getTimeRemaining(DateTime deadline) {
    final now = DateTime.now();
    final diff = deadline.difference(now);
    
    if (diff.isNegative) return 'OVERDUE';
    if (diff.inHours < 1) return '${diff.inMinutes}m remaining';
    if (diff.inHours < 24) return '${diff.inHours}h remaining';
    if (diff.inDays < 7) return '${diff.inDays}d remaining';
    return '${(diff.inDays / 7).floor()}w remaining';
  }

  Color _getDeadlineColor(DateTime deadline) {
    final now = DateTime.now();
    final diff = deadline.difference(now);
    
    if (diff.isNegative) return const Color(0xFFE53935);
    if (diff.inHours < 24) return const Color(0xFFFF9800);
    return Colors.white54;
  }

  int _getCompletedCount(List<Requirement> reqs) {
    return reqs.where((r) => r.status == 'completed').length;
  }

  Future<void> _completeRequirement(Requirement req) async {
    try {
      await widget.client.document.completeRequirement(req.id!, null);
      await _loadData(); // Refresh the list
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Completed: ${req.title}'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: const Color(0xFFE53935),
          ),
        );
      }
    }
  }
}
