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
  String _email = '';
  String? _link;
  // final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String shareLink = '';

  ////// Initial Values //////
  ///// Action Code Settings /////
  ///   Resources - https://firebase.flutter.dev/docs/auth/usage ///
  ///   Resources - https://medium.com/@ayushsahu_52982/passwordless-login-with-firebase-flutter-f0819209677 ///
  ///// Action Code Settings /////

///////////////// Dynamic Links ////////////////
  // Future<String> createDynamicLinks() async {
  //   final DynamicLinkParameters parameters = DynamicLinkParameters(
  //       uriPrefix: 'https://firebasefeatureapp.page.link',
  //       link: Uri.parse('https://firebasefeatureapp.page.link/?email=hello'),
  //       androidParameters: AndroidParameters(
  //         packageName: 'com.example.firebase_features',
  //       ),
  //       dynamicLinkParametersOptions: DynamicLinkParametersOptions(
  //         shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
  //       ),
  //       iosParameters: IosParameters(
  //         bundleId: 'com.example.firebaseFeatures',
  //       ),
  //       socialMetaTagParameters:
  //           SocialMetaTagParameters(title: 'Email', description: _email));

  //   // Uri url;

  //   final Uri shortLink = await parameters.buildUrl();
  //   // url = shortLink.shortUrl;
  //   return shortLink.toString();
  // }

  ///////////////// Dynamic Links ////////////////
  sendLinkToEmail(String url) async {
    var actionCodeSettings = ActionCodeSettings(
      url: 'https://firebasefeatureapp.page.link/?email=hello',
      dynamicLinkDomain: 'firebasefeatureapp.page.link',
      androidPackageName: 'com.example.firebase_features',
      androidInstallApp: true,
      androidMinimumVersion: '12',
      iOSBundleId: 'com.example.firebaseFeatures',
      handleCodeInApp: true,
    );
    FirebaseAuth.instance
        .sendSignInLinkToEmail(
          email: _email,
          actionCodeSettings: actionCodeSettings,
        )
        .catchError(
            (onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      initDynamicLinks();
    }
  }

  // _retrieveDynamicLink() async {
  //   final PendingDynamicLinkData? data =
  //       await FirebaseDynamicLinks.instance.onLink();

  //   final Uri? deepLink = data?.link;
  //   print(data);
  //   print(deepLink.toString());
  //   _link = deepLink.toString();
  //   _signInWithEmailAndLink();

  //   return deepLink.toString();
  // }

  initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        _signInWithEmailAndLink(_email, deepLink.toString());
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      _signInWithEmailAndLink(_email, deepLink.toString());
    }
  }

  Future<void> _signInWithEmailAndLink(String email, String link) async {
    var auth = FirebaseAuth.instance;
// Retrieve the email from wherever you stored it
    var emailAuth = _email;
// Confirm the link is a sign-in with email link.
    if (auth.isSignInWithEmailLink(link)) {
      // The client SDK will parse the code from the link for you.
      auth.signInWithEmailLink(email: emailAuth, emailLink: link).then((value) {
        var userEmail = value.user;
        print('Successfully signed in with email link!');
      }).catchError((onError) {
        print('Error signing in with email link $onError');
      });
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
                  onPressed: () async {
                    _formKey.currentState!.save();
                    print(_email);
                    // String url = await createDynamicLinks();
                    sendLinkToEmail('');
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
