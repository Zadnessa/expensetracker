import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_chip_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/recent_expense_card_widget.dart';
import './widgets/spending_summary_card_widget.dart';
import './widgets/weekly_chart_widget.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;
  bool _showBudgetAlert = true;
  int _selectedBottomNavIndex = 0;

  // Mock data for expenses
  final List<Map<String, dynamic>> _recentExpenses = [
    {
      "id": 1,
      "amount": 45.50,
      "category": "Food",
      "categoryIcon": "restaurant",
      "description": "Lunch at downtown cafe",
      "date": DateTime.now().subtract(const Duration(hours: 2)),
      "currency": "\$"
    },
    {
      "id": 2,
      "amount": 120.00,
      "category": "Transportation",
      "categoryIcon": "directions_car",
      "description": "Gas station fill-up",
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "currency": "\$"
    },
    {
      "id": 3,
      "amount": 89.99,
      "category": "Shopping",
      "categoryIcon": "shopping_bag",
      "description": "Grocery shopping",
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "currency": "\$"
    },
    {
      "id": 4,
      "amount": 25.00,
      "category": "Entertainment",
      "categoryIcon": "movie",
      "description": "Movie tickets",
      "date": DateTime.now().subtract(const Duration(days: 3)),
      "currency": "\$"
    },
    {
      "id": 5,
      "amount": 150.00,
      "category": "Bills",
      "categoryIcon": "receipt_long",
      "description": "Electricity bill",
      "date": DateTime.now().subtract(const Duration(days: 4)),
      "currency": "\$"
    }
  ];

  // Mock data for categories
  final List<Map<String, dynamic>> _categories = [
    {
      "name": "Food",
      "icon": "restaurant",
      "spent": 245.50,
      "budget": 400.00,
      "color": Color(0xFFFF6B6B)
    },
    {
      "name": "Transport",
      "icon": "directions_car",
      "spent": 180.00,
      "budget": 300.00,
      "color": Color(0xFF4ECDC4)
    },
    {
      "name": "Shopping",
      "icon": "shopping_bag",
      "spent": 320.99,
      "budget": 500.00,
      "color": Color(0xFF45B7D1)
    },
    {
      "name": "Bills",
      "icon": "receipt_long",
      "spent": 450.00,
      "budget": 600.00,
      "color": Color(0xFFF9CA24)
    },
    {
      "name": "Entertainment",
      "icon": "movie",
      "spent": 125.00,
      "budget": 200.00,
      "color": Color(0xFF6C5CE7)
    }
  ];

  // Mock data for weekly chart
  final List<Map<String, dynamic>> _weeklyData = [
    {"day": "Mon", "amount": 45.50, "date": "Dec 16"},
    {"day": "Tue", "amount": 89.99, "date": "Dec 17"},
    {"day": "Wed", "amount": 25.00, "date": "Dec 18"},
    {"day": "Thu", "amount": 150.00, "date": "Dec 19"},
    {"day": "Fri", "amount": 120.00, "date": "Dec 20"},
    {"day": "Sat", "amount": 75.25, "date": "Dec 21"},
    {"day": "Sun", "amount": 32.80, "date": "Dec 22"}
  ];

  double get _totalSpent {
    return (_recentExpenses as List)
        .map((expense) => (expense as Map<String, dynamic>)["amount"] as double)
        .fold(0.0, (sum, amount) => sum + amount);
  }

  double get _totalBudget => 2000.00;
  double get _remainingBudget => _totalBudget - _totalSpent;
  double get _spentPercentage => (_totalSpent / _totalBudget) * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child:
            _recentExpenses.isEmpty ? _buildEmptyState() : _buildMainContent(),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildEmptyState() {
    return const EmptyStateWidget();
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 2.h),
            if (_showBudgetAlert) _buildBudgetAlert(),
            if (_showBudgetAlert) SizedBox(height: 2.h),
            _buildSpendingSummaryCard(),
            SizedBox(height: 3.h),
            _buildCategoriesSection(),
            SizedBox(height: 3.h),
            _buildRecentExpensesSection(),
            SizedBox(height: 3.h),
            _buildWeeklyChartSection(),
            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning!',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              'December 2024',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => _handleRefresh(),
              icon: CustomIconWidget(
                iconName: 'sync',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              icon: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetAlert() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.getSemanticColor('warning', isLight: true)
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.getSemanticColor('warning', isLight: true)
              .withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'warning',
            color: AppTheme.getSemanticColor('warning', isLight: true),
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'You\'ve spent 75% of your monthly budget',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.getSemanticColor('warning', isLight: true),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _showBudgetAlert = false),
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.getSemanticColor('warning', isLight: true),
              size: 18,
            ),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingSummaryCard() {
    return SpendingSummaryCardWidget(
      totalSpent: _totalSpent,
      totalBudget: _totalBudget,
      remainingBudget: _remainingBudget,
      spentPercentage: _spentPercentage,
      currency: '\$',
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/analytics-dashboard'),
              child: Text(
                'View All',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        SizedBox(
          height: 12.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final category = _categories[index];
              return CategoryChipWidget(
                name: category["name"] as String,
                icon: category["icon"] as String,
                spent: category["spent"] as double,
                budget: category["budget"] as double,
                color: category["color"] as Color,
                currency: '\$',
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentExpensesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Expenses',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/expense-list'),
              child: Text(
                'View All',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _recentExpenses.length > 5 ? 5 : _recentExpenses.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemBuilder: (context, index) {
            final expense = _recentExpenses[index];
            return RecentExpenseCardWidget(
              expense: expense,
              onEdit: () => _handleEditExpense(expense["id"] as int),
              onDelete: () => _handleDeleteExpense(expense["id"] as int),
              onLongPress: () => _showExpenseContextMenu(expense),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWeeklyChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This Week',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.5.h),
        WeeklyChartWidget(
          weeklyData: _weeklyData,
          currency: '\$',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, '/add-edit-expense'),
      tooltip: 'Add Expense',
      child: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor!,
        size: 28,
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedBottomNavIndex,
      onTap: _handleBottomNavTap,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: _selectedBottomNavIndex == 0
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'list',
            color: _selectedBottomNavIndex == 1
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Expenses',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'analytics',
            color: _selectedBottomNavIndex == 2
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'settings',
            color: _selectedBottomNavIndex == 3
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Settings',
        ),
      ],
    );
  }

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Expenses updated',
            style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
          ),
          backgroundColor: AppTheme.lightTheme.snackBarTheme.backgroundColor,
          behavior: AppTheme.lightTheme.snackBarTheme.behavior,
          shape: AppTheme.lightTheme.snackBarTheme.shape,
        ),
      );
    }
  }

  void _handleBottomNavTap(int index) {
    if (index == _selectedBottomNavIndex) return;

    setState(() => _selectedBottomNavIndex = index);

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/expense-list');
        break;
      case 2:
        Navigator.pushNamed(context, '/analytics-dashboard');
        break;
      case 3:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  void _handleEditExpense(int expenseId) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(
      context,
      '/add-edit-expense',
      arguments: {'expenseId': expenseId, 'isEdit': true},
    );
  }

  void _handleDeleteExpense(int expenseId) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Expense',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete this expense?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _recentExpenses.removeWhere(
                  (expense) =>
                      (expense)["id"] == expenseId,
                );
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Expense deleted')),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: AppTheme.getSemanticColor('error', isLight: true),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExpenseContextMenu(Map<String, dynamic> expense) {
    HapticFeedback.heavyImpact();
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
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: const Text('Edit Expense'),
              onTap: () {
                Navigator.pop(context);
                _handleEditExpense(expense["id"] as int);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'content_copy',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: const Text('Duplicate'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/add-edit-expense',
                  arguments: {'duplicateFrom': expense},
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.getSemanticColor('error', isLight: true),
                size: 24,
              ),
              title: Text(
                'Delete',
                style: TextStyle(
                  color: AppTheme.getSemanticColor('error', isLight: true),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _handleDeleteExpense(expense["id"] as int);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
