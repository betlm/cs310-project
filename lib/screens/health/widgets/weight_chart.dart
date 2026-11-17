
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../models/weight_entry.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class WeightChart extends StatelessWidget {
  final List<WeightEntry> entries;

  const WeightChart({
    super.key,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final endDate = entries.isEmpty
        ? DateTime.now()
        : entries.last.date;

    final firstMonth = DateTime(
      endDate.year,
      endDate.month - 5,
      1,
    );

    final lastMonth = DateTime(
      endDate.year,
      endDate.month,
      1,
    );

    final chartEntries = entries.where((entry) {
      final month = DateTime(
        entry.date.year,
        entry.date.month,
        1,
      );

      return !month.isBefore(firstMonth) &&
          !month.isAfter(lastMonth);
    }).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1.3,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Weight change',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                'Last 6 months',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 205,
            width: double.infinity,
            child: chartEntries.isEmpty
                ? Center(
                    child: Text(
                      'No weight data yet',
                      style: AppTextStyles.bodyMedium,
                    ),
                  )
                : CustomPaint(
                    painter: _WeightChartPainter(
                      entries: chartEntries,
                      firstMonth: firstMonth,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  final List<WeightEntry> entries;
  final DateTime firstMonth;

  const _WeightChartPainter({
    required this.entries,
    required this.firstMonth,
  });

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const left = 32.0;
    const right = 12.0;
    const top = 12.0;
    const bottom = 27.0;

    final width = size.width - left - right;
    final height = size.height - top - bottom;

    if (width <= 0 || height <= 0 || entries.isEmpty) {
      return;
    }

    final weights = entries
        .map((entry) => entry.weightKg)
        .toList();

    final minWeight = weights.reduce(math.min);
    final maxWeight = weights.reduce(math.max);

    final minAxis =
        (math.max(0, minWeight - 0.2) * 2).floor() / 2;

    final maxAxis =
        ((maxWeight + 0.2) * 2).ceil() / 2;

    final range = math.max(0.5, maxAxis - minAxis);

    final labelStyle = AppTextStyles.caption.copyWith(
      fontSize: 9,
      color: AppColors.navInactive,
      fontWeight: FontWeight.w600,
    );

    void drawLabel(
      String value,
      double x,
      double y, {
      double maxWidth = 40,
    }) {
      final painter = TextPainter(
        text: TextSpan(
          text: value,
          style: labelStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: maxWidth);

      painter.paint(canvas, Offset(x, y));
    }

    // Vertical axis labels
    for (var i = 0; i < 3; i++) {
      final value = maxAxis - range * i / 2;
      final y = top + height * i / 2;

      drawLabel(
        value.toStringAsFixed(1),
        0,
        y - 6,
      );
    }

    double monthX(int index) {
      return left + width * index / 5;
    }

    // Horizontal axis month labels
    for (var i = 0; i < 6; i++) {
      final month = DateTime(
        firstMonth.year,
        firstMonth.month + i,
      );

      drawLabel(
        _months[month.month - 1],
        monthX(i) - 11,
        size.height - 15,
        maxWidth: 28,
      );
    }

    final points = <Offset>[];

    // Convert weight records into chart points
    for (final entry in entries) {
      final monthIndex =
          (entry.date.year - firstMonth.year) * 12 +
          entry.date.month -
          firstMonth.month;

      if (monthIndex < 0 || monthIndex > 5) {
        continue;
      }

      final x = monthX(monthIndex);

      final y =
          top + height * (maxAxis - entry.weightKg) / range;

      points.add(Offset(x, y));
    }

    if (points.isEmpty) return;

    final baseline = top + height;

    // Area below the line
    final fillPath = Path()
      ..moveTo(points.first.dx, baseline)
      ..lineTo(points.first.dx, points.first.dy);

    for (var i = 1; i < points.length; i++) {
      fillPath.lineTo(
        points[i].dx,
        points[i].dy,
      );
    }

    fillPath
      ..lineTo(points.last.dx, baseline)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..color = AppColors.lightMint
        ..style = PaintingStyle.fill,
    );

    // Weight trend line
    final linePath = Path()
      ..moveTo(
        points.first.dx,
        points.first.dy,
      );

    for (var i = 1; i < points.length; i++) {
      linePath.lineTo(
        points[i].dx,
        points[i].dy,
      );
    }

    canvas.drawPath(
      linePath,
      Paint()
        ..color = AppColors.primary
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );

    // Circular markers
    for (final point in points) {
      canvas.drawCircle(
        point,
        5,
        Paint()
          ..color = AppColors.white
          ..style = PaintingStyle.fill,
      );

      canvas.drawCircle(
        point,
        5,
        Paint()
          ..color = AppColors.primary
          ..strokeWidth = 2.2
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _WeightChartPainter oldDelegate,
  ) {
    if (oldDelegate.firstMonth != firstMonth ||
        oldDelegate.entries.length != entries.length) {
      return true;
    }

    for (var i = 0; i < entries.length; i++) {
      final oldEntry = oldDelegate.entries[i];
      final newEntry = entries[i];

      if (oldEntry.id != newEntry.id ||
          oldEntry.weightKg != newEntry.weightKg ||
          oldEntry.date != newEntry.date) {
        return true;
      }
    }

    return false;
  }
}
