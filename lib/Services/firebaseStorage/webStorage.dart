import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';

class FireStorageService extends ChangeNotifier {
  FireStorageService() {
    initializeApp(
      apiKey: "AIzaSyC6-_dD-gwhS-uwIBiczczVlu11tGYRYuI",
      authDomain: "citizen-science-app.firebaseapp.com",
      databaseURL: "https://citizen-science-app.firebaseio.com",
      projectId: "citizen-science-app",
      storageBucket: "gs://citizen-science-app.appspot.com",
      messagingSenderId: "286001680675",
    );
  }

  static Future<dynamic> loadImage(BuildContext context, dynamic image) async {
    print("I made it to the load image in webStorage");
    StorageReference storedImg = storage().ref(image);
    //var fullPath = 'gs://citizen-science-app.appspot.com/' + image.toString();
    print(storedImg.toString());
    var url = await storedImg.getDownloadURL();
    //var url = await storage().ref(fullPath).getDownloadURL();
    print("I got the url and am returning it");
    return url;
    //return fullPath;
  }
}