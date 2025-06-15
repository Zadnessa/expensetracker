import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class RecurringExpenseWidget extends StatelessWidget {
  final bool isRecurring;
  final String frequency;
  final Function(bool) onRecurringChanged;
  final Function(String) onFrequencyChanged;

  const RecurringExpenseWidget({
    super.key,
    required this.isRecurring,
    required this.frequency,
    required this.onRecurringChanged,
    required this.onFrequencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'repeat',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Recurring Expense',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              Switch(
                value: isRecurring,
                onChanged: onRecurringChanged,
              ),
            ],
          ),
          SizedBox(height: 2.w),
          Text(
            'Set this expense to repeat automatically',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
          if (isRecurring) ...[
            SizedBox(height: 4.w),
            Text(
              'Frequency',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.w),
            _buildFrequencyOptions(context),
          ],
        ],
      ),
    );
  }

  Widget _buildFrequencyOptions(BuildContext context) {
    final frequencies = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

    return Wrap(
      spacing: 2.w,
      runSpacing: 2.w,
      children: frequencies.map((freq) {
        final isSelected = frequency == freq;

        return GestureDetector(
          onTap: () => onFrequencyChanged(freq),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
            child: Text(
              freq,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
