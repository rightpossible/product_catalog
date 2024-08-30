import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:product_catalog/core/errors/exception.dart';
import 'package:product_catalog/features/product/data/models/product_model.dart';
import 'package:product_catalog/core/constant/database_string.dart';
import 'package:mime/mime.dart';

/// Abstract class defining the contract for product remote data operations.
abstract class ProductRemoteDataSource {
  Stream<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(String id);
  Future<ProductModel> addProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<bool> deleteProduct(String id);
  Future<String> uploadImage(String localImageUrl);
  Future<void> deleteImage(String imageUrl);
  Future<List<ProductModel>> filterProductsByCategory(String category);
  Future<List<ProductModel>> filterProductsByPriceRange(double min, double max);
  Stream<List<ProductModel>> filterProducts(
      String? category, double minPrice, double maxPrice);
}

/// Implementation of [ProductRemoteDataSource] using Firebase services.
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  /// Constructs a [ProductRemoteDataSourceImpl] with the given Firestore and Storage instances.
  ProductRemoteDataSourceImpl(this._firestore, this._storage);

  /// Retrieves a stream of all products from Firestore.
  ///
  /// Returns a [Stream] of [List<ProductModel>].
  /// Throws a [ServerException] if there's an error.
  @override
  Stream<List<ProductModel>> getAllProducts() {
    try {
      return _firestore
          .collection(DatabaseString.productCollectionName)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ProductModel.fromJson(doc.data()))
              .toList());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Adds a new product to Firestore.
  ///
  /// Takes a [ProductModel] as input and returns the updated [ProductModel] with a new ID.
  /// Throws a [ServerException] if there's an error during the operation.
  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    try {
      print('Attempting to add product: ${product.toJson()}');
      final docRef = await _firestore
          .collection(DatabaseString.productCollectionName)
          .add(product.toJson());

      print('Product added successfully. Document reference: ${docRef.id}');

      // Update the product's ID with the Firestore-generated ID
      final updatedProduct = product.copyWith(id: docRef.id);
      print('Returning product: ${updatedProduct.toJson()}');
      return updatedProduct;
    } catch (e) {
      print('Error adding product: $e');
      throw ServerException(e.toString());
    }
  }

  /// Deletes a product from Firestore by its ID.
  ///
  /// Returns [true] if the product was successfully deleted, [false] otherwise.
  /// Throws an [Exception] if there's an error during the operation.
  @override
  Future<bool> deleteProduct(String id) async {
    try {
      print('RemoteDataSource: Attempting to delete product with id: $id');
      final querySnapshot = await _firestore
          .collection(DatabaseString.productCollectionName)
          .where('id', isEqualTo: id)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('RemoteDataSource: Product with id $id does not exist');
        return false;
      }

      // There should only be one document with this ID, but we'll delete all matches just in case
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
        print(
            'RemoteDataSource: Deleted document with Firestore ID: ${doc.id}');
      }

      // Verify deletion
      final verifySnapshot = await _firestore
          .collection(DatabaseString.productCollectionName)
          .where('id', isEqualTo: id)
          .get();

      if (verifySnapshot.docs.isEmpty) {
        print('RemoteDataSource: Product deleted successfully and verified');
        return true;
      } else {
        print('RemoteDataSource: Product deletion failed on verification');
        return false;
      }
    } catch (e) {
      print('RemoteDataSource: Error deleting product: $e');
      if (e is FirebaseException) {
        print('Firebase error code: ${e.code}');
        print('Firebase error message: ${e.message}');
      }
      throw Exception('Failed to delete product: $e');
    }
  }

  /// Retrieves a product from Firestore by its ID.
  ///
  /// Returns a [ProductModel] if found.
  /// Throws an [Exception] if there's an error or the product is not found.
  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final snapshot = await _firestore
          .collection(DatabaseString.productCollectionName)
          .doc(id)
          .get();
      return ProductModel.fromJson(snapshot.data()!);
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Updates an existing product in Firestore.
  ///
  /// Takes a [ProductModel] as input and returns the updated [ProductModel].
  /// Throws an [Exception] if there's an error or the product is not found.
  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      print(
          'RemoteDataSource: Attempting to update product with id: ${product.id}');
      final querySnapshot = await _firestore
          .collection(DatabaseString.productCollectionName)
          .where('id', isEqualTo: product.id)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('RemoteDataSource: Product with id ${product.id} does not exist');
        throw Exception('Product not found');
      }

      // There should only be one document with this ID, but we'll update all matches just in case
      for (var doc in querySnapshot.docs) {
        await doc.reference.update(product.toJson());
        print(
            'RemoteDataSource: Updated document with Firestore ID: ${doc.id}');
      }

      // Verify update
      final verifySnapshot = await _firestore
          .collection(DatabaseString.productCollectionName)
          .where('id', isEqualTo: product.id)
          .get();

      if (verifySnapshot.docs.isNotEmpty) {
        final updatedProduct =
            ProductModel.fromJson(verifySnapshot.docs.first.data());
        print('RemoteDataSource: Product updated successfully and verified');
        return updatedProduct;
      } else {
        print('RemoteDataSource: Product update failed on verification');
        throw Exception('Failed to update product');
      }
    } catch (e) {
      print('RemoteDataSource: Error updating product: $e');
      if (e is FirebaseException) {
        print('Firebase error code: ${e.code}');
        print('Firebase error message: ${e.message}');
      }
      throw Exception('Failed to update product: $e');
    }
  }

  /// Uploads an image to Firebase Storage.
  ///
  /// Takes a local image URL and returns the download URL of the uploaded image.
  /// Throws an [Exception] if there's an error during the upload process.
  @override
  Future<String> uploadImage(String localImageUrl) async {
    try {
      final file = File(localImageUrl);
      if (!await file.exists()) {
        throw Exception('Local file does not exist: $localImageUrl');
      }

      final mimeType = lookupMimeType(file.path);
      final fileExtension = mimeType != null ? mimeType.split('/').last : 'jpg';
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final storageRef = _storage.ref('product_images/$fileName');

      print('Attempting to upload file: ${file.path}');
      print('To storage location: ${storageRef.fullPath}');

      final metadata = SettableMetadata(
        contentType: mimeType,
        customMetadata: {'picked-file-path': file.path},
      );

      final uploadTask = storageRef.putFile(file, metadata);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print(
            'Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
      });

      final snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        final downloadUrl = await snapshot.ref.getDownloadURL();
        print('Image uploaded successfully. Download URL: $downloadUrl');
        return downloadUrl;
      } else {
        throw Exception('Upload did not complete successfully');
      }
    } catch (e) {
      print('Error uploading image: $e');
      if (e is FirebaseException) {
        print('Firebase error code: ${e.code}');
        print('Firebase error message: ${e.message}');
      }
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Deletes an image from Firebase Storage.
  ///
  /// Takes the image URL to be deleted.
  /// Throws an [Exception] if there's an error during the deletion process.
  @override
  Future<void> deleteImage(String imageUrl) async {
    try {
      final storageRef = _storage.refFromURL(imageUrl);
      await storageRef.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  /// Filters products by category.
  ///
  /// Returns a [List<ProductModel>] of products matching the given category.
  /// Throws an [Exception] if there's an error during the operation.
  @override
  Future<List<ProductModel>> filterProductsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection(DatabaseString.productCollectionName)
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Filters products by price range.
  ///
  /// Returns a [List<ProductModel>] of products within the given price range.
  /// Throws an [Exception] if there's an error during the operation.
  @override
  Future<List<ProductModel>> filterProductsByPriceRange(
      double min, double max) async {
    try {
      final snapshot = await _firestore
          .collection(DatabaseString.productCollectionName)
          .where('price', isGreaterThanOrEqualTo: min)
          .where('price', isLessThanOrEqualTo: max)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Filters products by category and price range.
  ///
  /// Returns a [Stream] of [List<ProductModel>] matching the given criteria.
  /// Throws a [ServerException] if there's an error during the operation.
  @override
  Stream<List<ProductModel>> filterProducts(
      String? category, double minPrice, double maxPrice) {
    print(
        'Filtering products - Category: $category, Price Range: \$$minPrice - \$$maxPrice');

    Query query = _firestore.collection(DatabaseString.productCollectionName);

    // Apply category filter if provided
    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
      print('Applied category filter: $category');
    }

    // Apply price range filter
    query = query
        .where('price', isGreaterThanOrEqualTo: minPrice)
        .where('price', isLessThanOrEqualTo: maxPrice);
    print('Applied price range filter: \$$minPrice - \$$maxPrice');

    return query.snapshots().map((querySnapshot) {
      print('Received snapshot with ${querySnapshot.docs.length} documents');
      final filteredProducts = querySnapshot.docs
          .map((doc) {
            try {
              return ProductModel.fromJson(doc.data() as Map<String, dynamic>);
            } catch (e) {
              print('Error parsing document ${doc.id}: $e');
              return null;
            }
          })
          .where((product) => product != null)
          .cast<ProductModel>()
          .toList();

      print('Filtered products count: ${filteredProducts.length}');
      return filteredProducts;
    }).handleError((e) {
      print('Error in filterProducts stream: $e');
      if (e is FirebaseException) {
        print('Firebase error code: ${e.code}');
        print('Firebase error message: ${e.message}');
      }
      // Instead of throwing an exception, return an empty list
      return <ProductModel>[];
    });
  }
}
