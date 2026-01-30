import 'package:flutter/material.dart';

/// ButlerStatusWidget - The "Butler is Working" Indicator
/// 
/// Shows the current status of the Butler with animated pulsing.
class ButlerStatusWidget extends StatefulWidget {
  final bool isActive;
  final String message;
  
  const ButlerStatusWidget({
    super.key,
    required this.isActive,
    required this.message,
  });

  @override
  State<ButlerStatusWidget> createState() => _ButlerStatusWidgetState();
}

class _ButlerStatusWidgetState extends State<ButlerStatusWidget> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isActive 
            ? Theme.of(context).colorScheme.secondary.withOpacity(0.3)
            : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          // Pulsing indicator
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isActive 
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.white38,
                  boxShadow: widget.isActive ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.secondary
                          .withOpacity(_pulseAnimation.value * 0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ] : null,
                ),
              );
            },
          ),
          
          const SizedBox(width: 12),
          
          // Status icon
          Icon(
            widget.isActive ? Icons.visibility : Icons.visibility_off,
            size: 18,
            color: widget.isActive 
              ? Theme.of(context).colorScheme.secondary
              : Colors.white38,
          ),
          
          const SizedBox(width: 8),
          
          // Message
          Expanded(
            child: Text(
              widget.message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: widget.isActive ? Colors.white : Colors.white54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
