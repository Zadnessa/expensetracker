import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/backup_status_widget.dart';
import './widgets/currency_selector_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/theme_selector_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "John Doe",
    "email": "john.doe@example.com",
    "avatar":
        "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
    "currency": "USD",
    "dateFormat": "DD/MM/YYYY",
    "numberFormat": "1,000.00"
  };

  // Settings state
  bool biometricEnabled = true;
  double appLockTimeout = 5.0;
  bool budgetAlerts = true;
  bool spendingWarnings = true;
  bool dailyReminders = false;
  String selectedTheme = "System";
  double textSize = 1.0;
  bool highContrast = false;
  bool backupEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          children: [
            _buildAccountSection(),
            SizedBox(height: 3.h),
            _buildSecuritySection(),
            SizedBox(height: 3.h),
            _buildAppearanceSection(),
            SizedBox(height: 3.h),
            _buildNotificationsSection(),
            SizedBox(height: 3.h),
            _buildDataManagementSection(),
            SizedBox(height: 3.h),
            _buildCategoriesSection(),
            SizedBox(height: 3.h),
            _buildAdvancedSection(),
            SizedBox(height: 3.h),
            _buildAboutSection(),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return SettingsSectionWidget(
      title: 'Account',
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: userData["avatar"] as String,
                    width: 15.w,
                    height: 15.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData["name"] as String,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      userData["email"] as String,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              CustomIconWidget(
                iconName: 'edit',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        CurrencySelectorWidget(
          selectedCurrency: userData["currency"] as String,
          onCurrencyChanged: (currency) {
            setState(() {
              userData["currency"] = currency;
            });
          },
        ),
        SettingsItemWidget(
          icon: 'calendar_today',
          title: 'Date Format',
          subtitle: userData["dateFormat"] as String,
          onTap: () => _showDateFormatPicker(),
        ),
        SettingsItemWidget(
          icon: 'format_list_numbered',
          title: 'Number Format',
          subtitle: userData["numberFormat"] as String,
          onTap: () => _showNumberFormatPicker(),
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return SettingsSectionWidget(
      title: 'Security',
      children: [
        SettingsItemWidget(
          icon: 'fingerprint',
          title: 'Biometric Authentication',
          subtitle: 'Use fingerprint or face ID',
          trailing: Switch(
            value: biometricEnabled,
            onChanged: (value) {
              setState(() {
                biometricEnabled = value;
              });
            },
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'lock_clock',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'App Lock Timeout',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '${appLockTimeout.toInt()} minutes',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Slider(
                value: appLockTimeout,
                min: 1.0,
                max: 15.0,
                divisions: 14,
                label: '${appLockTimeout.toInt()} min',
                onChanged: (value) {
                  setState(() {
                    appLockTimeout = value;
                  });
                },
              ),
            ],
          ),
        ),
        BackupStatusWidget(
          isEnabled: backupEnabled,
          onToggle: (value) {
            setState(() {
              backupEnabled = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAppearanceSection() {
    return SettingsSectionWidget(
      title: 'Appearance',
      children: [
        ThemeSelectorWidget(
          selectedTheme: selectedTheme,
          onThemeChanged: (theme) {
            setState(() {
              selectedTheme = theme;
            });
          },
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'text_fields',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Text Size',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          textSize == 0.8
                              ? 'Small'
                              : textSize == 1.0
                                  ? 'Normal'
                                  : 'Large',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Slider(
                value: textSize,
                min: 0.8,
                max: 1.4,
                divisions: 3,
                label: textSize == 0.8
                    ? 'Small'
                    : textSize == 1.0
                        ? 'Normal'
                        : textSize == 1.2
                            ? 'Large'
                            : 'Extra Large',
                onChanged: (value) {
                  setState(() {
                    textSize = value;
                  });
                },
              ),
            ],
          ),
        ),
        SettingsItemWidget(
          icon: 'contrast',
          title: 'High Contrast',
          subtitle: 'Improve text readability',
          trailing: Switch(
            value: highContrast,
            onChanged: (value) {
              setState(() {
                highContrast = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return SettingsSectionWidget(
      title: 'Notifications',
      children: [
        SettingsItemWidget(
          icon: 'notifications',
          title: 'Budget Alerts',
          subtitle: 'Get notified when approaching budget limits',
          trailing: Switch(
            value: budgetAlerts,
            onChanged: (value) {
              setState(() {
                budgetAlerts = value;
              });
            },
          ),
        ),
        SettingsItemWidget(
          icon: 'warning',
          title: 'Spending Warnings',
          subtitle: 'Alert when exceeding category limits',
          trailing: Switch(
            value: spendingWarnings,
            onChanged: (value) {
              setState(() {
                spendingWarnings = value;
              });
            },
          ),
        ),
        SettingsItemWidget(
          icon: 'schedule',
          title: 'Daily Reminders',
          subtitle: 'Remind to log daily expenses',
          trailing: Switch(
            value: dailyReminders,
            onChanged: (value) {
              setState(() {
                dailyReminders = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDataManagementSection() {
    return SettingsSectionWidget(
      title: 'Data Management',
      children: [
        SettingsItemWidget(
          icon: 'file_download',
          title: 'Export Data',
          subtitle: 'Download your expense data',
          onTap: () => _showExportOptions(),
        ),
        SettingsItemWidget(
          icon: 'storage',
          title: 'Storage Usage',
          subtitle: '2.4 MB used',
          onTap: () => _showStorageDetails(),
        ),
        SettingsItemWidget(
          icon: 'tune',
          title: 'Optimize Database',
          subtitle: 'Clean up and optimize data',
          onTap: () => _optimizeDatabase(),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return SettingsSectionWidget(
      title: 'Categories',
      children: [
        SettingsItemWidget(
          icon: 'add_circle',
          title: 'Add Custom Category',
          subtitle: 'Create new expense category',
          onTap: () => _showAddCategoryDialog(),
        ),
        SettingsItemWidget(
          icon: 'edit',
          title: 'Manage Categories',
          subtitle: 'Edit existing categories',
          onTap: () => _showManageCategories(),
        ),
        SettingsItemWidget(
          icon: 'reorder',
          title: 'Reorder Categories',
          subtitle: 'Change category display order',
          onTap: () => _showReorderCategories(),
        ),
      ],
    );
  }

  Widget _buildAdvancedSection() {
    return SettingsSectionWidget(
      title: 'Advanced',
      children: [
        SettingsItemWidget(
          icon: 'developer_mode',
          title: 'Developer Options',
          subtitle: 'Advanced debugging features',
          onTap: () => _showDeveloperOptions(),
        ),
        SettingsItemWidget(
          icon: 'refresh',
          title: 'Reset App Data',
          subtitle: 'Clear all data and settings',
          onTap: () => _showResetConfirmation(),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return SettingsSectionWidget(
      title: 'About',
      children: [
        SettingsItemWidget(
          icon: 'info',
          title: 'App Version',
          subtitle: '1.0.0 (Build 1)',
        ),
        SettingsItemWidget(
          icon: 'privacy_tip',
          title: 'Privacy Policy',
          subtitle: 'View our privacy policy',
          onTap: () => _openPrivacyPolicy(),
        ),
        SettingsItemWidget(
          icon: 'support',
          title: 'Support',
          subtitle: 'Get help and contact us',
          onTap: () => _openSupport(),
        ),
        SettingsItemWidget(
          icon: 'rate_review',
          title: 'Rate App',
          subtitle: 'Rate us on the app store',
          onTap: () => _rateApp(),
        ),
      ],
    );
  }

  void _showDateFormatPicker() {
    final List<String> formats = ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD'];
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Date Format',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ...formats.map((format) => ListTile(
                  title: Text(format),
                  trailing: userData["dateFormat"] == format
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: Theme.of(context).colorScheme.primary,
                          size: 20)
                      : null,
                  onTap: () {
                    setState(() {
                      userData["dateFormat"] = format;
                    });
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showNumberFormatPicker() {
    final List<Map<String, String>> formats = [
      {'format': '1,000.00', 'description': 'US Format'},
      {'format': '1.000,00', 'description': 'European Format'},
      {'format': '1,00,000.00', 'description': 'Indian Format'},
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Number Format',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ...formats.map((format) => ListTile(
                  title: Text(format['format']!),
                  subtitle: Text(format['description']!),
                  trailing: userData["numberFormat"] == format['format']
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: Theme.of(context).colorScheme.primary,
                          size: 20)
                      : null,
                  onTap: () {
                    setState(() {
                      userData["numberFormat"] = format['format']!;
                    });
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Export Format',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'picture_as_pdf', color: Colors.red, size: 24),
              title: const Text('PDF Report'),
              subtitle: const Text('Formatted expense report'),
              onTap: () {
                Navigator.pop(context);
                _exportData('PDF');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'table_chart', color: Colors.green, size: 24),
              title: const Text('CSV Data'),
              subtitle: const Text('Raw data for spreadsheets'),
              onTap: () {
                Navigator.pop(context);
                _exportData('CSV');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _exportData(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting data as $format...'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {},
        ),
      ),
    );
  }

  void _showStorageDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Usage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStorageItem('Expense Data', '1.8 MB'),
            _buildStorageItem('Receipt Images', '0.5 MB'),
            _buildStorageItem('App Cache', '0.1 MB'),
            const Divider(),
            _buildStorageItem('Total Used', '2.4 MB', isTotal: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageItem(String label, String size, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? Theme.of(context).textTheme.titleSmall
                : Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            size,
            style: isTotal
                ? Theme.of(context).textTheme.titleSmall
                : Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _optimizeDatabase() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Optimize Database'),
        content: const Text(
            'This will clean up unused data and optimize performance. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Database optimized successfully')),
              );
            },
            child: const Text('Optimize'),
          ),
        ],
      ),
    );
  }

  void _showAddCategoryDialog() {
    final TextEditingController nameController = TextEditingController();
    Color selectedColor = Theme.of(context).colorScheme.primary;
    String selectedIcon = 'category';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Custom Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  hintText: 'Enter category name',
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  const Text('Icon: '),
                  SizedBox(width: 2.w),
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: selectedColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: selectedIcon,
                      color: selectedColor,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _showIconPicker(setDialogState, (icon) {
                      selectedIcon = icon;
                    }),
                    child: const Text('Change'),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  const Text('Color: '),
                  SizedBox(width: 2.w),
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: selectedColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _showColorPicker(setDialogState, (color) {
                      selectedColor = color;
                    }),
                    child: const Text('Change'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Category "${nameController.text}" added')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showIconPicker(
      StateSetter setDialogState, Function(String) onIconSelected) {
    final List<String> icons = [
      'category',
      'restaurant',
      'local_gas_station',
      'shopping_cart',
      'medical_services',
      'school',
      'home',
      'directions_car',
      'movie',
      'fitness_center',
      'pets',
      'flight'
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Icon'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: icons.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  onIconSelected(icons[index]);
                  setDialogState(() {});
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: icons[index],
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showColorPicker(
      StateSetter setDialogState, Function(Color) onColorSelected) {
    final List<Color> colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Color'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: colors.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  onColorSelected(colors[index]);
                  setDialogState(() {});
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showManageCategories() {
    final List<Map<String, dynamic>> categories = [
      {
        'name': 'Food & Dining',
        'icon': 'restaurant',
        'color': Colors.orange,
        'isDefault': true
      },
      {
        'name': 'Transportation',
        'icon': 'directions_car',
        'color': Colors.blue,
        'isDefault': true
      },
      {
        'name': 'Shopping',
        'icon': 'shopping_cart',
        'color': Colors.green,
        'isDefault': true
      },
      {
        'name': 'Entertainment',
        'icon': 'movie',
        'color': Colors.purple,
        'isDefault': true
      },
      {
        'name': 'Healthcare',
        'icon': 'medical_services',
        'color': Colors.red,
        'isDefault': true
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Text(
                'Manage Categories',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Card(
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: (category['color'] as Color)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: category['icon'] as String,
                            color: category['color'] as Color,
                            size: 24,
                          ),
                        ),
                        title: Text(category['name'] as String),
                        subtitle: Text(category['isDefault'] as bool
                            ? 'Default Category'
                            : 'Custom Category'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: CustomIconWidget(
                                iconName: 'edit',
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              ),
                            ),
                            if (!(category['isDefault'] as bool))
                              IconButton(
                                onPressed: () {},
                                icon: CustomIconWidget(
                                  iconName: 'delete',
                                  color: Theme.of(context).colorScheme.error,
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReorderCategories() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Category reordering feature coming soon')),
    );
  }

  void _showDeveloperOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Developer Options'),
        content: const Text(
            'Enable developer mode to access advanced debugging features.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Developer mode enabled')),
              );
            },
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset App Data'),
        content: const Text(
            'This will permanently delete all your expenses, categories, and settings. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performReset();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _performReset() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Resetting app data...'),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('App data reset successfully')),
      );
    });
  }

  void _openPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening privacy policy...')),
    );
  }

  void _openSupport() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Get Support',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'email',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24),
              title: const Text('Email Support'),
              subtitle: const Text('support@expensetracker.com'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'help',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24),
              title: const Text('FAQ'),
              subtitle: const Text('Frequently asked questions'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'bug_report',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24),
              title: const Text('Report Bug'),
              subtitle: const Text('Report issues or bugs'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening app store for rating...')),
    );
  }
}
