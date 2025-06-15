import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/dashboard_home/dashboard_home.dart';
import '../presentation/expense_list/expense_list.dart';
import '../presentation/add_edit_expense/add_edit_expense.dart';
import '../presentation/settings/settings.dart';
import '../presentation/analytics_dashboard/analytics_dashboard.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String dashboardHome = '/dashboard-home';
  static const String addEditExpense = '/add-edit-expense';
  static const String expenseList = '/expense-list';
  static const String analyticsDashboard = '/analytics-dashboard';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    dashboardHome: (context) => const DashboardHome(),
    addEditExpense: (context) => const AddEditExpense(),
    expenseList: (context) => const ExpenseList(),
    analyticsDashboard: (context) => const AnalyticsDashboard(),
    settings: (context) => const Settings(),
  };
}
