import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:io';
// import 'auth.dart';
import 'firebase_options.dart';
// import 'profile.dart';

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

  Future<void> userSignUp(String email, String password) async {
    try {
      final credential = await authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> emailVerification(String emailAddress) async {

  }

  Future<void> emailPasswordSignIn(String email, String password) async {
    try {
      final credential = await authInstance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<UserCredential> googleSignInUp() async {
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
      return await authInstance.signInWithCredential(credential);
    }
    else {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({
        'login_hint': 'user@example.com'
      });

      // Once signed in, return the UserCredential
      return await authInstance.signInWithPopup(googleProvider);
    }
  }

  Future<UserCredential> facebookSignInUp() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      dynamic accessToken = loginResult.accessToken?.token;

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken);

      // Once signed in, return the UserCredential
      return authInstance.signInWithCredential(facebookAuthCredential);
    }
    else {
      FacebookAuthProvider facebookProvider = FacebookAuthProvider();

      facebookProvider.addScope('email');
      facebookProvider.setCustomParameters({
        'display': 'popup',
      });

      // Once signed in, return the UserCredential
      return await authInstance.signInWithPopup(facebookProvider);
    }
  }

  Future<void> twitterSignInUp() async {
    TwitterAuthProvider twitterProvider = TwitterAuthProvider();

    if (kIsWeb) {
      await authInstance.signInWithPopup(twitterProvider);
    } else {
      await authInstance.signInWithProvider(twitterProvider);
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
