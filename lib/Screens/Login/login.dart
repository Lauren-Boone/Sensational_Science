import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginAccount extends StatefulWidget {
  LoginAccount({Key key}) : super(key: key);

  @override
  LoginAccountState createState() {
    return LoginAccountState();
  }
}

class LoginAccountState extends State<LoginAccount> {
  final _formKey = GlobalKey<FormState>();
  final loginController = TextEditingController();

  findUser(idUser) async {
    var data = Firestore.instance.collection('users').document(idUser).get();
    await data.then((user) {
      return user.exists;
    });
  }

  getUserData(String idUser) async {
    var data = Firestore.instance.collection('users').document(idUser).get();
    return await data.then((doc) {
      if (!doc.exists) {
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
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Processing Data')));
                        }
                      },
                      child: Text('Submit'))
                ]))));
  }
}
