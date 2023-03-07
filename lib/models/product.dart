import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../exceptions/http_exception.dart';
import '../utils/environment.dart';

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

  Future<void> toggleFavorite(String token, String userId) async {
    _toggleFavorite();

    final response = await http.put(
      Uri.parse('${Environment.userFavorites}/$userId/$id.json?auth=$token'),
      body: jsonEncode(isFavorite),
    );

    if (response.statusCode >= 400) {
      _toggleFavorite();
      throw HttpException(
          msg: 'Não foi possivel salvar este produto como favorito',
          statusCode: response.statusCode);
    }
  }
}
