import 'package:flutter/material.dart';
import 'dart:math' as math;

/// VigilanceScoreWidget - The "Peace of Mind" Indicator
/// 
/// A circular gauge showing the percentage of compliance.
/// Features smooth animations and color-coded status.
class VigilanceScoreWidget extends StatefulWidget {
  final Map<String, dynamic>? data;
  final bool isLoading;
  final String? error;
  
  const VigilanceScoreWidget({
    super.key,
    this.data,
    this.isLoading = false,
    this.error,
  });

  @override
  State<VigilanceScoreWidget> createState() => _VigilanceScoreWidgetState();
}

class _VigilanceScoreWidgetState extends State<VigilanceScoreWidget> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scoreAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scoreAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didUpdateWidget(VigilanceScoreWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.data != null && widget.data != oldWidget.data) {
      final score = (widget.data!['score'] as num).toDouble();
      _scoreAnimation = Tween<double>(
        begin: _scoreAnimation.value,
        end: score,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.error != null) {
      return _buildErrorCard();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Title
            Row(
              children: [
                Icon(
                  Icons.shield,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'VIGILANCE SCORE',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Score Gauge
            SizedBox(
              height: 180,
              width: 180,
              child: widget.isLoading
                ? const Center(child: CircularProgressIndicator())
                : AnimatedBuilder(
                    animation: _scoreAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _ScoreGaugePainter(
                          score: _scoreAnimation.value,
                          color: _getScoreColor(_scoreAnimation.value),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${_scoreAnimation.value.round()}%',
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                _getScoreLabel(_scoreAnimation.value),
                                style: TextStyle(
                                  color: _getScoreColor(_scoreAnimation.value),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ),
            
            const SizedBox(height: 24),
            
            // Stats row
            if (widget.data != null && !widget.isLoading)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    label: 'Completed',
                    value: '${widget.data!['completed']}',
                    color: const Color(0xFF4CAF50),
                  ),
                  _StatItem(
                    label: 'Pending',
                    value: '${widget.data!['pending']}',
                    color: const Color(0xFFFF9800),
                  ),
                  _StatItem(
                    label: 'Missed',
                    value: '${widget.data!['missed']}',
                    color: const Color(0xFFE53935),
                  ),
                ],
              ),
            
            if (widget.data?['message'] != null) ...[
              const SizedBox(height: 16),
              Text(
                widget.data!['message'],
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.cloud_off, size: 48, color: Colors.white54),
            const SizedBox(height: 16),
            Text(
              'Unable to load score',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Check your connection',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return const Color(0xFF4CAF50);
    if (score >= 50) return const Color(0xFFFF9800);
    return const Color(0xFFE53935);
  }

  String _getScoreLabel(double score) {
    if (score >= 90) return 'EXCELLENT';
    if (score >= 70) return 'GOOD';
    if (score >= 50) return 'AT RISK';
    return 'CRITICAL';
  }
}

/// Custom painter for the score gauge with Gradient and Glow
class _ScoreGaugePainter extends CustomPainter {
  final double score;
  final Color color;
  
  _ScoreGaugePainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    
    // Background arc (Darker track)
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75,
      math.pi * 1.5,
      false,
      bgPaint,
    );
    
    // Score arc Gradient
    final gradient = SweepGradient(
      startAngle: -math.pi * 0.75,
      endAngle: math.pi * 0.75,
      colors: [
        color.withOpacity(0.5),
        color,
      ],
      stops: const [0.0, 1.0],
      transform: GradientRotation(-math.pi / 2),
    );

    final scorePaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    
    // Add Glow Effect
    final glowPaint = Paint()
      ..color = color.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final sweepAngle = (score / 100) * math.pi * 1.5;
    
    // Draw Glow
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75,
      sweepAngle,
      false,
      glowPaint,
    );

    // Draw Main Arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75,
      sweepAngle,
      false,
      scorePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScoreGaugePainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.color != color;
  }
}

/// Stat item widget
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
