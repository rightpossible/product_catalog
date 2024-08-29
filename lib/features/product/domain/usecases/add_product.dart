import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:product_catalog/core/errors/failures.dart';
import 'package:product_catalog/core/usecase/usecase.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/domain/repository/product_repository.dart';

class AddProduct extends UseCase<Product, AddProductParams> {
  final ProductRepository repository;

  AddProduct(this.repository);

  @override
  Future<Either<Failure, Product>> call(AddProductParams params) async {
    return await repository.addProduct(params.product, params.imageFile);
  }
}

class AddProductParams {
  final Product product;
  final File imageFile;

  AddProductParams({required this.product, required this.imageFile});
}
