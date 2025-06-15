import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReceiptPhotoWidget extends StatelessWidget {
  final List<String> photos;
  final Function(List<String>) onPhotosChanged;

  const ReceiptPhotoWidget({
    super.key,
    required this.photos,
    required this.onPhotosChanged,
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
                iconName: 'camera_alt',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Receipt Photos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Optional',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.w),

          // Photo thumbnails and add button
          SizedBox(
            height: 20.w,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length + 1,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                if (index == photos.length) {
                  return _buildAddPhotoButton(context);
                }
                return _buildPhotoThumbnail(context, photos[index], index);
              },
            ),
          ),

          SizedBox(height: 2.w),

          Text(
            photos.isEmpty
                ? 'Add photos of your receipts for better expense tracking'
                : '${photos.length} photo${photos.length == 1 ? '' : 's'} added',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPhotoButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPhotoOptions(context),
      child: Container(
        width: 20.w,
        height: 20.w,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'add_a_photo',
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            SizedBox(height: 1.w),
            Text(
              'Add',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoThumbnail(
      BuildContext context, String photoUrl, int index) {
    return Stack(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: CustomImageWidget(
              imageUrl: photoUrl,
              width: 20.w,
              height: 20.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 1.w,
          right: 1.w,
          child: GestureDetector(
            onTap: () => _removePhoto(index),
            child: Container(
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'close',
                color: Theme.of(context).colorScheme.onError,
                size: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 1.w,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 4.w),
            Text(
              'Add Receipt Photo',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 4.w),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Take Photo',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.of(context).pop();
                _takePhoto();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Choose from Gallery',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.of(context).pop();
                _chooseFromGallery();
              },
            ),
            SizedBox(height: 2.w),
          ],
        ),
      ),
    );
  }

  void _takePhoto() {
    // Mock photo URL - in real app, this would use camera
    final mockPhotoUrl =
        'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=400&fit=crop';
    final updatedPhotos = List<String>.from(photos)..add(mockPhotoUrl);
    onPhotosChanged(updatedPhotos);
  }

  void _chooseFromGallery() {
    // Mock photo URL - in real app, this would use gallery picker
    final mockPhotoUrl =
        'https://images.pexels.com/photos/4386476/pexels-photo-4386476.jpeg?w=400&h=400&fit=crop';
    final updatedPhotos = List<String>.from(photos)..add(mockPhotoUrl);
    onPhotosChanged(updatedPhotos);
  }

  void _removePhoto(int index) {
    final updatedPhotos = List<String>.from(photos)..removeAt(index);
    onPhotosChanged(updatedPhotos);
  }
}
