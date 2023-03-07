import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopmate/pages/auth_page.dart';
import 'package:shopmate/pages/products_overview_page.dart';

import '../models/auth.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return auth.isAuthenticated
        ? const ProductsOverviewPage()
        : const AuthPage();
  }
}
