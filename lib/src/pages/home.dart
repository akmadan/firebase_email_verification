import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_features/src/auth/authPage.dart';
import 'package:flutter/material.dart';
// import 'package:login_app/src/screens/login.dart';

class HomeScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text(
            'Logout',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            auth.signOut();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AuthPage()));
          },
        ),
      ),
    );
  }
}
