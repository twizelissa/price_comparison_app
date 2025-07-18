import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/error/exceptions.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  static Future<File?> pickFromGallery({
    int imageQuality = 80,
    double? maxWidth,
    double? maxHeight,
  }) async {
    try {
      // Check permission
      final permission = await Permission.photos.request();
      if (!permission.isGranted) {
        throw const PermissionException(
          message: 'Gallery permission is required to select photos',
          permission: 'photos',
        );
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (image != null) {
        final File imageFile = File(image.path);
        return imageFile;
      }
      return null;
    } catch (e) {
      if (e is PermissionException) rethrow;
      throw ImagePickerException(message: 'Failed to pick image from gallery: ${e.toString()}');
    }
  }

  // Pick image from camera
  static Future<File?> pickFromCamera({
    int imageQuality = 80,
    double? maxWidth,
    double? maxHeight,
  }) async {
    try {
      // Check permission
      final permission = await Permission.camera.request();
      if (!permission.isGranted) {
        throw const PermissionException(
          message: 'Camera permission is required to take photos',
          permission: 'camera',
        );
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (image != null) {
        final File imageFile = File(image.path);
        return imageFile;
      }
      return null;
    } catch (e) {
      if (e is PermissionException) rethrow;
      throw ImagePickerException(message: 'Failed to take photo: ${e.toString()}');
    }
  }

  // Show image picker options dialog
  static Future<File?> showImagePickerDialog(BuildContext context) async {
    return showModalBottomSheet<File?>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const ImagePickerBottomSheet(),
    );
  }

  // Validate image file
  static bool validateImageFile(File file, {int maxSizeInMB = 5}) {
    final int fileSizeInBytes = file.lengthSync();
    final int maxSizeInBytes = maxSizeInMB * 1024 * 1024;
    return fileSizeInBytes <= maxSizeInBytes;
  }

  // Get image file size in MB
  static double getImageSizeInMB(File file) {
    final int fileSizeInBytes = file.lengthSync();
    return fileSizeInBytes / (1024 * 1024);
  }

  // Compress image if needed
  static Future<File?> compressImage(File file, {int quality = 80}) async {
    try {
      final String filePath = file.path;
      final String fileName = filePath.split('/').last;
      final String directory = filePath.substring(0, filePath.lastIndexOf('/'));
      final String compressedPath = '$directory/compressed_$fileName';

      // Use image_picker to compress
      final XFile? compressedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: quality,
      );

      if (compressedImage != null) {
        return File(compressedImage.path);
      }
      return null;
    } catch (e) {
      throw ImagePickerException(message: 'Failed to compress image: ${e.toString()}');
    }
  }
}

class ImagePickerBottomSheet extends StatelessWidget {
  const ImagePickerBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXL),
          topRight: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingL),
            
            // Title
            Text(
              'Select Image',
              style: AppTextStyles.h6,
            ),
            
            const SizedBox(height: AppDimensions.paddingL),
            
            // Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
              child: Row(
                children: [
                  // Camera option
                  Expanded(
                    child: _buildOption(
                      context: context,
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () async {
                        Navigator.pop(context);
                        final file = await ImagePickerHelper.pickFromCamera();
                        if (context.mounted) {
                          Navigator.pop(context, file);
                        }
                      },
                    ),
                  ),
                  
                  const SizedBox(width: AppDimensions.paddingL),
                  
                  // Gallery option
                  Expanded(
                    child: _buildOption(
                      context: context,
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () async {
                        Navigator.pop(context);
                        final file = await ImagePickerHelper.pickFromGallery();
                        if (context.mounted) {
                          Navigator.pop(context, file);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingL),
            
            // Cancel button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingL),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: AppDimensions.iconXXL,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              label,
              style: AppTextStyles.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// Image preview widget
class ImagePreviewWidget extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final VoidCallback? onRemove;
  final VoidCallback? onEdit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ImagePreviewWidget({
    Key? key,
    this.imageFile,
    this.imageUrl,
    this.onRemove,
    this.onEdit,
    this.width,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageFile == null && imageUrl == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: width ?? 120,
      height: height ?? 120,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusM),
            child: imageFile != null
                ? Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.cardBackground,
                      child: const Icon(
                        Icons.broken_image,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
          ),
          
          // Overlay buttons
          if (onRemove != null || onEdit != null)
            Positioned(
              top: AppDimensions.paddingS,
              right: AppDimensions.paddingS,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEdit != null)
                    _buildActionButton(
                      icon: Icons.edit,
                      onPressed: onEdit!,
                    ),
                  if (onEdit != null && onRemove != null)
                    const SizedBox(width: AppDimensions.paddingXS),
                  if (onRemove != null)
                    _buildActionButton(
                      icon: Icons.close,
                      onPressed: onRemove!,
                      backgroundColor: AppColors.error,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? backgroundColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.textPrimary.withOpacity(0.7),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}