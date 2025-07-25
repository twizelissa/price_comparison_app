class CloudinaryConfig {
  // Replace with your actual Cloudinary cloud name
  static const String cloudName = 'your-cloud-name';
  
  // Upload presets (optional - you can create these in Cloudinary dashboard)
  static const String uploadPreset = 'ml_default';
  
  // Folder structure for different image types
  static const String productsFolder = 'price_comparison/products';
  static const String usersFolder = 'price_comparison/users';
  static const String generalFolder = 'price_comparison/general';
  
  // Default image transformations
  static const int defaultWidth = 400;
  static const int defaultHeight = 400;
  static const int thumbnailWidth = 150;
  static const int thumbnailHeight = 150;
  
  // Image quality settings
  static const String defaultQuality = 'auto:low';
  static const String defaultFormat = 'webp';
  static const String defaultCrop = 'fill';
}
