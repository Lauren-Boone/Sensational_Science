import 'package:flutter/material.dart';


final appTheme = ThemeData(
  // This is the theme of your application.
  //
  // Try running your application with "flutter run". You'll see the
  // application has a blue toolbar. Then, without quitting the app, try
  // changing the primarySwatch below to Colors.green and then invoke
  // "hot reload" (press "r" in the console where you ran "flutter run",
  // or simply save your changes to "hot reload" in a Flutter IDE).
  // Notice that the counter didn't reset back to zero; the application
  // is not restarted.

  brightness: Brightness.light,
  //backgroundColor: Colors.grey[500],
  //  accentColor: Colors.lightBlueAccent,
 // accentColor: Colors.deepPurpleAccent,
 backgroundColor: Colors.grey[50],
  primarySwatch: Colors.indigo,
  scaffoldBackgroundColor: Colors.indigo[50],
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.indigo[600],
    shape: RoundedRectangleBorder(),
    textTheme: ButtonTextTheme.primary,
    hoverColor: Colors.blue[100],
    highlightColor: Colors.blueGrey,
    splashColor: Colors.purpleAccent,
  ),
  cardTheme: CardTheme(
    color: Colors.grey[400],
  ),
  iconTheme: IconThemeData(
    color: Colors.grey,
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Colors.blueAccent,
    elevation: 100,
  ),

  popupMenuTheme: PopupMenuThemeData(
    color: Colors.blue,
  ),

  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.blue[100],
    modalElevation: 100,
  ),
  

  // This makes the visual density adapt to the platform that you run
  // the app on. For desktop platforms, the controls will be smaller and
  // closer together (more dense) than on mobile platforms.

  highlightColor: Colors.deepPurpleAccent,
  // highlightColor: Colors.blueAccent,
);

final modalHelpTheme = ThemeData(
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.blue[100],
    modalElevation: 100,
  ),
  backgroundColor: Colors.blue[100],

  //this is for the normal text
);

const modalLabel = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  decoration: TextDecoration.none,
  fontFamily: 'montserrat',
);

const modalInfo = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.normal,
  color: Colors.black,
  decoration: TextDecoration.none,
  fontFamily: 'montserrat',
);

const classLabel = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.normal,
  color: Colors.white,
  decoration: TextDecoration.none,
  fontFamily: 'montserrat',
);
