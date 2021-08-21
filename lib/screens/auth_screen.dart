import 'dart:io';

import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void _submitAuthForm(String email, String username, String password,
      File? userImage, bool isLogin, BuildContext ctx) async {
    final authResult;
    try {
      setState(() {
        this.isLoading = true;
      });
      if (isLogin) {
        authResult = await this
            ._auth
            .signInWithEmailAndPassword(email: email, password: password);
      } else {
        authResult = await this
            ._auth
            .createUserWithEmailAndPassword(email: email, password: password);
        final profileImg = FirebaseStorage.instance
            .ref()
            .child("user_images")
            .child(authResult.user.uid + ".jpg");
        profileImg.putFile(userImage!).whenComplete(() async {
          final downloadableUrl = await profileImg.getDownloadURL();
          FirebaseFirestore.instance
              .collection("users")
              .doc(authResult.user.uid)
              .set({
            "email": email,
            "userName": username,
            "profileImage": downloadableUrl
          });
        });
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        this.isLoading = false;
      });
      print("$error -----");
      var message = "An error occurred! Please check your credentials";
      if (error.message != null) {
        message = error.message!;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (error) {
      setState(() {
        this.isLoading = false;
      });
      print("---- $error");
      // var message = "An error occurred! Please check your credentials";
      // if (error.message != null) {
      //   message = error.message!;
      // }
      // Scaffold.of(ctx).showSnackBar(SnackBar(
      //   content: Text(message),
      //   backgroundColor: Theme.of(context).errorColor,
      // ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(this._submitAuthForm, this.isLoading),
    );
  }
}
