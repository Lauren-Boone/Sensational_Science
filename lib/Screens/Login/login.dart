import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class LoginAccount extends StatefulWidget {
  LoginAccount({Key key}) : super(key: key);

  @override
  LoginAccountState createState() {
    return LoginAccountState();
  }
}

class LoginAccountState extends State<LoginAccount> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController(); 

  findUser(idUser) async {
    var data = Firestore.instance.collection('Teachers').document(idUser).get();
    await data.then((user) {
      return user.exists;
    });
  }

  getUserData(String idUser) async {
    var data = Firestore.instance.collection('Teachers').document(idUser).get();
    return await data.then((pw) {
      if (!pw.exists) {
        return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Login to Account"),
        ),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(children: <Widget>[
                  //Text form fields and raised button
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    controller: emailController,
                    decoration: const InputDecoration(
                        hintText: 'Enter your email address'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter an email address.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    maxLines: 1,
                    controller: passwordController,
                    decoration:
                        const InputDecoration(hintText: 'Enter your password'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your password.';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('Processing Data')));
                          }
                        },
                        child: Text('Submit')),
                  )
                ]))));
  }
}
