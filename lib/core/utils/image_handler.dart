import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import '../services/cloudinary_service.dart';

class ImageHandler {
  static final ImagePicker _picker = ImagePicker();
  
  // Available asset images
  static const List<String> assetImages = [
    'assets/images/products/Apple-iPhone-15.jpg',
    'assets/images/products/s24.jpg',
    'assets/images/products/pixel 8.jpeg',
    'assets/images/products/iphone 14.jpg',
    'assets/images/products/Z-fold.jpeg',
    'assets/images/products/Lenovo-laptop.png',
    'assets/images/products/pixel.jpg',
    'assets/images/products/itel.jpg',
    'assets/images/products/tecno.jpeg',
  ];

  // Get image names for display
  static List<String> get assetImageNames {
    return assetImages.map((path) {
      String name = path.split('/').last.split('.').first;
      return name.replaceAll('-', ' ').replaceAll('_', ' ');
    }).toList();
  }

  // Show image selection dialog
  static Future<String?> showImageSelectionDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  final String? imagePath = await _pickImageFromGallery();
                  if (context.mounted) {
                    Navigator.pop(context, imagePath);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  final String? imagePath = await _pickImageFromCamera();
                  if (context.mounted) {
                    Navigator.pop(context, imagePath);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Choose from Preset Images'),
                onTap: () async {
                  final String? imagePath = await _showAssetImageDialog(context);
                  if (context.mounted) {
                    Navigator.pop(context, imagePath);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Show preset asset images dialog
  static Future<String?> _showAssetImageDialog(BuildContext context) async {
    final String? selectedAsset = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Preset Image'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: assetImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, assetImages[index]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        assetImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.image, size: 30),
                                Text(
                                  assetImageNames[index],
                                  style: const TextStyle(fontSize: 10),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    return selectedAsset;
  }

  // Pick image from gallery and convert to base64
  static Future<String?> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );
      
      if (image != null) {
        return await _convertImageToBase64(image);
      }
      return null;
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  // Pick image from camera and convert to base64
  static Future<String?> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );
      
      if (image != null) {
        return await _convertImageToBase64(image);
      }
      return null;
    } catch (e) {
      print('Error picking image from camera: $e');
      return null;
    }
  }

  // Convert image file to base64 string for storage
  static Future<String> _convertImageToBase64(XFile image) async {
    final bytes = await image.readAsBytes();
    return 'data:image/${image.path.split('.').last};base64,${base64Encode(bytes)}';
  }

  // Display image for Product model (prioritizes Cloudinary URL over local path)
  static Widget displayProductImage(
    String? imageUrl, 
    String? localImagePath, {
    double? width, 
    double? height, 
    BoxFit? fit
  }) {
    // Prioritize Cloudinary URL if available
    if (imageUrl != null && imageUrl.isNotEmpty && imageUrl.contains('cloudinary.com')) {
      return displayImage(imageUrl, width: width, height: height, fit: fit);
    }
    
    // Fall back to local image path
    if (localImagePath != null && localImagePath.isNotEmpty) {
      return displayImage(localImagePath, width: width, height: height, fit: fit);
    }
    
    // No image available
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: const Icon(Icons.image, size: 50, color: Colors.grey),
    );
  }

  // Display image widget based on image source
  static Widget displayImage(String? imagePath, {double? width, double? height, BoxFit? fit}) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
        child: const Icon(Icons.image, size: 50, color: Colors.grey),
      );
    }

    // Check if it's an asset image
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
          );
        },
      );
    }

    // Check if it's a base64 image
    if (imagePath.startsWith('data:image/')) {
      try {
        final base64String = imagePath.split(',')[1];
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit ?? BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: width,
              height: height,
              color: Colors.grey.shade200,
              child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
            );
          },
        );
      } catch (e) {
        print('Error decoding base64 image: $e');
      }
    }

    // Check if it's a file path
    if (imagePath.startsWith('/') || imagePath.startsWith('file://')) {
      return Image.file(
        File(imagePath.replaceFirst('file://', '')),
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
          );
        },
      );
    }

    // Fallback to network image
    return Image.network(
      imagePath,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
        );
      },
    );
  }

  // Upload image to Cloudinary
  static Future<String?> uploadToCloudinary({
    required File imageFile,
    String? folder,
    String? fileName,
    bool useTransformation = true,
    int? width,
    int? height,
  }) async {
    try {
      if (useTransformation && (width != null || height != null)) {
        return await CloudinaryService.uploadImageWithTransformation(
          imageFile: imageFile,
          folder: folder ?? 'price_comparison',
          fileName: fileName,
          width: width ?? 400,
          height: height ?? 400,
          crop: 'fill',
        );
      } else {
        return await CloudinaryService.uploadImage(
          imageFile: imageFile,
          folder: folder ?? 'price_comparison',
          fileName: fileName,
        );
      }
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      return null;
    }
  }

  // Pick image and upload to Cloudinary
  static Future<String?> pickAndUploadToCloudinary({
    required BuildContext context,
    ImageSource? source,
    String? folder,
    String? fileName,
    bool useTransformation = true,
    int? width,
    int? height,
  }) async {
    try {
      String? imagePath;
      
      if (source != null) {
        // Use specified source
        if (source == ImageSource.camera) {
          imagePath = await _pickImageFromCamera();
        } else {
          imagePath = await _pickImageFromGallery();
        }
      } else {
        // Show selection dialog
        imagePath = await showImageSelectionDialog(context);
      }

      if (imagePath != null && !imagePath.startsWith('assets/')) {
        // Only upload if it's not an asset image
        final File imageFile = File(imagePath);
        if (await imageFile.exists()) {
          return await uploadToCloudinary(
            imageFile: imageFile,
            folder: folder,
            fileName: fileName,
            useTransformation: useTransformation,
            width: width,
            height: height,
          );
        }
      }

      return imagePath; // Return original path for asset images
    } catch (e) {
      print('Error picking and uploading image: $e');
      return null;
    }
  }

  // Check if image is local (asset or base64)
  static bool isLocalImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return false;
    return imagePath.startsWith('assets/') || 
           imagePath.startsWith('data:image/') ||
           imagePath.startsWith('/') ||
           imagePath.startsWith('file://');
  }

  // Check if image is from Cloudinary
  static bool isCloudinaryImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return false;
    return imagePath.contains('cloudinary.com');
  }
}
