import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryComparisonWidget extends StatelessWidget {
  final List<Map<String, dynamic>> categoryData;

  const CategoryComparisonWidget({
    super.key,
    required this.categoryData,
  });

  @override
  Widget build(BuildContext context) {
    // Sort categories by amount in descending order
    final sortedData = List<Map<String, dynamic>>.from(categoryData)
      ..sort(
          (a, b) => (b['amount'] as double).compareTo(a['amount'] as double));

    final maxAmount = sortedData.first['amount'] as double;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category Spending',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          ...sortedData.map((data) => _buildCategoryBar(data, maxAmount)),
        ],
      ),
    );
  }

  Widget _buildCategoryBar(Map<String, dynamic> data, double maxAmount) {
    final percentage = (data['amount'] as double) / maxAmount;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(1.5.w),
                    decoration: BoxDecoration(
                      color: (data['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: CustomIconWidget(
                      iconName: data['icon'] as String,
                      color: data['color'] as Color,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    data['category'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                '\$${(data['amount'] as double).toStringAsFixed(2)}',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: data['color'] as Color,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 1.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                width: 80.w * percentage,
                height: 1.h,
                decoration: BoxDecoration(
                  color: data['color'] as Color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Text(
            '${(data['percentage'] as double).toStringAsFixed(1)}% of total spending',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
