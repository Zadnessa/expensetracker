import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class BackupStatusWidget extends StatelessWidget {
  final bool isEnabled;
  final Function(bool) onToggle;

  const BackupStatusWidget({
    super.key,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'backup',
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 24,
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Backup',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      isEnabled
                          ? 'Automatic backup enabled'
                          : 'Backup disabled',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Switch(
                value: isEnabled,
                onChanged: onToggle,
              ),
            ],
          ),
          if (isEnabled) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'cloud_queue',
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Cloud Integration Coming Soon',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  _buildBackupItem(
                    context,
                    'Last Backup',
                    'Local storage - ${DateTime.now().subtract(const Duration(hours: 2)).toString().split('.')[0]}',
                    'check_circle',
                    Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(height: 0.5.h),
                  _buildBackupItem(
                    context,
                    'Cloud Backup',
                    'Preparing for future release',
                    'cloud_off',
                    Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _performBackup(context),
                    icon: CustomIconWidget(
                      iconName: 'backup',
                      color: Theme.of(context).colorScheme.primary,
                      size: 18,
                    ),
                    label: const Text('Backup Now'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showRestoreOptions(context),
                    icon: CustomIconWidget(
                      iconName: 'restore',
                      color: Theme.of(context).colorScheme.primary,
                      size: 18,
                    ),
                    label: const Text('Restore'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBackupItem(
    BuildContext context,
    String title,
    String subtitle,
    String icon,
    Color iconColor,
  ) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: iconColor,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _performBackup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 2.h),
            const Text('Creating backup...'),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Backup completed successfully'),
          action: SnackBarAction(
            label: 'View',
            onPressed: () {},
          ),
        ),
      );
    });
  }

  void _showRestoreOptions(BuildContext context) {
    final List<Map<String, dynamic>> backups = [
      {
        'date': DateTime.now().subtract(const Duration(hours: 2)),
        'size': '2.4 MB',
        'type': 'Local',
        'expenses': 156,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'size': '2.3 MB',
        'type': 'Local',
        'expenses': 152,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 7)),
        'size': '2.1 MB',
        'type': 'Local',
        'expenses': 143,
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
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
                'Restore from Backup',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 1.h),
              Text(
                'Select a backup to restore your data',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: backups.length,
                  itemBuilder: (context, index) {
                    final backup = backups[index];
                    return Card(
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'backup',
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          '${backup['date'].toString().split(' ')[0]} ${backup['date'].toString().split(' ')[1].substring(0, 5)}',
                        ),
                        subtitle: Text(
                          '${backup['expenses']} expenses • ${backup['size']} • ${backup['type']}',
                        ),
                        trailing: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _confirmRestore(context, backup);
                          },
                          child: const Text('Restore'),
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

  void _confirmRestore(BuildContext context, Map<String, dynamic> backup) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Restore'),
        content: Text(
          'This will replace all current data with the backup from ${backup['date'].toString().split(' ')[0]}. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performRestore(context, backup);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  void _performRestore(BuildContext context, Map<String, dynamic> backup) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 2.h),
            const Text('Restoring backup...'),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data restored successfully'),
        ),
      );
    });
  }
}
