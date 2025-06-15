import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InsightsCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String type;
  final String iconName;

  const InsightsCardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.type,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = _getCardColor();
    final iconColor = _getIconColor();
    final borderColor = _getBorderColor();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.5.w),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: iconColor,
              size: 24,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getTypeLabel(),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: iconColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _handleInsightAction(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View Details',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: iconColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          CustomIconWidget(
                            iconName: 'arrow_forward_ios',
                            color: iconColor,
                            size: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCardColor() {
    switch (type) {
      case 'success':
        return AppTheme.lightTheme.colorScheme.surface;
      case 'warning':
        return const Color(0xFFFFF8E1);
      case 'error':
        return const Color(0xFFFFEBEE);
      default:
        return AppTheme.lightTheme.colorScheme.surface;
    }
  }

  Color _getIconColor() {
    switch (type) {
      case 'success':
        return const Color(0xFF4CAF50);
      case 'warning':
        return const Color(0xFFFF9800);
      case 'error':
        return const Color(0xFFF44336);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  Color _getBorderColor() {
    switch (type) {
      case 'success':
        return const Color(0xFF4CAF50).withValues(alpha: 0.2);
      case 'warning':
        return const Color(0xFFFF9800).withValues(alpha: 0.2);
      case 'error':
        return const Color(0xFFF44336).withValues(alpha: 0.2);
      default:
        return AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2);
    }
  }

  String _getTypeLabel() {
    switch (type) {
      case 'success':
        return 'Good News';
      case 'warning':
        return 'Attention';
      case 'error':
        return 'Alert';
      default:
        return 'Insight';
    }
  }

  void _handleInsightAction(BuildContext context) {
    // Handle insight action - could navigate to detailed view or show more info
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing details for: $title'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
