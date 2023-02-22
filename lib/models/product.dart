import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/utils/environment.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    _toggleFavorite();

    final response = await http.patch(
      Uri.parse('${Environment.productBaseUrl}/$id.json'),
      body: jsonEncode({"isFavorite": isFavorite}),
    );

    if (response.statusCode >= 400) {
      _toggleFavorite();
      throw HttpException(
          msg: 'Não foi possivel salvar este produto como favorito',
          statusCode: response.statusCode);
    }
  }
}
