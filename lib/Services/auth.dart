import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sensational_science/Services/database.dart';
import '../models/user.dart';
import 'database.dart';


class AuthService {

final FirebaseAuth _auth = FirebaseAuth.instance;
//Create user obj based on Firebase user
User _userFromFireBaseUser(FirebaseUser user){
  return user != null ? User(uid: user.uid) : null;

}

//auth change user stream
Stream<User> get user{
  return _auth.onAuthStateChanged
    .map(_userFromFireBaseUser);
}

//Sign in 
  Future signIn(String email, String password) async{
    try{  
  AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
  FirebaseUser user = result.user;
  print("auth: " + user.toString()); 
  return _userFromFireBaseUser(user);
}catch(e){
print(e.toString());
return null;
}

}

Future register(String email, String password, String name) async{
  try{
    AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user =result.user;
    await DatabaseService(uid: user.uid).updateUserData(name, email);

    return _userFromFireBaseUser(user);
  }catch(e){
    print(e.toString());
    return null;

  }

}

//Sign out
Future signOut() async{
  try{
    return await _auth.signOut();
  }catch(e)
  {
    print(e.toString());
    return null;
  }
}

//Register Email and password
}