part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}
//get products
class GetAllProductsEvent extends ProductEvent {}

//filter products
class FilterProductsEvent extends ProductEvent {
  final String category;
  final double min;
  final double max;

  FilterProductsEvent({required this.category, required this.min, required this.max});
}

//add product
class AddProductEvent extends ProductEvent {
  final Product product;
final  File imageFile;
  AddProductEvent({required this.product, required this.imageFile});
}

//update product
class UpdateProductEvent extends ProductEvent {
  final Product product;

  UpdateProductEvent({required this.product});
}

//delete product  
class DeleteProductEvent extends ProductEvent {
  final String productId;

  DeleteProductEvent({required this.productId});
}

//upload image
class UploadImageEvent extends ProductEvent {
  final String localImageUrl;

  UploadImageEvent({required this.localImageUrl});
}


