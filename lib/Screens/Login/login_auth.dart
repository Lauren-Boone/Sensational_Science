import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../Teacher/teachermain.dart';

final FirebaseAuth authorization = FirebaseAuth.instance;


class AuthorizationState {
  Future<FirebaseUser> createUserAccount(String email, String password) async {
    AuthResult response = await authorization.createUserWithEmailAndPassword(
        email: email, password: password);
    final FirebaseUser user = response.user;
    assert(user != null);
    assert(await user.getIdToken() != null);
    return user;
  }

  Future<FirebaseUser> Login(email, password) async {
    try {
      AuthResult response = await authorization.createUserWithEmailAndPassword(
          email: email, password: password);

      final FirebaseUser user = response.user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      final FirebaseUser currentUser = await authorization.currentUser();
      assert(user.uid == currentUser.uid);
      print("Success!");
      return user;
    } catch (ex) {
      print(ex.toString());
      return null;
    }
  }
}
