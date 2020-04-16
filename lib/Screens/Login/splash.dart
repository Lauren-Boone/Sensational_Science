import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sensational_science/main.dart';
import 'dart:async';

final FirebaseAuth authenticate = FirebaseAuth.instance; 

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  SplashScreenState createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
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
        backgroundColor: Colors.lightBlue[100], 
        body: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(children: <Widget>[
                  //Text form fields and raised button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Sensational Science Projects App', 
                      textAlign: TextAlign.center, 
                      style: TextStyle(fontWeight: FontWeight.bold),

                    )
                  )
                ]))));
  }
}
