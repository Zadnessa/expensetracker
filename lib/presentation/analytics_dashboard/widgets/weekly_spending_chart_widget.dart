import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class WeeklySpendingChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> weeklyData;

  const WeeklySpendingChartWidget({
    super.key,
    required this.weeklyData,
  });

  @override
  State<WeeklySpendingChartWidget> createState() =>
      _WeeklySpendingChartWidgetState();
}

class _WeeklySpendingChartWidgetState extends State<WeeklySpendingChartWidget> {
  int touchedIndex = -1;

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
            Text('Weekly Spending Pattern',
                style: AppTheme.lightTheme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: Text('This Week',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        fontWeight: FontWeight.w600))),
          ]),
          SizedBox(height: 3.h),
          SizedBox(
              height: 25.h,
              child: BarChart(BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxAmount() * 1.2,
                  barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final dayData = widget.weeklyData[group.x.toInt()];
                            return BarTooltipItem(
                                '${dayData['day']}\n\$${rod.toY.toStringAsFixed(2)}',
                                AppTheme.lightTheme.textTheme.bodySmall!
                                    .copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                        fontWeight: FontWeight.w600));
                          }),
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              barTouchResponse == null ||
                              barTouchResponse.spot == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex =
                              barTouchResponse.spot!.touchedBarGroupIndex;
                        });
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
                              getTitlesWidget: (double value, TitleMeta meta) {
                                if (value.toInt() >= 0 &&
                                    value.toInt() < widget.weeklyData.length) {
                                  return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                          widget.weeklyData[value.toInt()]
                                              ['day'] as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall));
                                }
                                return const Text('');
                              },
                              reservedSize: 30)),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: 100,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text('\$${value.toInt()}',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall);
                              }))),
                  borderData: FlBorderData(show: false),
                  barGroups: _buildBarGroups(),
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 100,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            strokeWidth: 1);
                      })))),
          SizedBox(height: 2.h),
          _buildWeeklyInsights(),
        ]));
  }

  List<BarChartGroupData> _buildBarGroups() {
    return widget.weeklyData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final amount = data['amount'] as double;
      final isTouched = index == touchedIndex;

      // Weekend days (Friday, Saturday, Sunday) get different colors
      final isWeekend = ['Fri', 'Sat', 'Sun'].contains(data['day']);
      final barColor = isWeekend
          ? AppTheme.lightTheme.colorScheme.secondary
          : AppTheme.lightTheme.colorScheme.primary;

      return BarChartGroupData(x: index, barRods: [
        BarChartRodData(
            toY: amount,
            color: isTouched ? barColor.withValues(alpha: 0.8) : barColor,
            width: isTouched ? 5.w : 4.w,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: _getMaxAmount() * 1.2,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.1))),
      ]);
    }).toList();
  }

  double _getMaxAmount() {
    return widget.weeklyData
        .map((data) => data['amount'] as double)
        .reduce((a, b) => a > b ? a : b);
  }

  Widget _buildWeeklyInsights() {
    final weekdayTotal = widget.weeklyData
        .where((data) => !['Fri', 'Sat', 'Sun'].contains(data['day']))
        .fold<double>(0.0, (sum, data) => sum + (data['amount'] as double));

    final weekendTotal = widget.weeklyData
        .where((data) => ['Fri', 'Sat', 'Sun'].contains(data['day']))
        .fold<double>(0.0, (sum, data) => sum + (data['amount'] as double));

    final weekendPercentage =
        ((weekendTotal / (weekdayTotal + weekendTotal)) * 100);

    return Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2))),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Weekday Spending',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6))),
                Text('\$${weekdayTotal.toStringAsFixed(2)}',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600)),
              ])),
          Container(
              width: 1,
              height: 5.h,
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2)),
          Expanded(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('Weekend Spending',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6))),
            Text('\$${weekendTotal.toStringAsFixed(2)}',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    fontWeight: FontWeight.w600)),
            Text('${weekendPercentage.toStringAsFixed(1)}% of total',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6))),
          ])),
        ]));
  }
}
