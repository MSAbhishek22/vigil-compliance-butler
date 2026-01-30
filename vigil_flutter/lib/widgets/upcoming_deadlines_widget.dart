import 'package:flutter/material.dart';

/// UpcomingDeadlinesWidget - Timeline of Approaching Deadlines
/// 
/// Shows the next few deadlines with urgency indicators.
class UpcomingDeadlinesWidget extends StatelessWidget {
  final List<Map<String, dynamic>>? deadlines;
  final bool isLoading;
  final Function(int)? onTap;
  
  const UpcomingDeadlinesWidget({
    super.key,
    this.deadlines,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.upcoming,
              color: Theme.of(context).colorScheme.secondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'UPCOMING DEADLINES',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        if (isLoading)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
          )
        else if (deadlines == null || deadlines!.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No upcoming deadlines',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Card(
            child: Column(
              children: deadlines!.asMap().entries.map((entry) {
                final index = entry.key;
                final deadline = entry.value;
                return _DeadlineItem(
                  deadline: deadline,
                  isLast: index == deadlines!.length - 1,
                  onTap: onTap,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _DeadlineItem extends StatelessWidget {
  final Map<String, dynamic> deadline;
  final bool isLast;
  final Function(int)? onTap;

  const _DeadlineItem({
    required this.deadline,
    required this.isLast,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hoursRemaining = deadline['hoursRemaining'] as int;
    final isUrgent = deadline['isUrgent'] == true;
    final isCritical = deadline['isCritical'] == true;
    
    final color = isCritical 
      ? const Color(0xFFE53935)
      : isUrgent 
        ? const Color(0xFFFF9800)
        : Theme.of(context).colorScheme.secondary;
    
    return InkWell(
      onTap: onTap != null ? () => onTap!(deadline['id'] as int) : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: isLast ? null : Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        child: Row(
          children: [
            // Timeline indicator
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deadline['title'] as String,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimeRemaining(hoursRemaining),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Urgency badge
            if (isCritical)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.warning, size: 12, color: Color(0xFFE53935)),
                    SizedBox(width: 4),
                    Text(
                      'CRITICAL',
                      style: TextStyle(
                        color: Color(0xFFE53935),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            else if (deadline['isMandatory'] == true)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'REQUIRED',
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.white38),
          ],
        ),
      ),
    );
  }

  String _formatTimeRemaining(int hours) {
    if (hours < 0) return 'OVERDUE';
    if (hours < 1) return 'Less than 1 hour!';
    if (hours < 24) return '$hours hours remaining';
    final days = hours ~/ 24;
    if (days == 1) return '1 day remaining';
    if (days < 7) return '$days days remaining';
    final weeks = days ~/ 7;
    return '$weeks week${weeks > 1 ? 's' : ''} remaining';
  }
}
