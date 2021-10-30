# firebase_features 

## Firebase Email-Password Link Verification

The repository contains the Flutter code of how to verify a user using Email Verification Link. 

### Connect your Flutter App with Firebase
### Initialize the Email/Pass Authentication Method in Authentication Section of Firebase Dashboard

### Add the Following Packages in pubspec.yaml dependencies
1. firebase_core:
2. firebase_auth:

### Design a Simple Auth Form for User.
Check lib/src/auth/authPage.dart

### If the user clicks on SignUp then direct the user to verify.dart
In this page, a verification link will be sent to entered email in the initState only and using Timer(), the state of app will listen to the verification running in the background. As soon as the user clicks on the link sent on email , the app state will be updated and user will be directed to home.dart




