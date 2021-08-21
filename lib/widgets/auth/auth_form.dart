import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String username, String password,
      File? userImage, bool isLogin, BuildContext ctx) submitForm;
  final bool isLoading;

  AuthForm(this.submitForm, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  String email = "";
  String userName = "";
  String password = "";
  File? userImage;

  void _trySubmit() {
    final isValid = this._formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (this.userImage == null && !this.isLogin) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Please pick an image.")));
      return;
    }
    if (isValid) {
      this._formKey.currentState!.save();
      widget.submitForm(email.trim(), userName.trim(), password.trim(),
          this.userImage, isLogin, this.context);
    }
  }

  void pickedImage(File? imageFile) {
    this.userImage = imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!this.isLogin)
                      UserImagePicker(imagePickerFn: this.pickedImage),
                    TextFormField(
                      key: ValueKey("email"),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains("@")) {
                          return "Please enter valid email address";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        this.email = value ?? "";
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email address",
                      ),
                    ),
                    if (!this.isLogin)
                      TextFormField(
                        key: ValueKey("username"),
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 4) {
                            return "Please enter atlease 4 letters";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          this.userName = value ?? "";
                        },
                        decoration: InputDecoration(labelText: "Username"),
                      ),
                    TextFormField(
                      key: ValueKey("password"),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 7) {
                          return "Please enter atlease 7 letters";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        this.password = value ?? "";
                      },
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      RaisedButton(
                        onPressed: this._trySubmit,
                        child: Text(this.isLogin ? "Login" : "Signup"),
                      ),
                    if (!widget.isLoading)
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            this.isLogin = !this.isLogin;
                          });
                        },
                        child: Text(this.isLogin
                            ? "Create new account"
                            : "Already have an account"),
                        textColor: Theme.of(context).primaryColor,
                      ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
