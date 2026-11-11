import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../models/weight_entry.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../utils/date_format.dart';

/// Card at the bottom of Home showing the latest weight, its date
/// and a small line chart of the weight history.
/// Tapping it opens Weight tracking.
class LatestWeightCard extends StatelessWidget {
  /// Weight entries of the active pet, oldest first.
  final List<WeightEntry> entries;

  const LatestWeightCard({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(AppSpacing.radiusLarge);
    final latest = entries.isEmpty ? null : entries.last;

    return Material(
      color: AppColors.lightMint,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: () => Navigator.pushNamed(context, AppRoutes.weightTracking),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LATEST WEIGHT',
                    style: textTheme.bodySmall?.copyWith(
                      letterSpacing: 1.2,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  if (latest == null)
                    Text(
                      'No entries yet',
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.darkGreen,
                      ),
                    )
                  else ...[
                    // "4.8" big and "kg" small on the same line.
                    Text.rich(
                      TextSpan(
                        text: '${latest.weightKg}',
                        style: textTheme.headlineLarge?.copyWith(
                          color: AppColors.darkGreen,
                        ),
                        children: [
                          TextSpan(
                            text: ' kg',
                            style: textTheme.bodyLarge?.copyWith(
                              color: AppColors.darkGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Updated ${formatDate(latest.date)}',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              // The chart takes all the remaining width.
              Expanded(
                child: SizedBox(
                  height: 70,
                  child: CustomPaint(
                    painter: _WeightSparklinePainter(
                      values: entries.map((e) => e.weightKg).toList(),
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Draws a small line chart: one dot per weight entry, joined by a line.
class _WeightSparklinePainter extends CustomPainter {
  final List<double> values;
  final Color color;

  _WeightSparklinePainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // A line needs at least two points.
    if (values.length < 2) return;

    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    // Avoid dividing by zero when all weights are the same.
    final range = maxValue == minValue ? 1.0 : maxValue - minValue;
    const padding = 6.0;

    // Converts the i-th weight into a point inside the chart area.
    // Higher weights are drawn higher, so the y value is flipped.
    Offset pointAt(int i) {
      final x = padding + (size.width - 2 * padding) * i / (values.length - 1);
      final y = padding +
          (size.height - 2 * padding) * (1 - (values[i] - minValue) / range);
      return Offset(x, y);
    }

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(pointAt(0).dx, pointAt(0).dy);
    for (var i = 1; i < values.length; i++) {
      path.lineTo(pointAt(i).dx, pointAt(i).dy);
    }
    canvas.drawPath(path, linePaint);

    // White dots with a colored border on each data point.
    final dotFill = Paint()..color = AppColors.white;
    final dotBorder = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (var i = 0; i < values.length; i++) {
      canvas.drawCircle(pointAt(i), 4, dotFill);
      canvas.drawCircle(pointAt(i), 4, dotBorder);
    }
  }

  @override
  bool shouldRepaint(_WeightSparklinePainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}