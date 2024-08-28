import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:product_catalog/core/constant/database_string.dart';
import 'package:product_catalog/core/network/connection_checker.dart';
import 'package:product_catalog/features/product/data/datasources/local_datasource.dart';
import 'package:product_catalog/features/product/data/repository/product_repository_impl.dart';
import 'package:product_catalog/features/product/domain/repository/product_repository.dart';
import 'package:hive/hive.dart';
import 'package:product_catalog/features/product/domain/usecases/add_product.dart';
import 'package:product_catalog/features/product/domain/usecases/delete_product.dart';
import 'package:product_catalog/features/product/domain/usecases/filter_products.dart';
import 'package:product_catalog/features/product/domain/usecases/get_products.dart';
import 'package:product_catalog/features/product/domain/usecases/update_product.dart';

part  'init_dependencies_main.dart';