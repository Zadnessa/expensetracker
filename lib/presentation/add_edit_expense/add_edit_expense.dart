import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/amount_input_widget.dart';
import './widgets/category_selection_widget.dart';
import './widgets/date_picker_widget.dart';
import './widgets/description_input_widget.dart';
import './widgets/receipt_photo_widget.dart';
import './widgets/recurring_expense_widget.dart';

class AddEditExpense extends StatefulWidget {
  final Map<String, dynamic>? expenseData;

  const AddEditExpense({super.key, this.expenseData});

  @override
  State<AddEditExpense> createState() => _AddEditExpenseState();
}

class _AddEditExpenseState extends State<AddEditExpense> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();
  List<String> _receiptPhotos = [];
  bool _isRecurring = false;
  String _recurringFrequency = 'Monthly';
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  // Mock categories data
  final List<Map<String, dynamic>> _categories = [
    {"id": 1, "name": "Food", "icon": "restaurant", "color": 0xFFFF6B6B},
    {
      "id": 2,
      "name": "Transport",
      "icon": "directions_car",
      "color": 0xFF4ECDC4
    },
    {"id": 3, "name": "Shopping", "icon": "shopping_bag", "color": 0xFF45B7D1},
    {"id": 4, "name": "Entertainment", "icon": "movie", "color": 0xFF96CEB4},
    {"id": 5, "name": "Bills", "icon": "receipt", "color": 0xFFFECA57},
    {
      "id": 6,
      "name": "Healthcare",
      "icon": "local_hospital",
      "color": 0xFFFF9FF3
    },
    {"id": 7, "name": "Education", "icon": "school", "color": 0xFF54A0FF},
    {"id": 8, "name": "Travel", "icon": "flight", "color": 0xFF5F27CD},
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    if (widget.expenseData != null) {
      final data = widget.expenseData!;
      _amountController.text =
          (data['amount'] as double?)?.toStringAsFixed(2) ?? '';
      _descriptionController.text = (data['description'] as String?) ?? '';
      _selectedCategory = (data['category'] as String?) ?? '';
      _selectedDate = data['date'] as DateTime? ?? DateTime.now();
      _receiptPhotos = (data['photos'] as List?)?.cast<String>() ?? [];
      _isRecurring = (data['isRecurring'] as bool?) ?? false;
      _recurringFrequency =
          (data['recurringFrequency'] as String?) ?? 'Monthly';
    }
  }

  bool get _isFormValid {
    return _amountController.text.isNotEmpty &&
        _selectedCategory.isNotEmpty &&
        double.tryParse(_amountController.text) != null &&
        double.parse(_amountController.text) > 0;
  }

  void _onFieldChanged() {
    setState(() {
      _hasUnsavedChanges = true;
    });
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Unsaved Changes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: Text(
              'You have unsaved changes. Are you sure you want to leave?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Stay'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Leave'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _saveExpense() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1500));

      // Haptic feedback
      HapticFeedback.lightImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.expenseData != null
                  ? 'Expense updated successfully!'
                  : 'Expense added successfully!',
            ),
            backgroundColor:
                AppTheme.getSemanticColor('success', isLight: true),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to save expense. Please try again.'),
            backgroundColor: AppTheme.getSemanticColor('error', isLight: true),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            widget.expenseData != null ? 'Edit Expense' : 'Add Expense',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          leading: TextButton(
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          leadingWidth: 20.w,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: TextButton(
                onPressed: _isFormValid && !_isLoading ? _saveExpense : null,
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    : Text(
                        'Save',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _isFormValid
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).disabledColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount Input Section
                AmountInputWidget(
                  controller: _amountController,
                  onChanged: (_) => _onFieldChanged(),
                ),

                SizedBox(height: 6.w),

                // Category Selection Section
                CategorySelectionWidget(
                  categories: _categories,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                    _onFieldChanged();
                  },
                ),

                SizedBox(height: 6.w),

                // Date Picker Section
                DatePickerWidget(
                  selectedDate: _selectedDate,
                  onDateSelected: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                    _onFieldChanged();
                  },
                ),

                SizedBox(height: 6.w),

                // Description Input Section
                DescriptionInputWidget(
                  controller: _descriptionController,
                  onChanged: (_) => _onFieldChanged(),
                ),

                SizedBox(height: 6.w),

                // Receipt Photo Section
                ReceiptPhotoWidget(
                  photos: _receiptPhotos,
                  onPhotosChanged: (photos) {
                    setState(() {
                      _receiptPhotos = photos;
                    });
                    _onFieldChanged();
                  },
                ),

                SizedBox(height: 6.w),

                // Recurring Expense Section (only show in edit mode)
                if (widget.expenseData != null)
                  RecurringExpenseWidget(
                    isRecurring: _isRecurring,
                    frequency: _recurringFrequency,
                    onRecurringChanged: (isRecurring) {
                      setState(() {
                        _isRecurring = isRecurring;
                      });
                      _onFieldChanged();
                    },
                    onFrequencyChanged: (frequency) {
                      setState(() {
                        _recurringFrequency = frequency;
                      });
                      _onFieldChanged();
                    },
                  ),

                SizedBox(height: 10.w),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
