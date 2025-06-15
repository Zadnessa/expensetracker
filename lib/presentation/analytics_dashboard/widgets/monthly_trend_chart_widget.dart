import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MonthlyTrendChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> monthlyData;

  const MonthlyTrendChartWidget({
    super.key,
    required this.monthlyData,
  });

  @override
  State<MonthlyTrendChartWidget> createState() =>
      _MonthlyTrendChartWidgetState();
}

class _MonthlyTrendChartWidgetState extends State<MonthlyTrendChartWidget> {
  List<Color> gradientColors = [
    const Color(0xFF2E7D32),
    const Color(0xFF4CAF50),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Spending Trend',
                style: AppTheme.lightTheme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  CustomIconWidget(
                      iconName: 'trending_up',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 16),
                  SizedBox(width: 1.w),
                  Text('+12.5%',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600)),
                ])),
          ]),
          SizedBox(height: 3.h),
          SizedBox(
              height: 25.h,
              child: LineChart(LineChartData(
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 500,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            strokeWidth: 1);
                      }),
                  titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                if (value.toInt() >= 0 &&
                                    value.toInt() < widget.monthlyData.length) {
                                  return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                          widget.monthlyData[value.toInt()]
                                              ['month'] as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall));
                                }
                                return const Text('');
                              })),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: 500,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text(
                                    '\$${(value / 1000).toStringAsFixed(1)}k',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall);
                              },
                              reservedSize: 42))),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (widget.monthlyData.length - 1).toDouble(),
                  minY: 0,
                  maxY: 4000,
                  lineBarsData: [
                    LineChartBarData(
                        spots: widget.monthlyData.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(),
                              entry.value['amount'] as double);
                        }).toList(),
                        isCurved: true,
                        gradient: LinearGradient(colors: gradientColors),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                  radius: 4,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  strokeWidth: 2,
                                  strokeColor:
                                      AppTheme.lightTheme.colorScheme.surface);
                            }),
                        belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                                colors: gradientColors
                                    .map(
                                        (color) => color.withValues(alpha: 0.1))
                                    .toList()))),
                  ],
                  lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              final flSpot = barSpot;
                              if (flSpot.x.toInt() >= 0 &&
                                  flSpot.x.toInt() <
                                      widget.monthlyData.length) {
                                final monthData =
                                    widget.monthlyData[flSpot.x.toInt()];
                                return LineTooltipItem(
                                    '${monthData['month']}\n\$${flSpot.y.toStringAsFixed(2)}',
                                    AppTheme.lightTheme.textTheme.bodySmall!
                                        .copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurface,
                                            fontWeight: FontWeight.w600));
                              }
                              return null;
                            }).toList();
                          }))))),
        ]));
  }
}
