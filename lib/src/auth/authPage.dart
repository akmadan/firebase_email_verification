import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_features/src/auth/verify.dart';
import 'package:firebase_features/src/pages/home.dart';
import 'package:flutter/material.dart';
// import 'package:login_app/src/screens/home.dart';
// import 'package:login_app/src/screens/verify.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String? _email, _password;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Title
            Text(
              'Enter Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),

            // Email Text Field
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: 'Enter Email Address',
                  border: OutlineInputBorder()),
              onChanged: (value) {
                setState(() {
                  _email = value.trim(); //removes extra white spaces
                });
              },
            ),
            SizedBox(
              height: 20,
            ),

            // Password Text Field
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Enter Password', border: OutlineInputBorder()),
              onChanged: (value) {
                setState(() {
                  _password = value.trim();
                });
              },
            ),
            SizedBox(
              height: 20,
            ),

            // Sign In Button
            Container(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor)),
                  child: Text('Signin'),
                  onPressed: () {
                    auth
                        .signInWithEmailAndPassword(
                            email: _email!, password: _password!)
                        .then((_) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreen()));
                    });
                  }),
            ),
            SizedBox(
              height: 10,
            ),

            //Sign Up Button
            Container(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor)),
                // color: Theme.of(context).accentColor,
                child: Text('Signup'),
                onPressed: () {
                  auth
                      .createUserWithEmailAndPassword(
                          email: _email!, password: _password!)
                      .then((_) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => VerifyScreen()));
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
