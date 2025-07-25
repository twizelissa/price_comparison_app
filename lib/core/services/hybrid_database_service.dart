import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product_model.dart';
import 'sample_data_service.dart';

class HybridDatabaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // SharedPreferences keys
  static const String _productsKey = 'local_products';
  static const String _sampleDataInitializedKey = 'sample_data_initialized';

  // Get current user ID
  static String? get currentUserId => _auth.currentUser?.uid;

  // Initialize sample data on first run
  static Future<void> initializeSampleData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool initialized = prefs.getBool(_sampleDataInitializedKey) ?? false;
      
      if (!initialized) {
        // Try Firebase first
        bool firebaseSuccess = await _addSampleDataToFirebase();
        
        if (!firebaseSuccess) {
          // Fall back to local storage
          await _addSampleDataToLocal();
        }
        
        await prefs.setBool(_sampleDataInitializedKey, true);
        print('Sample data initialized successfully');
      }
    } catch (e) {
      print('Error initializing sample data: $e');
    }
  }

  static Future<bool> _addSampleDataToFirebase() async {
    try {
      final sampleProducts = SampleDataService.getLocalSampleProducts();
      
      for (Product product in sampleProducts) {
        await _firestore.collection('products').doc(product.id).set(product.toMap());
      }
      
      print('Sample data added to Firebase');
      return true;
    } catch (e) {
      print('Failed to add sample data to Firebase: $e');
      return false;
    }
  }

  static Future<void> _addSampleDataToLocal() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final sampleProducts = SampleDataService.getLocalSampleProducts();
      
      List<String> productJsonList = sampleProducts
          .map((product) => jsonEncode(product.toMap()))
          .toList();
      
      await prefs.setStringList(_productsKey, productJsonList);
      print('Sample data added to local storage');
    } catch (e) {
      print('Failed to add sample data to local storage: $e');
    }
  }

  // Add product with hybrid approach
  static Future<String> addProduct(Product product) async {
    try {
      // Check user authentication
      if (_auth.currentUser == null) {
        throw Exception('User not authenticated. Please sign in.');
      }

      print('Adding product to Firebase with user: ${_auth.currentUser?.uid}');
      
      // Try Firebase first
      DocumentReference docRef = await _firestore
          .collection('products')
          .add(product.toMap());
      
      print('Product added to Firebase with ID: ${docRef.id}');
      
      // Also save to local as backup
      await _addProductToLocal(product.copyWith(id: docRef.id));
      
      return docRef.id;
    } catch (e) {
      print('Firebase add failed: $e');
      
      // Check if it's a permission error
      if (e.toString().contains('permission-denied')) {
        // Try with authenticated user data
        try {
          print('Retrying with user authentication check...');
          if (_auth.currentUser != null) {
            print('User is authenticated: ${_auth.currentUser?.email}');
            DocumentReference docRef = await _firestore
                .collection('products')
                .add(product.toMap());
            
            await _addProductToLocal(product.copyWith(id: docRef.id));
            return docRef.id;
          } else {
            throw Exception('Authentication required to add products');
          }
        } catch (retryError) {
          print('Retry failed: $retryError');
          // Fall back to local storage
          return await _addProductToLocal(product);
        }
      } else {
        // Fall back to local storage for other errors
        return await _addProductToLocal(product);
      }
    }
  }

  static Future<String> _addProductToLocal(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productsJson = prefs.getStringList(_productsKey) ?? [];
    
    // Generate ID if not provided
    String productId = product.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    Product productWithId = product.copyWith(id: productId);
    
    productsJson.add(jsonEncode(productWithId.toMap()));
    await prefs.setStringList(_productsKey, productsJson);
    
    return productId;
  }

  // Get products stream with hybrid approach
  static Stream<List<Product>> getProductsStream() async* {
    try {
      // Try Firebase first
      await for (QuerySnapshot snapshot in _firestore.collection('products').snapshots()) {
        List<Product> products = snapshot.docs
            .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        
        // If Firebase has data, use it
        if (products.isNotEmpty) {
          yield products;
          continue;
        }
        
        // If Firebase is empty, fall back to local
        List<Product> localProducts = await _getLocalProducts();
        yield localProducts;
      }
    } catch (e) {
      print('Firebase stream failed, using local data: $e');
      // Fall back to local storage
      List<Product> localProducts = await _getLocalProducts();
      yield localProducts;
    }
  }

  // Get products once (for search functionality)
  static Future<List<Product>> getProducts() async {
    try {
      // Try Firebase first
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      List<Product> products = snapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      
      // If Firebase has data, return it
      if (products.isNotEmpty) {
        return products;
      }
      
      // If Firebase is empty, fall back to local
      return await _getLocalProducts();
    } catch (e) {
      print('Firebase get failed, using local data: $e');
      // Fall back to local storage
      return await _getLocalProducts();
    }
  }

  static Future<List<Product>> _getLocalProducts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> productsJson = prefs.getStringList(_productsKey) ?? [];
      
      if (productsJson.isEmpty) {
        // If no local products, return sample data
        return SampleDataService.getLocalSampleProducts();
      }
      
      return productsJson
          .map((json) {
            Map<String, dynamic> productMap = jsonDecode(json);
            return Product.fromMap(productMap, productMap['id']);
          })
          .toList();
    } catch (e) {
      print('Error loading local products: $e');
      return SampleDataService.getLocalSampleProducts();
    }
  }

  // Update product with hybrid approach
  static Future<void> updateProduct(Product product) async {
    try {
      if (product.id == null) throw Exception('Product ID is null');
      
      // Check user authentication
      if (_auth.currentUser == null) {
        throw Exception('User not authenticated. Please sign in.');
      }

      print('Updating product with ID: ${product.id} by user: ${_auth.currentUser?.uid}');
      
      // Try Firebase first
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(product.toMap());
      
      print('Product updated in Firebase successfully');
      
      // Also update local
      await _updateProductLocal(product);
    } catch (e) {
      print('Firebase update failed: $e');
      
      // Check if it's a permission error
      if (e.toString().contains('permission-denied')) {
        // Try with authenticated user data
        try {
          print('Retrying update with user authentication check...');
          if (_auth.currentUser != null) {
            print('User is authenticated: ${_auth.currentUser?.email}');
            await _firestore
                .collection('products')
                .doc(product.id)
                .update(product.toMap());
            
            await _updateProductLocal(product);
          } else {
            throw Exception('Authentication required to update products');
          }
        } catch (retryError) {
          print('Retry failed: $retryError');
          // Fall back to local storage
          await _updateProductLocal(product);
        }
      } else {
        // Fall back to local storage for other errors
        await _updateProductLocal(product);
      }
    }
  }

  static Future<void> _updateProductLocal(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productsJson = prefs.getStringList(_productsKey) ?? [];
    
    for (int i = 0; i < productsJson.length; i++) {
      Map<String, dynamic> productMap = jsonDecode(productsJson[i]);
      if (productMap['id'] == product.id) {
        productsJson[i] = jsonEncode(product.toMap());
        break;
      }
    }
    
    await prefs.setStringList(_productsKey, productsJson);
  }

  // Delete product with hybrid approach
  static Future<void> deleteProduct(String productId) async {
    try {
      // Try Firebase first
      await _firestore
          .collection('products')
          .doc(productId)
          .delete();
      
      // Also delete from local
      await _deleteProductLocal(productId);
    } catch (e) {
      print('Firebase delete failed, using local storage: $e');
      // Fall back to local storage
      await _deleteProductLocal(productId);
    }
  }

  static Future<void> _deleteProductLocal(String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productsJson = prefs.getStringList(_productsKey) ?? [];
    
    productsJson.removeWhere((json) {
      Map<String, dynamic> productMap = jsonDecode(json);
      return productMap['id'] == productId;
    });
    
    await prefs.setStringList(_productsKey, productsJson);
  }

  // Get product by ID
  static Future<Product?> getProduct(String productId) async {
    try {
      // Try Firebase first
      DocumentSnapshot doc = await _firestore
          .collection('products')
          .doc(productId)
          .get();
      
      if (doc.exists) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      
      // Fall back to local
      return await _getProductLocal(productId);
    } catch (e) {
      print('Firebase get failed, using local storage: $e');
      return await _getProductLocal(productId);
    }
  }

  static Future<Product?> _getProductLocal(String productId) async {
    List<Product> localProducts = await _getLocalProducts();
    try {
      return localProducts.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  // Favorites functionality
  static Future<void> addFavorite(String userId, String productId) async {
    try {
      // Create FavoriteItem and use its toMap method
      final favoriteItem = FavoriteItem(
        userId: userId,
        productId: productId,
        createdAt: DateTime.now(),
      );

      // Try Firebase first
      await _firestore
          .collection('user_favorites')
          .doc('${userId}_$productId')
          .set(favoriteItem.toMap());

      // Also save to local
      await _addFavoriteLocal(userId, productId);
    } catch (e) {
      print('Firebase add favorite failed, using local storage: $e');
      await _addFavoriteLocal(userId, productId);
    }
  }

  static Future<void> _addFavoriteLocal(String userId, String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites_$userId') ?? [];
    if (!favorites.contains(productId)) {
      favorites.add(productId);
      await prefs.setStringList('favorites_$userId', favorites);
    }
  }

  static Future<void> removeFavorite(String userId, String productId) async {
    try {
      // Try Firebase first
      await _firestore
          .collection('user_favorites')
          .doc('${userId}_$productId')
          .delete();

      // Also remove from local
      await _removeFavoriteLocal(userId, productId);
    } catch (e) {
      print('Firebase remove favorite failed, using local storage: $e');
      await _removeFavoriteLocal(userId, productId);
    }
  }

  static Future<void> _removeFavoriteLocal(String userId, String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites_$userId') ?? [];
    favorites.remove(productId);
    await prefs.setStringList('favorites_$userId', favorites);
  }

  static Stream<List<FavoriteItem>> getFavorites(String userId) async* {
    try {
      // Try Firebase first
      await for (QuerySnapshot snapshot in _firestore
          .collection('user_favorites')
          .where('userId', isEqualTo: userId)
          .snapshots()) {
        List<FavoriteItem> favorites = snapshot.docs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>?;
              return FavoriteItem(
                id: doc.id,
                productId: data?['productId'] ?? '',
                userId: userId,
                createdAt: (data?['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
              );
            })
            .toList();

        if (favorites.isNotEmpty) {
          yield favorites;
          continue;
        }

        // If Firebase is empty, fall back to local
        List<FavoriteItem> localFavorites = await _getFavoritesLocal(userId);
        yield localFavorites;
      }
    } catch (e) {
      print('Firebase favorites stream failed, using local data: $e');
      List<FavoriteItem> localFavorites = await _getFavoritesLocal(userId);
      yield localFavorites;
    }
  }

  static Future<List<FavoriteItem>> _getFavoritesLocal(String userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> favoriteIds = prefs.getStringList('favorites_$userId') ?? [];
      
      return favoriteIds.map((productId) => FavoriteItem(
        id: '${userId}_$productId',
        productId: productId,
        userId: userId,
        createdAt: DateTime.now(),
      )).toList();
    } catch (e) {
      print('Error loading local favorites: $e');
      return [];
    }
  }

  static Future<bool> isFavorite(String userId, String productId) async {
    try {
      // Try Firebase first
      DocumentSnapshot doc = await _firestore
          .collection('user_favorites')
          .doc('${userId}_$productId')
          .get();
      
      if (doc.exists) return true;

      // Fall back to local
      return await _isFavoriteLocal(userId, productId);
    } catch (e) {
      return await _isFavoriteLocal(userId, productId);
    }
  }

  static Future<bool> _isFavoriteLocal(String userId, String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites_$userId') ?? [];
    return favorites.contains(productId);
  }
  }