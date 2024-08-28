import 'package:fpdart/fpdart.dart';
import 'package:product_catalog/core/errors/failures.dart';
import 'package:product_catalog/core/usecase/usecase.dart';
import 'package:product_catalog/features/product/domain/repository/product_repository.dart';

class DeleteProduct extends UseCase<void, DeleteProductParams> {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteProductParams params) async {
    return await repository.deleteProduct(params.id);
  }
}

class DeleteProductParams {
  final String id;

  DeleteProductParams({required this.id});
}