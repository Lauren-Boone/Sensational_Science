import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';

class FireStorageService extends ChangeNotifier {
  FireStorageService() {
    initializeApp(
      apiKey: "AIzaSyC6-_dD-gwhS-uwIBiczczVlu11tGYRYuI",
      authDomain: "citizen-science-app.firebaseapp.com",
      databaseURL: "https://citizen-science-app.firebaseio.com",
      projectId: "citizen-science-app",
      storageBucket: "citizen-science-app.appspot.com",
      messagingSenderId: "286001680675",
    );
  }

  static Future<dynamic> loadImage(BuildContext context, dynamic image) async {
    var url = await storage().ref(image).getDownloadURL();
    return url;
  }
}