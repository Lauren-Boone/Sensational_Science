import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:provider/provider.dart';
// import 'package:sensational_science/Screens/Student/collectData.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sensational_science/Services/auth.dart';
import 'dart:io' show Platform;
import 'Screens/Login/sign_in.dart';
import 'Screens/home/home.dart';
import 'wrapper.dart';
import 'models/user.dart';
import 'dart:io' show Platform;

Future<String>loadApiKey() async{
  if(Platform.isAndroid){
    return await rootBundle.loadString('assets/androidkey.txt'); 
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

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<User>.value(
//       value: AuthService().user,
//           child: MaterialApp(
//         home: Wrapper(
          
//         ),
//       ),
//     );
//   }
// }

class CheckAuthorization extends StatefulWidget{
  @override 
  _CheckAuthorizationState createState() => new _CheckAuthorizationState(); 
}

class _CheckAuthorizationState extends State<CheckAuthorization>{
  bool loggedIn; 
  var currentUser; 
  @override 
  void initState(){
    loggedIn = false; 
    FirebaseAuth.instance.currentUser().then((user)=> user != null
      ? setState((){
        loggedIn = true; 
        currentUser = new User(uid: user.uid); 

      }): null); 
        
      super.initState(); 
  } 



  @override
  Widget build(BuildContext context){
    return loggedIn ? new Home() : new SignIn(); 
  }
    
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new CheckAuthorization(); 
  }
}

