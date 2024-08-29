
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:product_catalog/core/database/tables.dart';
import 'package:product_catalog/core/network/connection_checker.dart';
import 'package:product_catalog/features/product/data/datasources/local_datasource.dart';
import 'package:product_catalog/features/product/data/datasources/remote_datasource.dart';
import 'package:product_catalog/features/product/data/repository/product_repository_impl.dart';
import 'package:product_catalog/features/product/domain/repository/product_repository.dart';
import 'package:product_catalog/features/product/domain/usecases/add_product.dart';
import 'package:product_catalog/features/product/domain/usecases/delete_product.dart';
import 'package:product_catalog/features/product/domain/usecases/filter_products.dart';
import 'package:product_catalog/features/product/domain/usecases/get_products.dart';
import 'package:product_catalog/features/product/domain/usecases/update_product.dart';
import 'package:product_catalog/features/product/presentation/bloc/product_bloc.dart';
import 'package:product_catalog/firebase_options.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

part 'init_dependencies_main.dart';
