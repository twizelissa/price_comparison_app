import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/product_model.dart';

class DatabaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collections
  static const String _productsCollection = 'products';
  static const String _favoritesCollection = 'favorites';
  static const String _usersCollection = 'users';

  // Get current user ID
  static String? get currentUserId => _auth.currentUser?.uid;

  // Products methods
  static Future<String> addProduct(Product product) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(_productsCollection)
          .add(product.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  static Future<void> updateProduct(Product product) async {
    try {
      if (product.id == null) throw Exception('Product ID is null');
      await _firestore
          .collection(_productsCollection)
          .doc(product.id)
          .update(product.toMap());
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  static Future<void> deleteProduct(String productId) async {
    try {
      await _firestore
          .collection(_productsCollection)
          .doc(productId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  static Future<Product?> getProduct(String productId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_productsCollection)
          .doc(productId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Product.fromMap(data, doc.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Stream<List<Product>> getProducts() {
    try {
      return _firestore
          .collection(_productsCollection)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Product.fromMap(doc.data(), doc.id))
              .toList());
    } catch (e) {
      // Return empty stream on error
      return Stream.value([]);
    }
  }

  static Stream<List<Product>> getProductsByCategory(String category) {
    return _firestore
        .collection(_productsCollection)
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.data(), doc.id))
            .toList());
  }

  static Stream<List<Product>> searchProducts(String query) {
    return _firestore
        .collection(_productsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.data(), doc.id))
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()) ||
                product.description.toLowerCase().contains(query.toLowerCase()) ||
                product.category.toLowerCase().contains(query.toLowerCase()) ||
                product.storeName.toLowerCase().contains(query.toLowerCase()))
            .toList());
  }

  // Favorites methods
  static Future<void> addToFavorites(String userId, String productId) async {
    try {
      FavoriteItem favorite = FavoriteItem(
        userId: userId,
        productId: productId,
        createdAt: DateTime.now(),
      );
      
      await _firestore
          .collection(_favoritesCollection)
          .doc('${userId}_$productId')
          .set(favorite.toMap());
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  static Future<void> removeFavorite(String userId, String productId) async {
    try {
      await _firestore
          .collection(_favoritesCollection)
          .doc('${userId}_$productId')
          .delete();
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  static Stream<List<FavoriteItem>> getFavorites(String userId) {
    return _firestore
        .collection(_favoritesCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return FavoriteItem.fromMap(data, doc.id);
      }).toList();
    });
  }

  static Future<bool> isFavorite(String userId, String productId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_favoritesCollection)
          .doc('${userId}_$productId')
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Image upload method
  static Future<String> uploadImage(File imageFile, String fileName) async {
    try {
      String filePath = 'product_images/${currentUserId}/$fileName';
      UploadTask uploadTask = _storage.ref().child(filePath).putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // User methods
  static Future<void> updateUserProfile({
    required String displayName,
    String? photoURL,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        if (photoURL != null) {
          await user.updatePhotoURL(photoURL);
        }
        
        // Also update in Firestore
        await _firestore.collection(_usersCollection).doc(user.uid).set({
          'displayName': displayName,
          'email': user.email,
          'photoURL': photoURL ?? user.photoURL,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      if (currentUserId == null) return null;
      
      DocumentSnapshot doc = await _firestore
          .collection(_usersCollection)
          .doc(currentUserId)
          .get();
      
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
