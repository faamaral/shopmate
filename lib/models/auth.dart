import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shopmate/exceptions/auth_exception.dart';

import '../utils/environment.dart';

class Auth with ChangeNotifier {
  // final _url = '${Environment.authUrl + Environment.apiKey}';
  String? _token;
  String? _email;
  String? _uId;
  DateTime? _expiryDate;

  bool get isAuthenticated {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuthenticated ? _token : null;
  }

  String? get email {
    return isAuthenticated ? _email : null;
  }

  String? get uId {
    return isAuthenticated ? _uId : null;
  }

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

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _uId = body['localId'];

      _expiryDate =
          DateTime.now().add(Duration(seconds: int.parse(body['expiresIn'])));
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
