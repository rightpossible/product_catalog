part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  //core

  serviceLocator.registerFactory(() => InternetConnection());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final AppDatabase database = AppDatabase();
  await databaseFactory.setDatabasesPath(await getDatabasesPath());

  await DefaultCacheManager().emptyCache();

  serviceLocator.registerLazySingleton(() => database);

  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);
  serviceLocator.registerLazySingleton(() => FirebaseStorage.instance);

  serviceLocator.registerLazySingleton<ConnectionChecker>(
      () => ConnectionCheckerImpl(internetConnection: serviceLocator()));

  //features
  _initProductDependencies();

  /// addExampleProducts();
}

void _initProductDependencies() {
  //datasource
  serviceLocator
      .registerFactory<ProductLocalDataSource>(() => ProductLocalDataSourceImpl(
            database: serviceLocator(),
          ));
  serviceLocator.registerFactory<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(serviceLocator(), serviceLocator()));

  //repository
  serviceLocator.registerFactory<ProductRepository>(() => ProductRepositoryImpl(
      serviceLocator(), serviceLocator(), serviceLocator()));

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

  serviceLocator.registerFactory<ProductBloc>(
    () => ProductBloc(
      getAllProducts: serviceLocator(),
      addProduct: serviceLocator(),
      updateProduct: serviceLocator(),
      deleteProduct: serviceLocator(),
      filterProducts: serviceLocator(),
    ),
  );
}
