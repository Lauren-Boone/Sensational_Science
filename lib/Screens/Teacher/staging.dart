import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sensational_science/Screens/Login/login_auth.dart';
import 'dart:async';

class StagingPage extends StatefulWidget{
  @override
  StagePageState createState(){
    return StagePageState(); 
  }
}

class StagePageState extends State<StagingPage> {
  final _formKey = GlobalKey<FormState>(); 
  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[

        ],)
    );
  }

}