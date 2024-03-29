import 'dart:math';

import 'package:flutter/material.dart';

import '../components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 0.5),
                  Color.fromRGBO(255, 188, 117, 0.9)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      // cascade operator
                      transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.deepOrange.shade900,
                          // ignore: prefer_const_literals_to_create_immutables
                          boxShadow: [
                            const BoxShadow(
                                blurRadius: 8,
                                color: Colors.black26,
                                offset: Offset(0, 2)),
                          ]),
                      child: Text(
                        'SHOPMATE',
                        style: TextStyle(
                            fontSize: 45,
                            fontFamily: 'Anton',
                            color:
                                // Theme.of(context).accentTextTheme.headline6?.color),
                                Theme.of(context).textTheme.headlineSmall?.color),
                      ),
                    ),
                    AuthForm()
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
