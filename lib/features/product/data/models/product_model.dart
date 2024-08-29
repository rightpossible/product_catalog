import 'package:hive/hive.dart';
import 'package:product_catalog/core/constant/database_string.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel extends HiveObject implements Product {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final String description;

  @HiveField(3)
  @override
  final double price;

  @HiveField(4)
  @override
  final String category;

  @HiveField(5)
  @override
  final String imageUrl;

  @HiveField(6)
  @override
  final String? localImageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.localImageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json[DatabaseString.id],
      name: json[DatabaseString.name],
      description: json[DatabaseString.description],
      price: json[DatabaseString.price],
      category: json[DatabaseString.category],
      imageUrl: json[DatabaseString.imageUrl],
      localImageUrl: json[DatabaseString.localImageUrl],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      DatabaseString.id: id,
      DatabaseString.name: name,
      DatabaseString.description: description,
      DatabaseString.price: price,
      DatabaseString.category: category,
      DatabaseString.imageUrl: imageUrl,
      DatabaseString.localImageUrl: localImageUrl,
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      category: category,
      imageUrl: imageUrl,
      localImageUrl: localImageUrl,
    );
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      category: product.category,
      imageUrl: product.imageUrl,
      localImageUrl: product.localImageUrl,
    );
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, description: $description, price: $price, category: $category, imageUrl: $imageUrl, localImageUrl: $localImageUrl)';
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    String? imageUrl,
    String? localImageUrl,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      localImageUrl: localImageUrl ?? this.localImageUrl,
    );
  }
}
