import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/services/hybrid_database_service.dart';
import '../../../../core/utils/image_handler.dart';
import '../../../../core/config/cloudinary_config.dart';
import '../../../../shared/utils/auth_helper.dart';
import '../../../../config/routes/route_names.dart';

class AddPricePage extends StatefulWidget {
  const AddPricePage({super.key});

  @override
  State<AddPricePage> createState() => _AddPricePageState();
}

class _AddPricePageState extends State<AddPricePage> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String _selectedCategory = 'Food & Beverages';
  final List<String> _categories = [
    'Food & Beverages',
    'Electronics',
    'Clothing',
    'Health & Beauty',
    'Home & Garden',
    'Sports & Outdoors',
    'Books & Education',
    'Other',
  ];

  bool _isSubmitting = false;
  String? _selectedImagePath;
  String? _cloudinaryImageUrl; // Store Cloudinary URL separately
  bool _isUploadingImage = false;
  Product? _editingProduct; // Store the product being edited

  @override
  void initState() {
    super.initState();
    // Check if user is authenticated
    if (!AuthHelper.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, RouteNames.signIn);
      });
      return;
    }
    
    // Check if we're editing an existing product
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Product) {
        _editingProduct = args;
        _prefillForm();
      }
    });
  }

  void _prefillForm() {
    if (_editingProduct != null) {
      setState(() {
        _productNameController.text = _editingProduct!.name;
        _priceController.text = _editingProduct!.price.toString();
        _storeNameController.text = _editingProduct!.storeName;
        _locationController.text = _editingProduct!.storeLocation;
        _descriptionController.text = _editingProduct!.description;
        _phoneController.text = _editingProduct!.storePhoneNumber;
        _selectedCategory = _editingProduct!.category;
        
        // Handle image
        if (_editingProduct!.imageUrl.isNotEmpty) {
          _cloudinaryImageUrl = _editingProduct!.imageUrl;
          _selectedImagePath = _editingProduct!.imageUrl;
        } else if (_editingProduct!.localImagePath.isNotEmpty) {
          _selectedImagePath = _editingProduct!.localImagePath;
        }
      });
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    _storeNameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      setState(() {
        _isUploadingImage = true;
      });

      // Show dialog to choose image source and upload option
      final result = await _showImageUploadDialog();
      
      if (result != null) {
        setState(() {
          if (result['cloudinaryUrl'] != null) {
            _cloudinaryImageUrl = result['cloudinaryUrl'];
            _selectedImagePath = result['cloudinaryUrl']; // Use Cloudinary URL as selected path
          } else {
            _selectedImagePath = result['localPath'];
            _cloudinaryImageUrl = null;
          }
        });

        if (result['cloudinaryUrl'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image uploaded to Cloudinary successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  Future<Map<String, String>?> _showImageUploadDialog() async {
    return await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.cloud_upload),
                title: const Text('Upload to Cloudinary'),
                subtitle: const Text('Upload and store in cloud'),
                onTap: () async {
                  Navigator.pop(context, 'cloudinary');
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Use Local Image'),
                subtitle: const Text('Choose from device or assets'),
                onTap: () async {
                  Navigator.pop(context, 'local');
                },
              ),
            ],
          ),
        );
      },
    ).then((choice) async {
      if (choice == 'cloudinary') {
        final cloudinaryUrl = await ImageHandler.pickAndUploadToCloudinary(
          context: context,
          folder: CloudinaryConfig.productsFolder,
          useTransformation: true,
          width: CloudinaryConfig.defaultWidth,
          height: CloudinaryConfig.defaultHeight,
        );
        
        if (cloudinaryUrl != null) {
          return {'cloudinaryUrl': cloudinaryUrl};
        }
      } else if (choice == 'local') {
        final localPath = await ImageHandler.showImageSelectionDialog(context);
        
        if (localPath != null) {
          return {'localPath': localPath};
        }
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          _editingProduct != null ? 'Edit Product' : 'Add Product Price',
          style: AppTextStyles.h4.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary.withOpacity(0.1), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add New Product',
                            style: AppTextStyles.h5.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Help others find the best prices!',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 25),
              
              // Product Image Section
              _buildImagePicker(),
              
              const SizedBox(height: 25),
              
              // Product Name
              _buildTextField(
                controller: _productNameController,
                label: 'Product Name',
                hint: 'e.g., Samsung Galaxy S24',
                icon: Icons.shopping_bag_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the product name';
                  }
                  if (value.trim().length < 2) {
                    return 'Product name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Category Dropdown
              _buildCategoryDropdown(),
              
              const SizedBox(height: 20),
              
              // Description
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Brief description of the product',
                icon: Icons.description_outlined,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Price
              _buildTextField(
                controller: _priceController,
                label: 'Price (RWF)',
                hint: 'e.g., 150000',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the price';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Please enter a valid price';
                  }
                  if (double.parse(value.trim()) <= 0) {
                    return 'Price must be greater than 0';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 25),
              
              // Store Information Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.store,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Store Information',
                      style: AppTextStyles.h6.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Store Name
              _buildTextField(
                controller: _storeNameController,
                label: 'Store Name',
                hint: 'e.g., Electronics Plus',
                icon: Icons.store_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the store name';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Store Location
              _buildTextField(
                controller: _locationController,
                label: 'Store Location',
                hint: 'e.g., Downtown Kigali, KG 1 Ave',
                icon: Icons.location_on_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the store location';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Store Phone
              _buildTextField(
                controller: _phoneController,
                label: 'Store Phone Number',
                hint: 'e.g., +250 781 234 567',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the store phone number';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 30),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(_editingProduct != null ? Icons.edit : Icons.add_shopping_cart, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              _editingProduct != null ? 'Update Product' : 'Add Product',
                              style: AppTextStyles.h6.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Image',
          style: AppTextStyles.h6.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[50],
            ),
            child: _isUploadingImage
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text('Uploading image...'),
                    ],
                  )
                : _selectedImagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        ImageHandler.displayImage(
                          _selectedImagePath,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        if (_cloudinaryImageUrl != null)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.cloud_done, size: 16, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    'Cloud',
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tap to add product image',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _cloudinaryImageUrl != null 
                            ? 'Upload to cloud, take photo, choose from gallery, or use preset images'
                            : 'Take photo, choose from gallery, or use preset images',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
        ),
        
        if (_selectedImagePath != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green[600],
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                _cloudinaryImageUrl != null 
                    ? 'Image uploaded to Cloudinary'
                    : 'Image selected',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.green[600],
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedImagePath = null;
                  });
                },
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Remove'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red[600],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
            color: Colors.white,
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.category_outlined, color: AppColors.primary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            items: _categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedCategory = newValue;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      if (_editingProduct != null) {
        // Update existing product
        Product updatedProduct = _editingProduct!.copyWith(
          name: _productNameController.text.trim(),
          description: _descriptionController.text.trim(),
          price: double.parse(_priceController.text.trim()),
          category: _selectedCategory,
          imageUrl: _cloudinaryImageUrl ?? _editingProduct!.imageUrl,
          localImagePath: _cloudinaryImageUrl == null ? (_selectedImagePath ?? _editingProduct!.localImagePath) : '',
          storeName: _storeNameController.text.trim(),
          storeLocation: _locationController.text.trim(),
          storePhoneNumber: _phoneController.text.trim(),
        );

        await HybridDatabaseService.updateProduct(updatedProduct);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✅ Product updated successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );

          // Navigate back with success result
          Navigator.of(context).pop(true);
        }
      } else {
        // Add new product
        Product product = Product(
          name: _productNameController.text.trim(),
          description: _descriptionController.text.trim(),
          price: double.parse(_priceController.text.trim()),
          category: _selectedCategory,
          imageUrl: _cloudinaryImageUrl ?? '', // Use Cloudinary URL if available
          localImagePath: _cloudinaryImageUrl == null ? (_selectedImagePath ?? '') : '', // Use local path only if no Cloudinary URL
          storeName: _storeNameController.text.trim(),
          storeLocation: _locationController.text.trim(),
          storePhoneNumber: _phoneController.text.trim(),
          userId: AuthHelper.currentUserId!,
          createdAt: DateTime.now(),
        );

        // Save to database using hybrid service
        await HybridDatabaseService.addProduct(product);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✅ Product added successfully! Everyone can now see it.'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );

          // Clear form
          _productNameController.clear();
          _priceController.clear();
          _storeNameController.clear();
          _locationController.clear();
          _descriptionController.clear();
          _phoneController.clear();
          setState(() {
            _selectedCategory = 'Food & Beverages';
            _selectedImagePath = null;
            _cloudinaryImageUrl = null;
          });

          // Navigate back to home
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error ${_editingProduct != null ? 'updating' : 'adding'} product: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
