import 'package:flutter/material.dart';

import '../../../models/weight_entry.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../utils/date_format.dart';

/// Card at the bottom of Home showing the latest weight, its date
/// and a small line chart of the weight history.
class LatestWeightCard extends StatelessWidget {
  /// Weight entries of the active pet, oldest first.
  final List<WeightEntry> entries;
  final VoidCallback onTap;

  const LatestWeightCard({
    super.key,
    required this.entries,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Left side: the latest weight, or a message if there is none.
    Widget weightInfo;
    if (entries.isEmpty) {
      weightInfo = const Text(
        'No entries yet',
        style: TextStyle(fontSize: 14, color: AppColors.darkGreen),
      );
    } else {
      final latest = entries.last;
      weightInfo = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${latest.weightKg}',
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  color: AppColors.darkGreen,
                ),
              ),
              const SizedBox(width: 2),
              const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  'kg',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
            ],
          ),
          Text(
            'Updated ${formatDate(latest.date)}',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      );
    }

    // Weights as a simple list of numbers for the chart.
    final weights = <double>[];
    for (final entry in entries) {
      weights.add(entry.weightKg);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md - 2, // 14
          vertical: 10,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.background, AppColors.lightMint],
          ),
          border: Border.all(color: AppColors.weightCardBorder),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LATEST WEIGHT',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 2),
                weightInfo,
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: SizedBox(
                height: 56,
                child: CustomPaint(
                  painter: _WeightLinePainter(weights: weights),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Draws the weights as a green line with a dot on each value.
/// The latest dot is a little bigger.
class _WeightLinePainter extends CustomPainter {
  final List<double> weights;

  _WeightLinePainter({required this.weights});

  @override
  void paint(Canvas canvas, Size size) {
    // A line needs at least two points.
    if (weights.length < 2) return;

    // Find the lowest and highest weight.
    var lowest = weights.first;
    var highest = weights.first;
    for (final w in weights) {
      if (w < lowest) lowest = w;
      if (w > highest) highest = w;
    }
    final range = highest - lowest;

    // Leave a little space so the dots are not cut at the edges.
    const padding = 5.0;
    final width = size.width - padding * 2;
    final height = size.height - padding * 2;

    // Work out where each weight goes on the card.
    final points = <Offset>[];
    for (var i = 0; i < weights.length; i++) {
      final x = padding + width * i / (weights.length - 1);
      double ratio = 0.5; // middle, if all weights are the same
      if (range > 0) {
        ratio = (weights[i] - lowest) / range;
      }
      // Heavier = higher, so we subtract from the bottom.
      final y = padding + height * (1 - ratio);
      points.add(Offset(x, y));
    }

    // The line.
    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    // The dots.
    final dotPaint = Paint()..color = AppColors.primary;
    for (var i = 0; i < points.length; i++) {
      final isLatest = i == points.length - 1;
      canvas.drawCircle(points[i], isLatest ? 4.5 : 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_WeightLinePainter oldDelegate) {
    return oldDelegate.weights != weights;
  }
}