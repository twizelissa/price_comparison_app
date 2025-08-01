import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_event.dart';
import '../../../../shared/utils/auth_helper.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';
import '../../../../config/routes/route_names.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? get currentUser => FirebaseAuth.instance.currentUser;
  bool _isUpdatingPhoto = false;
  
  // Notification settings
  bool _priceAlertsEnabled = true;
  bool _newProductsEnabled = false;
  bool _dealsEnabled = true;
  
  // Preferred locations
  List<String> _preferredLocations = ['Kigali'];
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _priceAlertsEnabled = prefs.getBool('price_alerts_enabled') ?? true;
        _newProductsEnabled = prefs.getBool('new_products_enabled') ?? false;
        _dealsEnabled = prefs.getBool('deals_enabled') ?? true;
        _preferredLocations = prefs.getStringList('preferred_locations') ?? ['Kigali'];
      });
    } catch (e) {
      print('Error loading user preferences: $e');
    }
  }

  Future<void> _saveNotificationSetting(String key, bool value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification settings updated'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving settings: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _savePreferredLocations() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('preferred_locations', _preferredLocations);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Preferred locations updated'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving locations: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateProfilePicture() async {
    try {
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please sign in to update profile picture'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 70,
      );

      if (image == null) return;

      setState(() {
        _isUpdatingPhoto = true;
      });

      // Check if file exists and is valid
      final file = File(image.path);
      if (!await file.exists()) {
        throw Exception('Selected image file not found');
      }

      print('Uploading image to Firebase Storage...');
      
      // Upload to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${currentUser!.uid}.jpg');

      final uploadTask = storageRef.putFile(file);
      
      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Upload progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
      });

      await uploadTask;
      print('Image uploaded successfully');
      
      final downloadUrl = await storageRef.getDownloadURL();
      print('Download URL obtained: $downloadUrl');

      // Update user profile
      await currentUser!.updatePhotoURL(downloadUrl);
      await currentUser!.reload();
      
      print('Profile updated successfully');

      setState(() {
        _isUpdatingPhoto = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error updating profile picture: $e');
      
      setState(() {
        _isUpdatingPhoto = false;
      });

      if (mounted) {
        String errorMessage = 'Error updating profile picture';
        
        if (e.toString().contains('network')) {
          errorMessage = 'Network error. Please check your connection.';
        } else if (e.toString().contains('permission')) {
          errorMessage = 'Permission denied. Please check Firebase rules.';
        } else if (e.toString().contains('unauthorized')) {
          errorMessage = 'Authentication error. Please sign in again.';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$errorMessage: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: AppTextStyles.h4.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            // User logged out successfully
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteNames.signIn,
              (route) => false,
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          backgroundImage: currentUser?.photoURL != null
                              ? NetworkImage(currentUser!.photoURL!)
                              : null,
                          child: currentUser?.photoURL == null
                              ? const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: AppColors.primary,
                                )
                              : null,
                        ),
                        if (_isUpdatingPhoto)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _isUpdatingPhoto ? null : _updateProfilePicture,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      currentUser?.displayName ?? 'User',
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      currentUser?.email ?? 'user@example.com',
                      style: AppTextStyles.h6.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Admin badge
                    if (AuthHelper.isAdmin)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.red.shade400,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.admin_panel_settings,
                              size: 16,
                              color: Colors.red.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Administrator',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Member since ${_formatDate(currentUser?.metadata.creationTime)}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Menu items
              _buildMenuItem(
                icon: Icons.edit_outlined,
                title: 'Edit Profile',
                onTap: () {
                  _showEditProfileDialog();
                },
              ),
              _buildMenuItem(
                icon: Icons.favorite_outlined,
                title: 'My Favorites',
                onTap: () {
                  Navigator.pushNamed(context, '/favorites');
                },
              ),
              _buildMenuItem(
                icon: Icons.history,
                title: 'Price History',
                onTap: () {
                  Navigator.pushNamed(context, '/price-history');
                },
              ),
              _buildMenuItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: _getNotificationStatus(),
                onTap: () {
                  _showNotificationSettings();
                },
              ),
              _buildMenuItem(
                icon: Icons.location_on_outlined,
                title: 'Preferred Locations',
                subtitle: '${_preferredLocations.length} location${_preferredLocations.length != 1 ? 's' : ''} selected',
                onTap: () {
                  _showLocationSettings();
                },
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {
                  _showHelpDialog();
                },
              ),
              _buildMenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {
                  _showPrivacyPolicy();
                },
              ),
              _buildMenuItem(
                icon: Icons.info_outline,
                title: 'About App',
                onTap: () {
                  _showAboutDialog();
                },
              ),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  _showLogoutDialog();
                },
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : AppColors.primary,
        ),
        title: Text(
          title,
          style: AppTextStyles.h6.copyWith(
            color: isDestructive ? Colors.red : AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null 
            ? Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey[600],
                ),
              )
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey.shade400,
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(AuthSignOutRequested());
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: currentUser?.displayName ?? '');
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await currentUser?.updateDisplayName(nameController.text);
                  Navigator.of(context).pop();
                  if (mounted) {
                    setState(() {}); // Refresh the UI
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully!')),
                    );
                  }
                } catch (e) {
                  Navigator.of(context).pop();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.notifications_outlined, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('Notification Settings'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: Text('Price Alerts'),
                    subtitle: Text('Get notified about price changes'),
                    value: _priceAlertsEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setDialogState(() {
                        _priceAlertsEnabled = value;
                      });
                      setState(() {
                        _priceAlertsEnabled = value;
                      });
                      _saveNotificationSetting('price_alerts_enabled', value);
                    },
                  ),
                  SwitchListTile(
                    title: Text('New Products'),
                    subtitle: Text('Get notified about new products'),
                    value: _newProductsEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setDialogState(() {
                        _newProductsEnabled = value;
                      });
                      setState(() {
                        _newProductsEnabled = value;
                      });
                      _saveNotificationSetting('new_products_enabled', value);
                    },
                  ),
                  SwitchListTile(
                    title: Text('Best Deals'),
                    subtitle: Text('Get notified about special offers'),
                    value: _dealsEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setDialogState(() {
                        _dealsEnabled = value;
                      });
                      setState(() {
                        _dealsEnabled = value;
                      });
                      _saveNotificationSetting('deals_enabled', value);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Done', style: TextStyle(color: AppColors.primary)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLocationSettings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.location_on_outlined, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('Preferred Locations'),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                constraints: BoxConstraints(maxHeight: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select your preferred shopping locations to get personalized recommendations',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _preferredLocations.length,
                        itemBuilder: (context, index) {
                          final location = _preferredLocations[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: Icon(Icons.location_city, color: AppColors.primary),
                              title: Text(location),
                              trailing: _preferredLocations.length > 1
                                  ? IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        setDialogState(() {
                                          _preferredLocations.removeAt(index);
                                        });
                                        setState(() {
                                          _preferredLocations.removeAt(index);
                                        });
                                        _savePreferredLocations();
                                      },
                                    )
                                  : Icon(Icons.check_circle, color: Colors.green),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.add_location, color: AppColors.primary),
                        title: Text('Add new location'),
                        onTap: () => _showAddLocationDialog(setDialogState),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Done', style: TextStyle(color: AppColors.primary)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddLocationDialog(StateSetter setDialogState) {
    final commonLocations = [
      'Kigali City Center',
      'Kimisagara',
      'Nyabugogo',
      'Gikondo',
      'Remera',
      'Kacyiru',
      'Gisozi',
      'Kibagabaga',
      'Nyamirambo',
      'Kimihurura',
      'Kanombe',
      'Gatenga',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Location'),
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Enter location name',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Or select from common locations:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: commonLocations.length,
                    itemBuilder: (context, index) {
                      final location = commonLocations[index];
                      final isAlreadyAdded = _preferredLocations.contains(location);
                      
                      return ListTile(
                        title: Text(location),
                        trailing: isAlreadyAdded 
                            ? Icon(Icons.check, color: Colors.green)
                            : null,
                        enabled: !isAlreadyAdded,
                        onTap: isAlreadyAdded ? null : () {
                          _addLocation(location, setDialogState);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_locationController.text.trim().isNotEmpty) {
                  _addLocation(_locationController.text.trim(), setDialogState);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  String _getNotificationStatus() {
    List<String> enabledNotifications = [];
    if (_priceAlertsEnabled) enabledNotifications.add('Price alerts');
    if (_newProductsEnabled) enabledNotifications.add('New products');
    if (_dealsEnabled) enabledNotifications.add('Deals');
    
    if (enabledNotifications.isEmpty) {
      return 'All disabled';
    } else if (enabledNotifications.length == 3) {
      return 'All enabled';
    } else {
      return '${enabledNotifications.length} enabled';
    }
  }

  void _addLocation(String location, StateSetter setDialogState) {
    if (!_preferredLocations.contains(location)) {
      setDialogState(() {
        _preferredLocations.add(location);
      });
      setState(() {
        _preferredLocations.add(location);
      });
      _locationController.clear();
      _savePreferredLocations();
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Help & Support'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How to use the app:'),
              SizedBox(height: 10),
              Text('• Search for products to compare prices'),
              Text('• Add prices to help the community'),
              Text('• Save your favorite products'),
              Text('• Get notifications for price changes'),
              SizedBox(height: 20),
              Text('Contact us: support@pricecheck.rw'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Privacy Policy'),
          content: const SingleChildScrollView(
            child: Text(
              'We respect your privacy and are committed to protecting your personal data. '
              'This app collects price information to help users find the best deals. '
              'Your personal information is never shared with third parties without your consent.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About Price Check'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shopping_cart, size: 50, color: AppColors.primary),
              SizedBox(height: 16),
              Text('Price Check Rwanda'),
              SizedBox(height: 8),
              Text('Version 1.0.0'),
              SizedBox(height: 16),
              Text(
                'Find the best prices for products across Rwanda. '
                'Compare prices from different stores and save money on your purchases.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
