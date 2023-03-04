import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shopmate/utils/app_colors.dart';

import 'models/auth.dart';
import 'models/cart.dart';
import 'models/order_list.dart';
import 'models/product_list.dart';
import 'pages/auth_page.dart';
import 'pages/cart_page.dart';
import 'pages/orders_page.dart';
import 'pages/product_detail_page.dart';
import 'pages/product_form_page.dart';
import 'pages/products_overview_page.dart';
import 'pages/products_page.dart';
import 'utils/app_routes.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
      ],
      child: MaterialApp(
        title: 'SHOPMATE - Your Shop Online',
        theme: theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(primary: AppColors.primary, secondary: AppColors.secondary),
          textTheme: theme.textTheme.apply(fontFamily: 'Lato'),
          // fontFamily: 'Lato',
        ),
        // home: const ProductsOverviewPage(),
        routes: {
          AppRoutes.auth: (context) => const AuthPage(),
          AppRoutes.home: (context) => const ProductsOverviewPage(),
          AppRoutes.productDetail: (context) => const ProductDetailPage(),
          AppRoutes.cart: (context) => const CartPage(),
          AppRoutes.orders: (context) => const OrdersPage(),
          AppRoutes.products: (context) => const ProductsPage(),
          AppRoutes.productForm: (context) => const ProductFormPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
