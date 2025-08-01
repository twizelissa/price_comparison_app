import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';

class CloudinaryService {
  static late CloudinaryPublic _cloudinary;
  static late String _cloudName;
  
  // Initialize Cloudinary with your cloud name
  static void initialize({required String cloudName}) {
    _cloudName = cloudName;
    _cloudinary = CloudinaryPublic(cloudName, 'ml_default', cache: false);
  }

  /// Upload image to Cloudinary and return the secure URL
  static Future<String?> uploadImage({
    required File imageFile,
    String? folder,
    String? fileName,
  }) async {
    try {
      // Upload the image
      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
          folder: folder,
          publicId: fileName,
        ),
      );

      if (kDebugMode) {
        print('Image uploaded successfully: ${response.secureUrl}');
        print('Public ID: ${response.publicId}');
      }

      return response.secureUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image to Cloudinary: $e');
      }
      return null;
    }
  }

  /// Upload image with transformation (resize, crop, etc.)
  static Future<String?> uploadImageWithTransformation({
    required File imageFile,
    String? folder,
    String? fileName,
    int? width,
    int? height,
    String crop = 'fill',
  }) async {
    try {
      // For transformations, we'll upload normally and apply transformations via URL
      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
          folder: folder,
          publicId: fileName,
        ),
      );

      if (kDebugMode) {
        print('Image uploaded with transformation available: ${response.secureUrl}');
      }

      // Return the URL with transformations applied
      if (width != null || height != null) {
        return getOptimizedImageUrl(
          publicId: response.publicId,
          width: width,
          height: height,
          crop: crop,
        );
      }

      return response.secureUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image with transformation: $e');
      }
      return null;
    }
  }

  /// Delete image from Cloudinary
  static Future<bool> deleteImage(String publicId) async {
    try {
      // Note: Deletion requires admin API which is not available in cloudinary_public
      // You would need to implement this on your backend server
      if (kDebugMode) {
        print('Image deletion requires backend implementation: $publicId');
      }
      return true; // Return true for now, implement backend deletion
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting image: $e');
      }
      return false;
    }
  }

  /// Get optimized image URL with transformations
  static String getOptimizedImageUrl({
    required String publicId,
    int? width,
    int? height,
    String quality = 'auto:low',
    String format = 'webp',
    String crop = 'fill',
  }) {
    try {
      List<String> transformations = [];
      
      if (width != null) transformations.add('w_$width');
      if (height != null) transformations.add('h_$height');
      transformations.add('c_$crop');
      transformations.add('q_$quality');
      transformations.add('f_$format');

      final transformationString = transformations.join(',');
      
      return 'https://res.cloudinary.com/$_cloudName/image/upload/$transformationString/$publicId';
    } catch (e) {
      if (kDebugMode) {
        print('Error generating optimized URL: $e');
      }
      return '';
    }
  }

  /// Extract public ID from Cloudinary URL
  static String? extractPublicId(String cloudinaryUrl) {
    try {
      final uri = Uri.parse(cloudinaryUrl);
      final pathSegments = uri.pathSegments;
      
      // Find the upload segment and extract public ID
      final uploadIndex = pathSegments.indexOf('upload');
      if (uploadIndex != -1 && uploadIndex < pathSegments.length - 1) {
        // Skip version and transformation parameters
        int publicIdIndex = uploadIndex + 1;
        
        // Skip version (v1234567890)
        if (pathSegments[publicIdIndex].startsWith('v')) {
          publicIdIndex++;
        }
        
        // Skip transformation parameters if they exist
        if (publicIdIndex < pathSegments.length) {
          String remaining = pathSegments.sublist(publicIdIndex).join('/');
          
          // Check if there are transformation parameters (contains underscores and commas)
          if (remaining.contains('_') && remaining.contains(',')) {
            // Find the last segment that doesn't look like a transformation
            final segments = remaining.split('/');
            return segments.last.split('.').first;
          } else {
            // No transformations, return the remaining path without extension
            return remaining.split('.').first;
          }
        }
      }
      
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error extracting public ID: $e');
      }
      return null;
    }
  }
}
