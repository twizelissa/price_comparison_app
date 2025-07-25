# Cloudinary Setup Guide

This guide will help you set up Cloudinary for image storage in your price comparison app.

## 1. Create a Cloudinary Account

1. Go to [https://cloudinary.com/](https://cloudinary.com/)
2. Sign up for a free account
3. Verify your email address

## 2. Get Your Cloudinary Credentials

After signing up, you'll be taken to your dashboard where you can find:

- **Cloud Name**: This is your unique identifier (e.g., "your-cloud-name")
- **API Key**: Your public API key
- **API Secret**: Your private API secret (keep this secure)

## 3. Configure Your App

### Update Cloud Name

1. Open `lib/core/config/cloudinary_config.dart`
2. Replace `'your-cloud-name'` with your actual Cloudinary cloud name:

```dart
class CloudinaryConfig {
  // Replace with your actual Cloudinary cloud name
  static const String cloudName = 'your-actual-cloud-name';
  // ... rest of the configuration
}
```

### Create Upload Preset (Recommended)

1. In your Cloudinary dashboard, go to **Settings** > **Upload**
2. Scroll down to **Upload presets**
3. Click **Add upload preset**
4. Configure the preset:
   - **Preset name**: `price_comparison_preset`
   - **Signing Mode**: `Unsigned` (for client-side uploads)
   - **Folder**: `price_comparison` (optional)
   - **Transformation**: Add transformations like:
     - Width: 400px
     - Height: 400px
     - Crop: Fill
     - Quality: Auto
     - Format: WebP
5. Save the preset

### Update Upload Preset (Optional)

If you created a custom upload preset, update it in the config:

```dart
static const String uploadPreset = 'price_comparison_preset';
```

## 4. Image Upload Features

The app now supports:

### For Users:
- **Upload to Cloudinary**: Images are stored in the cloud and accessible via URL
- **Local Images**: Use device gallery, camera, or preset asset images
- **Automatic Optimization**: Cloudinary automatically optimizes images for web delivery

### For Developers:
- **Automatic Transformations**: Images are resized and optimized automatically
- **Multiple Formats**: Support for WebP, JPEG, PNG
- **Cloud Storage**: Reduces app size and improves performance
- **CDN Delivery**: Fast image loading from Cloudinary's global CDN

## 5. Usage in the App

### Adding Products with Images

1. Navigate to "Add Product" page
2. Tap on the image picker area
3. Choose between:
   - **Upload to Cloudinary**: Takes photo/selects from gallery and uploads to cloud
   - **Use Local Image**: Uses local device storage or preset images

### Image Display

- Images with a green "Cloud" badge are stored in Cloudinary
- Local images are stored on the device
- All images are displayed seamlessly regardless of source

## 6. Cloudinary Dashboard Features

### Monitor Usage
- Track your usage in the Cloudinary dashboard
- Free tier includes 25,000 monthly transformations
- Monitor bandwidth and storage usage

### Manage Images
- View all uploaded images in the Media Library
- Organize images into folders
- Delete unused images to save storage

### Advanced Features
- Auto-tagging and AI-powered features
- Advanced transformations
- Video support (for future features)

## 7. Best Practices

### For Development
- Use different folders for development and production
- Consider creating separate Cloudinary accounts for dev/prod
- Monitor your usage to avoid exceeding free tier limits

### For Production
- Set up proper backup strategies
- Monitor image optimization settings
- Consider upgrading to paid plan if needed

### Security
- Never expose your API Secret in client-side code
- Use unsigned upload presets for client-side uploads
- Implement proper access controls if needed

## 8. Troubleshooting

### Common Issues

1. **"Invalid cloud name"**: Check that your cloud name is correct in the config
2. **Upload fails**: Ensure your upload preset allows unsigned uploads
3. **Images not loading**: Check network connectivity and Cloudinary URLs

### Debug Tips
- Check the console for error messages
- Verify your Cloudinary dashboard for uploaded images
- Test with different image sizes and formats

## 9. Cost Optimization

### Free Tier Limits
- 25,000 monthly transformations
- 25 GB managed storage
- 25 GB monthly bandwidth

### Optimization Tips
- Use automatic quality optimization
- Enable WebP format for better compression
- Set appropriate image dimensions
- Clean up unused images regularly

## 10. Migration from Local Storage

If you were using local storage before:

1. Existing products with local images will continue to work
2. New products can use either local or Cloudinary storage
3. Users can choose their preferred upload method
4. The app handles both storage types seamlessly

---

## Support

For Cloudinary-specific issues:
- [Cloudinary Documentation](https://cloudinary.com/documentation)
- [Cloudinary Support](https://support.cloudinary.com/)

For app-specific issues:
- Check the console logs for error messages
- Verify your configuration settings
- Test with different image types and sizes
