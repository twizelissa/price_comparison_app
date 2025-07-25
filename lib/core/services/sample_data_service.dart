import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class SampleDataService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addSampleProducts() async {
    try {
      // Check if sample products already exist
      final existingProducts = await _firestore.collection('products').limit(1).get();
      if (existingProducts.docs.isNotEmpty) {
        print('Sample products already exist, skipping...');
        return;
      }

      final List<Product> sampleProducts = [
        Product(
          id: 'sample_1',
          name: 'iPhone 15 Pro',
          category: 'Electronics',
          description: 'Latest Apple iPhone 15 Pro with A17 Pro chip and titanium design',
          price: 1299.99,
          storeName: 'iStore Rwanda',
          storeLocation: 'Kigali City Tower, KG 1 Ave',
          storePhoneNumber: '+250781234567',
          imageUrl: '',
          localImagePath: 'assets/images/products/Apple-iPhone-15.jpg',
          userId: 'sample_user',
          createdAt: DateTime.now(),
        ),
        Product(
          id: 'sample_2',
          name: 'Samsung Galaxy S24 Ultra',
          category: 'Electronics',
          description: 'Premium Samsung flagship with S Pen and advanced camera system',
          price: 1199.99,
          storeName: 'Samsung Store',
          storeLocation: 'UTC Mall, KN 4 St',
          storePhoneNumber: '+250787654321',
          imageUrl: '',
          localImagePath: 'assets/images/products/s24.jpg',
          userId: 'sample_user',
          createdAt: DateTime.now(),
        ),
        Product(
          id: 'sample_3',
          name: 'Google Pixel 8 Pro',
          category: 'Electronics',
          description: 'Google Pixel 8 Pro with advanced AI photography and Android 14',
          price: 999.99,
          storeName: 'TechHub Rwanda',
          storeLocation: 'Remera, KG 7 Ave',
          storePhoneNumber: '+250783456789',
          imageUrl: '',
          localImagePath: 'assets/images/products/pixel 8.jpeg',
          userId: 'sample_user',
          createdAt: DateTime.now(),
        ),
        Product(
          id: 'sample_4',
          name: 'iPhone 14',
          category: 'Electronics',
          description: 'Apple iPhone 14 with improved battery life and camera features',
          price: 899.99,
          storeName: 'Mobile World',
          storeLocation: 'Nyabugogo, KG 11 Ave',
          storePhoneNumber: '+250789012345',
          imageUrl: '',
          localImagePath: 'assets/images/products/iphone 14.jpg',
          userId: 'sample_user',
          createdAt: DateTime.now(),
        ),
        Product(
          id: 'sample_5',
          name: 'Samsung Galaxy Z Fold 5',
          category: 'Electronics',
          description: 'Foldable smartphone with large inner display and multitasking features',
          price: 1599.99,
          storeName: 'Future Tech',
          storeLocation: 'Kisimenti, KG 563 St',
          storePhoneNumber: '+250785678901',
          imageUrl: '',
          localImagePath: 'assets/images/products/Z-fold.jpeg',
          userId: 'sample_user',
          createdAt: DateTime.now(),
        ),
        Product(
          id: 'sample_6',
          name: 'Lenovo ThinkPad',
          category: 'Electronics',
          description: 'Professional laptop with business-grade performance and security',
          price: 1299.99,
          storeName: 'Computer Corner',
          storeLocation: 'Gisozi, KG 15 Ave',
          storePhoneNumber: '+250786789012',
          imageUrl: '',
          localImagePath: 'assets/images/products/Lenovo-laptop.png',
          userId: 'sample_user',
          createdAt: DateTime.now(),
        ),
      ];

      // Add each sample product to Firestore
      for (Product product in sampleProducts) {
        await _firestore.collection('products').doc(product.id).set(product.toMap());
      }

      print('Sample products added successfully!');
    } catch (e) {
      print('Error adding sample products: $e');
      // If Firestore fails, we'll use local data instead
    }
  }

  // Get local sample products for display when Firestore is not available
  static List<Product> getLocalSampleProducts() {
    return [
      Product(
        id: 'local_1',
        name: 'iPhone 15 Pro',
        category: 'Electronics',
        description: 'Latest Apple iPhone 15 Pro with A17 Pro chip and titanium design',
        price: 1299.99,
        storeName: 'iStore Rwanda',
        storeLocation: 'Kigali City Tower, KG 1 Ave',
        storePhoneNumber: '+250781234567',
        imageUrl: '',
        localImagePath: 'assets/images/products/Apple-iPhone-15.jpg',
        userId: 'sample_user',
        createdAt: DateTime.now(),
      ),
      Product(
        id: 'local_2',
        name: 'Samsung Galaxy S24 Ultra',
        category: 'Electronics',
        description: 'Premium Samsung flagship with S Pen and advanced camera system',
        price: 1199.99,
        storeName: 'Samsung Store',
        storeLocation: 'UTC Mall, KN 4 St',
        storePhoneNumber: '+250787654321',
        imageUrl: '',
        localImagePath: 'assets/images/products/s24.jpg',
        userId: 'sample_user',
        createdAt: DateTime.now(),
      ),
      Product(
        id: 'local_3',
        name: 'Google Pixel 8 Pro',
        category: 'Electronics',
        description: 'Google Pixel 8 Pro with advanced AI photography and Android 14',
        price: 999.99,
        storeName: 'TechHub Rwanda',
        storeLocation: 'Remera, KG 7 Ave',
        storePhoneNumber: '+250783456789',
        imageUrl: '',
        localImagePath: 'assets/images/products/pixel 8.jpeg',
        userId: 'sample_user',
        createdAt: DateTime.now(),
      ),
      Product(
        id: 'local_4',
        name: 'iPhone 14',
        category: 'Electronics',
        description: 'Apple iPhone 14 with improved battery life and camera features',
        price: 899.99,
        storeName: 'Mobile World',
        storeLocation: 'Nyabugogo, KG 11 Ave',
        storePhoneNumber: '+250789012345',
        imageUrl: '',
        localImagePath: 'assets/images/products/iphone 14.jpg',
        userId: 'sample_user',
        createdAt: DateTime.now(),
      ),
      Product(
        id: 'local_5',
        name: 'Samsung Galaxy Z Fold 5',
        category: 'Electronics',
        description: 'Foldable smartphone with large inner display and multitasking features',
        price: 1599.99,
        storeName: 'Future Tech',
        storeLocation: 'Kisimenti, KG 563 St',
        storePhoneNumber: '+250785678901',
        imageUrl: '',
        localImagePath: 'assets/images/products/Z-fold.jpeg',
        userId: 'sample_user',
        createdAt: DateTime.now(),
      ),
      Product(
        id: 'local_6',
        name: 'Lenovo ThinkPad',
        category: 'Electronics',
        description: 'Professional laptop with business-grade performance and security',
        price: 1299.99,
        storeName: 'Computer Corner',
        storeLocation: 'Gisozi, KG 15 Ave',
        storePhoneNumber: '+250786789012',
        imageUrl: '',
        localImagePath: 'assets/images/products/Lenovo-laptop.png',
        userId: 'sample_user',
        createdAt: DateTime.now(),
      ),
    ];
  }
}
