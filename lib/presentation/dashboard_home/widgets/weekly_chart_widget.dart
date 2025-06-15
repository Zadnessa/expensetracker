import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class WeeklyChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> weeklyData;
  final String currency;

  const WeeklyChartWidget({
    super.key,
    required this.weeklyData,
    required this.currency,
  });

  @override
  State<WeeklyChartWidget> createState() => _WeeklyChartWidgetState();
}

class _WeeklyChartWidgetState extends State<WeeklyChartWidget> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: AppTheme.lightTheme.dividerColor, width: 1),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.lightTheme.shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Daily Spending',
                style: AppTheme.lightTheme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            Text(_getTotalWeeklySpending(),
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.lightTheme.primaryColor)),
          ]),
          SizedBox(height: 3.h),
          SizedBox(
              height: 25.h,
              child: Semantics(
                  label: "Weekly Spending Bar Chart",
                  child: BarChart(BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _getMaxAmount() * 1.2,
                      barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                              tooltipRoundedRadius: 8,
                              tooltipPadding: EdgeInsets.all(2.w),
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                final data = widget.weeklyData[group.x.toInt()];
                                return BarTooltipItem(
                                    '${data["date"]}\n${widget.currency}${(data["amount"] as double).toStringAsFixed(2)}',
                                    AppTheme.lightTheme.textTheme.bodySmall!
                                        .copyWith(
                                            color:
                                                AppTheme.lightTheme.cardColor,
                                            fontWeight: FontWeight.w500));
                              }),
                          touchCallback:
                              (FlTouchEvent event, barTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  barTouchResponse == null ||
                                  barTouchResponse.spot == null) {
                                _touchedIndex = -1;
                                return;
                              }
                              _touchedIndex =
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
                                  getTitlesWidget: _getBottomTitles,
                                  reservedSize: 38)),
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  interval: _getMaxAmount() / 4,
                                  getTitlesWidget: _getLeftTitles))),
                      borderData: FlBorderData(show: false),
                      barGroups: _buildBarGroups(),
                      gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: _getMaxAmount() / 4,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                                color: AppTheme.lightTheme.dividerColor,
                                strokeWidth: 1);
                          }))))),
          if (_touchedIndex >= 0) ...[
            SizedBox(height: 2.h),
            _buildTouchedInfo(),
          ],
        ]));
  }

  List<BarChartGroupData> _buildBarGroups() {
    return widget.weeklyData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final amount = data["amount"] as double;
      final isTouched = index == _touchedIndex;

      return BarChartGroupData(x: index, barRods: [
        BarChartRodData(
            toY: amount,
            color: isTouched
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.7),
            width: isTouched ? 6.w : 5.w,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: _getMaxAmount() * 1.2,
                color:
                    AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1))),
      ]);
    }).toList();
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    if (value.toInt() >= widget.weeklyData.length) {
      return const SizedBox.shrink();
    }

    final data = widget.weeklyData[value.toInt()];
    return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(data["day"] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500)));
  }

  Widget _getLeftTitles(double value, TitleMeta meta) {
    if (value == 0) return const SizedBox.shrink();

    return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text('${widget.currency}${value.toInt()}',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 10.sp)));
  }

  Widget _buildTouchedInfo() {
    final data = widget.weeklyData[_touchedIndex];
    return Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                width: 1)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${data["day"]} - ${data["date"]}',
                style: AppTheme.lightTheme.textTheme.labelLarge
                    ?.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: 0.5.h),
            Text('Daily spending',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
          ]),
          Text(
              '${widget.currency}${(data["amount"] as double).toStringAsFixed(2)}',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.primaryColor)),
        ]));
  }

  double _getMaxAmount() {
    return widget.weeklyData
        .map((data) => data["amount"] as double)
        .reduce((a, b) => a > b ? a : b);
  }

  String _getTotalWeeklySpending() {
    final total = widget.weeklyData
        .map((data) => data["amount"] as double)
        .fold(0.0, (sum, amount) => sum + amount);
    return '${widget.currency}${total.toStringAsFixed(2)}';
  }
}
