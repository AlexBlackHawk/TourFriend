import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:io';

class ProgramUser {
  String name;
  String email;
  String photo;
  String userID;
  String providerID;
  ProgramUser({required this.name, required this.email, required this.photo, required this.userID, required this.providerID});
}

class AuthenticationBackend{
  final authInstance = FirebaseAuth.instance;
  User? user;
  AuthenticationBackend() {
    authInstance.authStateChanges().listen((User? authUser) {
      if (authUser != null) {
        user = authInstance.currentUser!;
      }
      else {
        user = null;
      }
    });
  }

  Future<void> getUserStatus() async {
  }

  Future<UserCredential> userSignUp(String email, String password) async {
    final credential = await authInstance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential;
  }

  Future<void> emailVerification(String emailAddress) async {

  }

  Future<User?> emailPasswordSignIn(String email, String password) async {
    UserCredential credential = await authInstance.signInWithEmailAndPassword(
        email: email,
        password: password
    );
    return credential.user;
  }

  Future<User?> googleSignInUp() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential uc = await authInstance.signInWithCredential(credential);
      return uc.user;
    }
    else {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({
        'login_hint': 'user@example.com'
      });

      // Once signed in, return the UserCredential
      UserCredential uc = await authInstance.signInWithPopup(googleProvider);
      return uc.user;
    }
  }

  Future<User?> facebookSignInUp() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      dynamic accessToken = loginResult.accessToken?.token;

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken);

      // Once signed in, return the UserCredential
      UserCredential uc = await authInstance.signInWithCredential(facebookAuthCredential);
      return uc.user;
    }
    else {
      FacebookAuthProvider facebookProvider = FacebookAuthProvider();

      facebookProvider.addScope('email');
      facebookProvider.setCustomParameters({
        'display': 'popup',
      });

      // Once signed in, return the UserCredential
      UserCredential uc = await authInstance.signInWithPopup(facebookProvider);
      return uc.user;
    }
  }

  Future<User?> twitterSignInUp() async {
    TwitterAuthProvider twitterProvider = TwitterAuthProvider();

    if (kIsWeb) {
      UserCredential uc = await authInstance.signInWithPopup(twitterProvider);
      return uc.user;
    } else {
      UserCredential uc = await authInstance.signInWithProvider(twitterProvider);
      return uc.user;
    }
  }

  Future<void> sendVerificationEmail() async {
    await user?.sendEmailVerification();
  }

  Future<void> updateUserName(String name) async {
    await user?.updateDisplayName(name);
  }

  Future<void> updatePhoto(String photoLink) async {
    await user?.updatePhotoURL(photoLink);
  }

  Future<void> updateUserEmail(String email) async {
    await user?.updateEmail(email);
  }

  Future<void> updateUserPassword(String password) async {
    await user?.updatePassword(password);
  }

  String? getUserName() {
    if (user != null) {
      return user!.providerData[0].displayName;
    }
    return null;
    // List<UserInfo>? x = user?.providerData;
  }

  String? getUserEmail() {
    if (user != null) {
      return user!.providerData[0].email;
    }
    return null;
  }

  String? getUserPhotoLink() {
    if (user != null) {
      return user!.providerData[0].photoURL;
    }
    return null;
  }

  String? getUserID() {
    if (user != null) {
      return user!.providerData[0].uid;
    }
    return null;
  }

  String? getUserProviderID() {
    if (user != null) {
      return user!.providerData[0].providerId;
    }
    return null;
  }

  ProgramUser makeUser() {
    return ProgramUser(name: getUserName()!, email: getUserEmail()!, photo: getUserPhotoLink()!, userID: getUserID()!, providerID: getUserProviderID()!);
  }

  Future<void> userSignOut() async {
    await authInstance.signOut();
  }

  Future<void> deleteUser() async {
    await user?.delete();
  }
}
