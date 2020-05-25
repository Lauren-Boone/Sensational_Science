import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:provider/provider.dart';
// import 'package:sensational_science/Screens/Student/collectData.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sensational_science/Services/auth.dart';
import 'dart:io' show Platform;
import 'wrapper.dart';
import 'models/user.dart';
import 'package:firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' show Platform;

Future<String>loadApiKey() async{
  if(Platform.isAndroid){
    return await rootBundle.loadString('assets/keys.txt'); 
  }else if(Platform.isIOS){
    return await rootBundle.loadString('assets/keys.txt'); 
  }
}

void main() {
  
  runApp(MyApp());
  if(!kIsWeb){
    loadApiKey().then((value) => GoogleMap.init(value));
  }
  else 
    GoogleMap.init('AIzaSyA2zhLJzZCBXwj6dQ8KAExZcuZpE3HpWXU');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
          child: MaterialApp(
        home: Wrapper(
          
        ),
      ),
    );
  }
}

