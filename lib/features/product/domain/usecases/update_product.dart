
import 'package:fpdart/fpdart.dart';
import 'package:product_catalog/core/errors/failures.dart';
import 'package:product_catalog/core/usecase/usecase.dart';
import 'package:product_catalog/features/product/domain/entities/product.dart';
import 'package:product_catalog/features/product/domain/repository/product_repository.dart';

class UpdateProduct extends UseCase<void, UpdateProductParams> {
  final ProductRepository repository;
  UpdateProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateProductParams params) async {
    return await repository.updateProduct(params.product);
  }
}

class UpdateProductParams {
  final Product product;

  UpdateProductParams({required this.product});
}


