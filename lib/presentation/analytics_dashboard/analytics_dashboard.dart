import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_comparison_widget.dart';
import './widgets/date_range_picker_widget.dart';
import './widgets/insights_card_widget.dart';
import './widgets/monthly_trend_chart_widget.dart';
import './widgets/period_selector_widget.dart';
import './widgets/spending_breakdown_chart_widget.dart';
import './widgets/weekly_spending_chart_widget.dart';

class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({super.key});

  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard> {
  String selectedPeriod = 'This Month';
  bool isLoading = false;
  DateTimeRange? customDateRange;

  // Mock data for analytics
  final List<Map<String, dynamic>> spendingData = [
    {
      "category": "Food & Dining",
      "amount": 1250.0,
      "percentage": 35.0,
      "color": const Color(0xFFFF6B6B),
      "icon": "restaurant"
    },
    {
      "category": "Transportation",
      "amount": 800.0,
      "percentage": 22.5,
      "color": const Color(0xFF4ECDC4),
      "icon": "directions_car"
    },
    {
      "category": "Shopping",
      "amount": 650.0,
      "percentage": 18.2,
      "color": const Color(0xFF45B7D1),
      "icon": "shopping_bag"
    },
    {
      "category": "Entertainment",
      "amount": 450.0,
      "percentage": 12.6,
      "color": const Color(0xFF96CEB4),
      "icon": "movie"
    },
    {
      "category": "Bills & Utilities",
      "amount": 420.0,
      "percentage": 11.7,
      "color": const Color(0xFFFECA57),
      "icon": "receipt"
    }
  ];

  final List<Map<String, dynamic>> monthlyTrendData = [
    {"month": "Jan", "amount": 2800.0},
    {"month": "Feb", "amount": 3200.0},
    {"month": "Mar", "amount": 2950.0},
    {"month": "Apr", "amount": 3400.0},
    {"month": "May", "amount": 3100.0},
    {"month": "Jun", "amount": 3570.0}
  ];

  final List<Map<String, dynamic>> weeklySpendingData = [
    {"day": "Mon", "amount": 120.0},
    {"day": "Tue", "amount": 85.0},
    {"day": "Wed", "amount": 200.0},
    {"day": "Thu", "amount": 150.0},
    {"day": "Fri", "amount": 300.0},
    {"day": "Sat", "amount": 450.0},
    {"day": "Sun", "amount": 180.0}
  ];

  final List<Map<String, dynamic>> insightsData = [
    {
      "title": "High Weekend Spending",
      "description":
          "You spend 40% more on weekends compared to weekdays. Consider setting weekend budgets.",
      "type": "warning",
      "icon": "trending_up"
    },
    {
      "title": "Food Budget Exceeded",
      "description":
          "Food expenses are 15% above your monthly budget. Try meal planning to reduce costs.",
      "type": "error",
      "icon": "restaurant"
    },
    {
      "title": "Transportation Savings",
      "description":
          "Great job! You've saved \$200 on transportation this month compared to last month.",
      "type": "success",
      "icon": "savings"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Analytics Dashboard',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showExportOptions,
            icon: CustomIconWidget(
              iconName: 'download',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: isLoading ? _buildLoadingState() : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period Selector
          PeriodSelectorWidget(
            selectedPeriod: selectedPeriod,
            onPeriodChanged: _onPeriodChanged,
            onCustomRangeSelected: _showDateRangePicker,
          ),
          SizedBox(height: 3.h),

          // Total Spending Summary
          _buildTotalSpendingCard(),
          SizedBox(height: 3.h),

          // Spending Breakdown Chart
          Text(
            'Spending Breakdown',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          SpendingBreakdownChartWidget(
            spendingData: spendingData,
            onCategoryTap: _onCategoryTap,
          ),
          SizedBox(height: 4.h),

          // Monthly Trend Chart
          Text(
            'Monthly Trend',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          MonthlyTrendChartWidget(
            monthlyData: monthlyTrendData,
          ),
          SizedBox(height: 4.h),

          // Category Comparison
          Text(
            'Category Comparison',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          CategoryComparisonWidget(
            categoryData: spendingData,
          ),
          SizedBox(height: 4.h),

          // Weekly Spending Pattern
          Text(
            'Weekly Pattern',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          WeeklySpendingChartWidget(
            weeklyData: weeklySpendingData,
          ),
          SizedBox(height: 4.h),

          // Insights Section
          Text(
            'Insights & Recommendations',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...insightsData.map((insight) => InsightsCardWidget(
                title: insight['title'],
                description: insight['description'],
                type: insight['type'],
                iconName: insight['icon'],
              )),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildTotalSpendingCard() {
    final totalAmount = spendingData.fold<double>(
      0.0,
      (sum, item) => sum + (item['amount'] as double),
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Spending',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            '\$${totalAmount.toStringAsFixed(2)}',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            selectedPeriod,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary
                  .withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Loading skeleton for period selector
          Container(
            height: 6.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          SizedBox(height: 3.h),

          // Loading skeleton for total spending card
          Container(
            width: double.infinity,
            height: 15.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          SizedBox(height: 3.h),

          // Loading skeleton for charts
          ...List.generate(
              3,
              (index) => Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      SizedBox(height: 3.h),
                    ],
                  )),
        ],
      ),
    );
  }

  void _onPeriodChanged(String period) {
    setState(() {
      selectedPeriod = period;
      if (period != 'Custom Range') {
        customDateRange = null;
      }
    });
    _refreshData();
  }

  void _onCategoryTap(String category) {
    // Handle category tap - could navigate to detailed view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped on $category'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
  }

  void _showDateRangePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DateRangePickerWidget(
        initialDateRange: customDateRange,
        onDateRangeSelected: (dateRange) {
          setState(() {
            customDateRange = dateRange;
            selectedPeriod = 'Custom Range';
          });
          _refreshData();
        },
      ),
    );
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Export Options',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'picture_as_pdf',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: const Text('Export as PDF'),
              subtitle: const Text('Generate detailed report with charts'),
              onTap: () {
                Navigator.pop(context);
                _exportAsPDF();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'table_chart',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Export as CSV'),
              subtitle: const Text('Raw data for spreadsheet analysis'),
              onTap: () {
                Navigator.pop(context);
                _exportAsCSV();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _exportAsPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF export feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _exportAsCSV() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CSV export feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
