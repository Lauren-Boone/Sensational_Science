import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sensational_science/main.dart';
import '../Teacher/teachermain.dart';
import 'login.dart';
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
  @override
  getUserState(){
    FirebaseAuth.instance
      .currentUser()
      .then((user) => {
        if(user == null){
          Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> LoginAccount())
              )
        }else{
          Firestore.instance
          .collection("Teachers")
          .document(user.uid)
          .get()
          .then((DocumentSnapshot result) => 
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder:(context) => TeacherHome(
                  
                )
              )
            )
          )
          .catchError((err)=> print(err))
        }
      });
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Sensational Science Projects'),
      ),
      backgroundColor: Colors.lightGreen,
      body:Center(
        child: Text('inspired by Citizen Science Projects'))
      );
  }

}

