import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../utils/environment.dart';

class Auth with ChangeNotifier {
  final _url = '${Environment.authUrl + Environment.apiKey}';

  Future<void> signup(String email, String password) async {
    final response = await post(
      Uri.parse(_url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    
  }
}
