import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ThemeSelectorWidget extends StatelessWidget {
  final String selectedTheme;
  final Function(String) onThemeChanged;

  const ThemeSelectorWidget({
    super.key,
    required this.selectedTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showThemePicker(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: _getThemeIcon(selectedTheme),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Theme',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    selectedTheme,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeIcon(String theme) {
    switch (theme) {
      case 'Light':
        return 'light_mode';
      case 'Dark':
        return 'dark_mode';
      case 'System':
      default:
        return 'brightness_auto';
    }
  }

  void _showThemePicker(BuildContext context) {
    final List<Map<String, dynamic>> themes = [
      {
        'name': 'Light',
        'icon': 'light_mode',
        'description': 'Light theme for better visibility',
        'preview': Colors.white,
      },
      {
        'name': 'Dark',
        'icon': 'dark_mode',
        'description': 'Dark theme for low light conditions',
        'preview': Colors.grey[900],
      },
      {
        'name': 'System',
        'icon': 'brightness_auto',
        'description': 'Follow system theme settings',
        'preview': Colors.grey[600],
      },
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Select Theme',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ...themes.map((theme) => Container(
                  margin: EdgeInsets.only(bottom: 1.h),
                  child: ListTile(
                    leading: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: theme['preview'] as Color?,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: theme['icon'] as String,
                          color: theme['name'] == 'Light'
                              ? Colors.black
                              : theme['name'] == 'Dark'
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.onSurface,
                          size: 20,
                        ),
                      ),
                    ),
                    title: Text(theme['name'] as String),
                    subtitle: Text(theme['description'] as String),
                    trailing: selectedTheme == theme['name']
                        ? CustomIconWidget(
                            iconName: 'check_circle',
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          )
                        : null,
                    onTap: () {
                      onThemeChanged(theme['name'] as String);
                      Navigator.pop(context);
                    },
                  ),
                )),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
