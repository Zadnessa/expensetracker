import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/expense_card_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/sort_dropdown_widget.dart';

class ExpenseList extends StatefulWidget {
  const ExpenseList({super.key});

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _isLoading = false;
  final bool _isSearching = false;
  bool _isMultiSelectMode = false;
  String _sortOption = 'newest';
  List<String> _activeFilters = [];
  final List<String> _selectedExpenseIds = [];
  List<Map<String, dynamic>> _filteredExpenses = [];

  // Mock expense data
  final List<Map<String, dynamic>> _allExpenses = [
    {
      "id": "1",
      "amount": 45.50,
      "currency": "\$",
      "category": "Food",
      "categoryIcon": "restaurant",
      "categoryColor": Color(0xFFFF6B6B),
      "description": "Lunch at Italian restaurant",
      "date": DateTime.now().subtract(Duration(hours: 2)),
      "hasReceipt": true,
    },
    {
      "id": "2",
      "amount": 120.00,
      "currency": "\$",
      "category": "Transportation",
      "categoryIcon": "directions_car",
      "categoryColor": Color(0xFF4ECDC4),
      "description": "Gas station fill-up",
      "date": DateTime.now().subtract(Duration(days: 1)),
      "hasReceipt": false,
    },
    {
      "id": "3",
      "amount": 89.99,
      "currency": "\$",
      "category": "Shopping",
      "categoryIcon": "shopping_bag",
      "categoryColor": Color(0xFF45B7D1),
      "description": "New running shoes",
      "date": DateTime.now().subtract(Duration(days: 2)),
      "hasReceipt": true,
    },
    {
      "id": "4",
      "amount": 25.30,
      "currency": "\$",
      "category": "Entertainment",
      "categoryIcon": "movie",
      "categoryColor": Color(0xFF96CEB4),
      "description": "Movie tickets",
      "date": DateTime.now().subtract(Duration(days: 3)),
      "hasReceipt": false,
    },
    {
      "id": "5",
      "amount": 156.78,
      "currency": "\$",
      "category": "Bills",
      "categoryIcon": "receipt_long",
      "categoryColor": Color(0xFFFECA57),
      "description": "Electricity bill payment",
      "date": DateTime.now().subtract(Duration(days: 4)),
      "hasReceipt": true,
    },
    {
      "id": "6",
      "amount": 67.45,
      "currency": "\$",
      "category": "Healthcare",
      "categoryIcon": "local_hospital",
      "categoryColor": Color(0xFFFF9FF3),
      "description": "Pharmacy prescription",
      "date": DateTime.now().subtract(Duration(days: 5)),
      "hasReceipt": true,
    },
    {
      "id": "7",
      "amount": 34.20,
      "currency": "\$",
      "category": "Food",
      "categoryIcon": "restaurant",
      "categoryColor": Color(0xFFFF6B6B),
      "description": "Grocery shopping",
      "date": DateTime.now().subtract(Duration(days: 6)),
      "hasReceipt": false,
    },
    {
      "id": "8",
      "amount": 200.00,
      "currency": "\$",
      "category": "Transportation",
      "categoryIcon": "directions_car",
      "categoryColor": Color(0xFF4ECDC4),
      "description": "Car maintenance service",
      "date": DateTime.now().subtract(Duration(days: 7)),
      "hasReceipt": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredExpenses = List.from(_allExpenses);
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredExpenses = List.from(_allExpenses);
      } else {
        _filteredExpenses = _allExpenses.where((expense) {
          final description = (expense['description'] as String).toLowerCase();
          final amount = expense['amount'].toString();
          final category = (expense['category'] as String).toLowerCase();
          return description.contains(query) ||
              amount.contains(query) ||
              category.contains(query);
        }).toList();
      }
      _applySorting();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreExpenses();
    }
  }

  void _loadMoreExpenses() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      // Simulate loading more data
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  void _applySorting() {
    switch (_sortOption) {
      case 'newest':
        _filteredExpenses.sort(
            (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
        break;
      case 'oldest':
        _filteredExpenses.sort(
            (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
        break;
      case 'highest':
        _filteredExpenses.sort(
            (a, b) => (b['amount'] as double).compareTo(a['amount'] as double));
        break;
      case 'lowest':
        _filteredExpenses.sort(
            (a, b) => (a['amount'] as double).compareTo(b['amount'] as double));
        break;
      case 'category':
        _filteredExpenses.sort((a, b) =>
            (a['category'] as String).compareTo(b['category'] as String));
        break;
    }
  }

  void _onSortChanged(String sortOption) {
    setState(() {
      _sortOption = sortOption;
      _applySorting();
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        onFiltersApplied: _applyFilters,
      ),
    );
  }

  void _applyFilters(List<String> filters) {
    setState(() {
      _activeFilters = filters;
      // Apply filter logic here
      _filteredExpenses = List.from(_allExpenses);
      _applySorting();
    });
  }

  void _removeFilter(String filter) {
    setState(() {
      _activeFilters.remove(filter);
      _applyFilters(_activeFilters);
    });
  }

  void _toggleMultiSelect() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedExpenseIds.clear();
      }
    });
  }

  void _toggleExpenseSelection(String expenseId) {
    setState(() {
      if (_selectedExpenseIds.contains(expenseId)) {
        _selectedExpenseIds.remove(expenseId);
      } else {
        _selectedExpenseIds.add(expenseId);
      }
    });
  }

  void _deleteSelectedExpenses() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Expenses'),
        content: Text(
            'Are you sure you want to delete ${_selectedExpenseIds.length} expense(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _allExpenses.removeWhere(
                    (expense) => _selectedExpenseIds.contains(expense['id']));
                _filteredExpenses.removeWhere(
                    (expense) => _selectedExpenseIds.contains(expense['id']));
                _selectedExpenseIds.clear();
                _isMultiSelectMode = false;
              });
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _onExpenseEdit(String expenseId) {
    Navigator.pushNamed(context, '/add-edit-expense');
  }

  void _onExpenseDelete(String expenseId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Expense'),
        content: Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _allExpenses
                    .removeWhere((expense) => expense['id'] == expenseId);
                _filteredExpenses
                    .removeWhere((expense) => expense['id'] == expenseId);
              });
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _filteredExpenses = List.from(_allExpenses);
      _applySorting();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: _isMultiSelectMode
            ? Text('${_selectedExpenseIds.length} selected')
            : Text('Expenses'),
        leading: _isMultiSelectMode
            ? IconButton(
                onPressed: _toggleMultiSelect,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              )
            : null,
        actions: [
          if (_isMultiSelectMode) ...[
            if (_selectedExpenseIds.isNotEmpty)
              IconButton(
                onPressed: _deleteSelectedExpenses,
                icon: CustomIconWidget(
                  iconName: 'delete',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 24,
                ),
              ),
          ] else ...[
            IconButton(
              onPressed: _toggleMultiSelect,
              icon: CustomIconWidget(
                iconName: 'checklist',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: EdgeInsets.all(16),
            color: AppTheme.lightTheme.colorScheme.surface,
            child: Column(
              children: [
                // Search Bar
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Search expenses...',
                          prefixIcon: CustomIconWidget(
                            iconName: 'search',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    _searchFocusNode.unfocus();
                                  },
                                  icon: CustomIconWidget(
                                    iconName: 'clear',
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    size: 20,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    IconButton(
                      onPressed: _showFilterBottomSheet,
                      icon: CustomIconWidget(
                        iconName: 'filter_list',
                        color: _activeFilters.isNotEmpty
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 8),
                    SortDropdownWidget(
                      currentSort: _sortOption,
                      onSortChanged: _onSortChanged,
                    ),
                  ],
                ),

                // Active Filters
                if (_activeFilters.isNotEmpty) ...[
                  SizedBox(height: 12),
                  SizedBox(
                    height: 32,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _activeFilters.length,
                      separatorBuilder: (context, index) => SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return FilterChipWidget(
                          label: _activeFilters[index],
                          onRemove: () => _removeFilter(_activeFilters[index]),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Expense List
          Expanded(
            child: _filteredExpenses.isEmpty
                ? EmptyStateWidget(
                    onAddExpense: () =>
                        Navigator.pushNamed(context, '/add-edit-expense'),
                  )
                : RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      itemCount:
                          _filteredExpenses.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _filteredExpenses.length) {
                          return Container(
                            padding: EdgeInsets.all(16),
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          );
                        }

                        final expense = _filteredExpenses[index];
                        final isSelected =
                            _selectedExpenseIds.contains(expense['id']);

                        return ExpenseCardWidget(
                          expense: expense,
                          isMultiSelectMode: _isMultiSelectMode,
                          isSelected: isSelected,
                          onTap: _isMultiSelectMode
                              ? () => _toggleExpenseSelection(
                                  expense['id'] as String)
                              : null,
                          onLongPress: !_isMultiSelectMode
                              ? () => _toggleMultiSelect()
                              : null,
                          onEdit: () => _onExpenseEdit(expense['id'] as String),
                          onDelete: () =>
                              _onExpenseDelete(expense['id'] as String),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-edit-expense'),
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }
}
