import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Function(List<String>) onFiltersApplied;

  const FilterBottomSheetWidget({
    super.key,
    required this.onFiltersApplied,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  DateTimeRange? _selectedDateRange;
  final List<String> _selectedCategories = [];
  RangeValues _amountRange = RangeValues(0, 1000);
  bool _hasReceiptFilter = false;
  bool _showDateSection = true;
  bool _showCategorySection = true;
  bool _showAmountSection = true;
  bool _showReceiptSection = true;

  final List<Map<String, dynamic>> _categories = [
    {"name": "Food", "icon": "restaurant", "color": Color(0xFFFF6B6B)},
    {
      "name": "Transportation",
      "icon": "directions_car",
      "color": Color(0xFF4ECDC4)
    },
    {"name": "Shopping", "icon": "shopping_bag", "color": Color(0xFF45B7D1)},
    {"name": "Entertainment", "icon": "movie", "color": Color(0xFF96CEB4)},
    {"name": "Bills", "icon": "receipt_long", "color": Color(0xFFFECA57)},
    {
      "name": "Healthcare",
      "icon": "local_hospital",
      "color": Color(0xFFFF9FF3)
    },
  ];

  void _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedDateRange = null;
      _selectedCategories.clear();
      _amountRange = RangeValues(0, 1000);
      _hasReceiptFilter = false;
    });
  }

  void _applyFilters() {
    List<String> filters = [];

    if (_selectedDateRange != null) {
      filters.add('Date Range');
    }

    if (_selectedCategories.isNotEmpty) {
      filters.addAll(_selectedCategories);
    }

    if (_amountRange.start > 0 || _amountRange.end < 1000) {
      filters.add('Amount Range');
    }

    if (_hasReceiptFilter) {
      filters.add('Has Receipt');
    }

    widget.onFiltersApplied(filters);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Expenses',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: _clearFilters,
                      child: Text('Clear All'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _applyFilters,
                      child: Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(),

          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Range Section
                  _buildCollapsibleSection(
                    title: 'Date Range',
                    isExpanded: _showDateSection,
                    onToggle: () =>
                        setState(() => _showDateSection = !_showDateSection),
                    child: Column(
                      children: [
                        SizedBox(height: 12),
                        InkWell(
                          onTap: _selectDateRange,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.lightTheme.colorScheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedDateRange != null
                                      ? '${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month}/${_selectedDateRange!.start.year} - ${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}/${_selectedDateRange!.end.year}'
                                      : 'Select date range',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodyMedium,
                                ),
                                CustomIconWidget(
                                  iconName: 'calendar_today',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Categories Section
                  _buildCollapsibleSection(
                    title: 'Categories',
                    isExpanded: _showCategorySection,
                    onToggle: () => setState(
                        () => _showCategorySection = !_showCategorySection),
                    child: Column(
                      children: [
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _categories.map((category) {
                            final isSelected =
                                _selectedCategories.contains(category['name']);
                            return FilterChip(
                              selected: isSelected,
                              onSelected: (_) =>
                                  _toggleCategory(category['name'] as String),
                              avatar: CustomIconWidget(
                                iconName: category['icon'] as String,
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.onPrimary
                                    : category['color'] as Color,
                                size: 16,
                              ),
                              label: Text(category['name'] as String),
                              selectedColor:
                                  AppTheme.lightTheme.colorScheme.primary,
                              checkmarkColor:
                                  AppTheme.lightTheme.colorScheme.onPrimary,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Amount Range Section
                  _buildCollapsibleSection(
                    title: 'Amount Range',
                    isExpanded: _showAmountSection,
                    onToggle: () => setState(
                        () => _showAmountSection = !_showAmountSection),
                    child: Column(
                      children: [
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${_amountRange.start.round()}',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            Text(
                              '\$${_amountRange.end.round()}',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        RangeSlider(
                          values: _amountRange,
                          min: 0,
                          max: 1000,
                          divisions: 20,
                          onChanged: (values) {
                            setState(() {
                              _amountRange = values;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Receipt Section
                  _buildCollapsibleSection(
                    title: 'Receipt Attachment',
                    isExpanded: _showReceiptSection,
                    onToggle: () => setState(
                        () => _showReceiptSection = !_showReceiptSection),
                    child: Column(
                      children: [
                        SizedBox(height: 12),
                        SwitchListTile(
                          title: Text('Has Receipt'),
                          subtitle: Text(
                              'Show only expenses with receipt attachments'),
                          value: _hasReceiptFilter,
                          onChanged: (value) {
                            setState(() {
                              _hasReceiptFilter = value;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomIconWidget(
                iconName: isExpanded ? 'expand_less' : 'expand_more',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ],
          ),
        ),
        if (isExpanded) child,
      ],
    );
  }
}
