import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2.0),
  ),
);

ThemeData themedata(){
  final baseTheme = ThemeData(fontFamily: "Sunflower",);
      return baseTheme.copyWith(
        brightness: Brightness.light,
        //  accentColor: Colors.lightBlueAccent,
        accentColor: Colors.deepPurpleAccent,
        primaryColor: Colors.deepPurple,
        buttonTheme: ButtonThemeData(
           buttonColor: Colors.indigo[600],
           shape: RoundedRectangleBorder(),
           textTheme: ButtonTextTheme.primary,
           hoverColor: Colors.blue[100],
           highlightColor: Colors.blueGrey,
          splashColor: Colors.purpleAccent,
          
          
          
        ),
        cardTheme: CardTheme(
          color: Colors.green[100],
          
        ),
        iconTheme: IconThemeData(
          color: Colors.grey,
          
          
        ),
        
        
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        
        highlightColor: Colors.deepPurpleAccent,
        );

        // highlightColor: Colors.blueAccent,
}