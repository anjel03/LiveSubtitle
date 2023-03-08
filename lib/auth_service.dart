import 'package:car_login/login_page.dart';
import 'package:car_login/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
class AuthService{
  handleAuthState() {
    return StreamBuilder(builder: (BuildContext context, snapshot) {
      if (snapshot.hasData) {
        return SignUpPage();
      }
      else {
        return const LoginPage();
      }
    });
  }
    signInWithGoogle() async {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
          scopes: <String>["email"]).signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth!.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    signOut(){
    FirebaseAuth.instance.signOut();

  }
}