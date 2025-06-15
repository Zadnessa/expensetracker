import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';

class SortDropdownWidget extends StatelessWidget {
  final String currentSort;
  final Function(String) onSortChanged;

  const SortDropdownWidget({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      {'value': 'newest', 'label': 'Newest First'},
      {'value': 'oldest', 'label': 'Oldest First'},
      {'value': 'highest', 'label': 'Highest Amount'},
      {'value': 'lowest', 'label': 'Lowest Amount'},
      {'value': 'category', 'label': 'Category A-Z'},
    ];

    return PopupMenuButton<String>(
      onSelected: onSortChanged,
      icon: CustomIconWidget(
        iconName: 'sort',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 24,
      ),
      itemBuilder: (context) => sortOptions.map((option) {
        return PopupMenuItem<String>(
          value: option['value'] as String,
          child: Row(
            children: [
              if (currentSort == option['value'])
                CustomIconWidget(
                  iconName: 'check',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                )
              else
                SizedBox(width: 16),
              SizedBox(width: 8),
              Text(
                option['label'] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: currentSort == option['value']
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
