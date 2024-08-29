part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}
//get products
class GetAllProductsEvent extends ProductEvent {}

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
  final Product product;

  DeleteProductEvent({required this.product});
}

//upload image
class UploadImageEvent extends ProductEvent {
  final String localImageUrl;

  UploadImageEvent({required this.localImageUrl});
}

class DeleteImageEvent extends ProductEvent {
  final String imageUrl;

  DeleteImageEvent({required this.imageUrl});
}

class ApplyFiltersEvent extends ProductEvent {
  final String? category;
  final double minPrice;
  final double maxPrice;

  ApplyFiltersEvent({this.category, required this.minPrice, required this.maxPrice});
}


