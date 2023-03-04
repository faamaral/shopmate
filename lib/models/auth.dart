import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shopmate/exceptions/auth_exception.dart';

import '../utils/environment.dart';

class Auth with ChangeNotifier {
  // final _url = '${Environment.authUrl + Environment.apiKey}';

  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=${Environment.apiKey}';
    final response = await post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) throw AuthException(body['error']['message']);
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
