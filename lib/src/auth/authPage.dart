import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_features/src/auth/verify.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with WidgetsBindingObserver {
  ////// Initial Values //////
  String? _email;
  String? _link;
  // final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  ////// Initial Values //////
  ///// Action Code Settings /////
  ///   Resources - https://firebase.flutter.dev/docs/auth/usage ///
  ///   Resources - https://medium.com/@ayushsahu_52982/passwordless-login-with-firebase-flutter-f0819209677 ///
  ///// Action Code Settings /////

  var acs = ActionCodeSettings(
      //Link Created on Dynamic Link in Firebase
      url: 'https://firebasefeaturesapp.page.link/firebasefeature',
      // This must be true
      handleCodeInApp: true,
      iOSBundleId: 'com.example.firebaseFeatures',
      androidPackageName: 'com.example.firebase_features',
      // installIfNotAvailable
      androidInstallApp: true,
      // minimumVersion
      androidMinimumVersion: '12');

  sendLinkToEmail() async {
    FirebaseAuth.instance
        .sendSignInLinkToEmail(email: _email!, actionCodeSettings: acs)
        .catchError(
            (onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _retrieveDynamicLink();
    }
  }

  _retrieveDynamicLink() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    final Uri? deepLink = data?.link;
    print(deepLink.toString());
    _link = deepLink.toString();
    _signInWithEmailAndLink();

    return deepLink.toString();
  }

  Future<void> _signInWithEmailAndLink() async {
    final FirebaseAuth user = FirebaseAuth.instance;
    bool validLink = await user.isSignInWithEmailLink(_link!);
    if (validLink) {
      try {
        await user.signInWithEmailLink(email: _email!, emailLink: _link!);
      } catch (e) {
        print(e);
        // _showDialog(e.toString());
      }
    }
  }

  //🟢🟢 Adding an observer to the state 🟢🟢 //

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  //🟢🟢 Adding an observer to the state 🟢🟢 //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
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

              //Login Button
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor)),
                  // color: Theme.of(context).accentColor,
                  child: Text('Login'),
                  onPressed: () {
                    _formKey.currentState!.save();
                    sendLinkToEmail();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
