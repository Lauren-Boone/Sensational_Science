import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/material.dart';

class FireStorageService extends ChangeNotifier {
  FireStorageService() {
    try {
      fb.initializeApp(
        apiKey: "AIzaSyC6-_dD-gwhS-uwIBiczczVlu11tGYRYuI",
        authDomain: "citizen-science-app.firebaseapp.com",
        databaseURL: "https://citizen-science-app.firebaseio.com",
        projectId: "citizen-science-app",
        storageBucket: "gs://citizen-science-app.appspot.com",
        messagingSenderId: "286001680675",
      );
    } on fb.FirebaseJsNotLoadedException catch (e) {
      print(e);
    }
  }

  static Future<dynamic> loadImage(BuildContext context, dynamic image) async {
    if(image.toString() == '') {
      return null;
    }
    var url = await fb.storage().ref(image).getDownloadURL();
    return url;
  }

  static Future<dynamic> deleteFile(BuildContext context, dynamic filePath) async {
    return await fb.storage().ref().child(filePath).delete();
  }
}