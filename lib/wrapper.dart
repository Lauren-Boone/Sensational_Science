import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/Screens/Login/authenticate.dart';
import 'package:sensational_science/Screens/Teacher/teachermain.dart';
import 'main.dart';
import 'Services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/user.dart';
import 'Screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User>(context);
    
    // print('testing');
    
    // if(user == null){
    //    print(user);
    //   return Authenticate();
    // }
    // else{
    //    print(user.uid);
    //   return Home();
    // }
    return Consumer<User>(builder: (context, user, child){
      if(user == null){
       print(user);
      return Authenticate();
    }
    else{
       print(user.uid);
      return Home();
    }
    },); 

  }
}