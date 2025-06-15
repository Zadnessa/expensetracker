import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryChipWidget extends StatelessWidget {
  final String name;
  final String icon;
  final double spent;
  final double budget;
  final Color color;
  final String currency;

  const CategoryChipWidget({
    super.key,
    required this.name,
    required this.icon,
    required this.spent,
    required this.budget,
    required this.color,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = budget > 0 ? (spent / budget) * 100 : 0;
    final bool isOverBudget = spent > budget;

    return Container(
      width: 32.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOverBudget
              ? AppTheme.getSemanticColor('error', isLight: true)
                  .withValues(alpha: 0.3)
              : AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: icon,
                    color: color,
                    size: 18,
                  ),
                ),
              ),
              if (isOverBudget)
                CustomIconWidget(
                  iconName: 'warning',
                  color: AppTheme.getSemanticColor('error', isLight: true),
                  size: 16,
                ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            name,
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.5.h),
          Text(
            '$currency${spent.toStringAsFixed(0)}',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isOverBudget
                  ? AppTheme.getSemanticColor('error', isLight: true)
                  : AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'of $currency${budget.toStringAsFixed(0)}',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            width: double.infinity,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (percentage / 100).clamp(0.0, 1.2),
              child: Container(
                decoration: BoxDecoration(
                  color: isOverBudget
                      ? AppTheme.getSemanticColor('error', isLight: true)
                      : color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
