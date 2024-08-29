import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalog/core/theme/theme.dart';
import 'package:product_catalog/features/product/presentation/bloc/product_bloc.dart';
import 'package:product_catalog/init_dependencies.dart';
import 'package:product_catalog/layout/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<ProductBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Product Catalog',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const SplashScreen(),
      ),
    );
  }
}
