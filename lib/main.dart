import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'utils/custom_route.dart';

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
import 'utils/app_colors.dart';
import 'utils/app_routes.dart';

Future<void> main() async {
  // if (Platform.isAndroid) {
  //   await dotenv.load(fileName: '.env', mergeWith: Platform.environment);
  // } else if (Platform.isIOS || Platform.isMacOS) {
  //   await dotenv.load(mergeWith: Platform.environment);
  // }

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
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (BuildContext context, auth, ProductList? previous) =>
              ProductList(
                  auth.token ?? '', auth.userId ?? '', previous?.items ?? []),
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (context, auth, previous) => OrderList(
              auth.token ?? '', auth.userId ?? '', previous?.items ?? []),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'SHOPMATE - Your Shop Online',
        // theme: theme.copyWith(
        //   colorScheme: theme.colorScheme.copyWith(
        //       primary: AppColors.primary, secondary: AppColors.secondary),
        //   textTheme: theme.textTheme.apply(fontFamily: 'Lato'),
        //   pageTransitionsTheme: theme.pageTransitionsTheme.builders.map((key, value) => null)
        //   // fontFamily: 'Lato',
        // ),
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: AppColors.primary, secondary: AppColors.secondary),
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
                builders: <TargetPlatform, PageTransitionsBuilder>{
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                })),
        // home: const ProductsOverviewPage(),
        routes: {
          AppRoutes.authOrHome: (context) => const AuthPage(),
          // AppRoutes.home: (context) => const ProductsOverviewPage(),
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
