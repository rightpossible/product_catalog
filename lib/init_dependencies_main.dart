part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  //core
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  serviceLocator.registerLazySingleton(
    () => Hive.box(DatabaseString.productBox),
  );
  serviceLocator.registerLazySingleton<HiveInterface>(() => Hive);
  serviceLocator.registerLazySingleton<ConnectionChecker>(
      () => ConnectionCheckerImpl(internetConnection: serviceLocator()));

  //features
  _initProductDependencies();
}

void _initProductDependencies() {
  //datasource
  serviceLocator.registerLazySingleton<ProductLocalDataSource>(
      () => ProductLocalDataSourceImpl(box: serviceLocator()));

  //repository
  serviceLocator.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(serviceLocator(), serviceLocator()));

//usecase
  serviceLocator
      .registerFactory<AddProduct>(() => AddProduct(serviceLocator()));
  serviceLocator
      .registerFactory<GetAllProducts>(() => GetAllProducts(serviceLocator()));
  serviceLocator
      .registerFactory<FilterProducts>(() => FilterProducts(serviceLocator()));
  serviceLocator
      .registerFactory<UpdateProduct>(() => UpdateProduct(serviceLocator()));
  serviceLocator
      .registerFactory<DeleteProduct>(() => DeleteProduct(serviceLocator()));


      // bloc
}
