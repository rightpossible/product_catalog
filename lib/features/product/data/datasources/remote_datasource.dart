import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:product_catalog/core/errors/exception.dart';
import 'package:product_catalog/features/product/data/models/product_model.dart';
import 'package:product_catalog/core/constant/database_string.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

abstract class ProductRemoteDataSource {
  Stream<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(String id);
  Future<ProductModel> addProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
  Future<String> uploadImage(String localImageUrl);
  Future<void> deleteImage(String imageUrl);
  Future<List<ProductModel>> filterProductsByCategory(String category);
  Future<List<ProductModel>> filterProductsByPriceRange(double min, double max);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProductRemoteDataSourceImpl(this._firestore, this._storage);

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

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    try {
      print('Attempting to add product: ${product.toJson()}');
      final docRef = await _firestore
          .collection(DatabaseString.productCollectionName)
          .add(product.toJson());

      print('Product added successfully. Document reference: ${docRef.id}');

      // product.id = docRef.id;
      print('Returning product: ${product.toJson()}');
      return product;
    } catch (e) {
      print('Error adding product: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await _firestore
          .collection(DatabaseString.productCollectionName)
          .doc(id)
          .delete();
    } catch (e) {
      throw Exception(e);
    }
  }

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

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      await _firestore
          .collection(DatabaseString.productCollectionName)
          .doc(product.id)
          .update(product.toJson());
      return product;
    } catch (e) {
      throw Exception(e);
    }
  }

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

  @override
  Future<void> deleteImage(String imageUrl) async {
    try {
      final storageRef = _storage.refFromURL(imageUrl);
      await storageRef.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

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
}
