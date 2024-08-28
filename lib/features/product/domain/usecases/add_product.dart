import 'package:fpdart/fpdart.dart';
import 'package:product_catalog/core/errors/failures.dart';
import 'package:product_catalog/core/usecase/usecase.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/domain/repository/product_repository.dart';

class AddProduct extends UseCase<void, AddProductParams> {
  final ProductRepository repository;

  AddProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(AddProductParams params) async {
    return await repository.addProduct(params.product);
  }
}

class AddProductParams {
  final Product product;

  AddProductParams({required this.product});
}
