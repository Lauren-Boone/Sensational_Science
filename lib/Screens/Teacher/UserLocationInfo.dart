import "package:sensational_science/locationhelper_nonweb.dart" if (dart.library.html) "package:js/js.dart"; 
// import 'package:js/js.dart'; 
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sensational_science/Screens/Student/student_collect_data.dart';
import 'package:sensational_science/Services/storeLocally.dart';
import "package:sensational_science/locationhelper_nonweb.dart" if (dart.library.html) 'package:sensational_science/locationhelper.dart';
// import 'package:sensational_science/Screens/Teacher/FormInputs/userlocation.dart';
import '../../Services/getproject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

// Future<Position> getUserLocation() async {
//   try {
//     Position currentUserPosition = await Geolocator()
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     print(currentUserPosition);
//     return currentUserPosition;
//   } catch (ex) {
//     Position currentUserPosition;
//     currentUserPosition = null;
//     print('Error getting user location');
//     return currentUserPosition;
//   }
// }

class UserLocationInfo extends StatefulWidget {
  final Questions question;
  final TextEditingController userLocationController;
  final int questionNum;
  final String code;
  UserLocationInfo(
      {this.question,
      this.userLocationController,
      this.questionNum,
      this.code});
  Position currentUserPosition;
  // Function(int, dynamic) locationCallback;
  // UserLocationInfo({this.question, this.userLocationController, this.locationCallback});
  @override
  _UserLocationInfoState createState() => _UserLocationInfoState();

  Future<Position> getUserLocation() async {
    try {
      Position currentUserPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print(currentUserPosition);
      return currentUserPosition;
    } catch (ex) {
      Position currentUserPosition;
      currentUserPosition = null;
      print('Error getting user location');
      return currentUserPosition;
    }
  }
}

class _UserLocationInfoState extends State<UserLocationInfo> {
  var results;
  double latitude  = 0.0; 
  double longitude = 0.0; 
  //     getUserLocation(){
  //   final Geolocator test = Geolocator()..forceAndroidLocationManager;
  //   test
  //   .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //   .then((Position position){
  //     print(position.toString());
  //     widget.locationCallback(0, position.toString());
  //     setState((){
  //       widget.currentUserPosition = position;
  //     });
  //   }).catchError((ex){
  //     print(ex);
  //   });
  // }

  @override
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Location"),
              onPressed: () {
                controller:
                widget.userLocationController;
                var questionObservations = Observation.of(context);
                if (!kIsWeb) {
                  widget.getUserLocation().then((result) async {
                    setState(() {
                      results = result;
                    });
                    widget.userLocationController.text = result.toString();
                    // questionObservations.addAnswer(widget.questionNum, result.toString());

                    await writeString(
                        widget.code,
                        widget.userLocationController.text,
                        widget.questionNum.toString());
                    if (widget.userLocationController.text == "")
                      Text(
                          "Invalid or no user location entered. User Location will be set to (0.0, 0.0) ");
                    print('Inner Success');
                  });
                  print("Success!");
                }else if(kIsWeb){
                  getCurrentPosition(allowInterop((pos) {
                    setState((){
                      results = "Lat: "; 
                      results += pos.coords.latitude.toString(); 
                      results += ", Long: "; 
                      results += pos.coords.longitude.toString();    
                    });
                    widget.userLocationController.text = results.toString(); 

                     writeString(
                        widget.code,
                        widget.userLocationController.text,
                        widget.questionNum.toString());
                    if (widget.userLocationController.text == "" || results == null)
                      Text(
                          "Invalid or no user location entered. Please use mobile phone to collect location data.");
                          
                    print('Inner Web Success');
                  }));

                  // getCurrentPosition(allowInterop((pos){
                    // getCurrentPosition.success(pos){
                    //   try{
                    //     print(pos.coords.latitude); 
                    //     print(pos.coords.longitude); 
                    //   }catch(ex){
                    //       print("Error getting location"); 
                    //   }
                    // }
                    // setState(){
                    //   results = pos.coords.latitude; 
                    //   results += pos.coords.longitude;    
                    // }
                    // widget.userLocationController.text = results.toString(); 

                    //  writeString(
                    //     widget.code,
                    //     widget.userLocationController.text,
                    //     widget.questionNum.toString());
                    // if (widget.userLocationController.text == "" || results == null)
                    //   Text(
                    //       "Invalid or no user location entered. Please use mobile phone to collect location data.");
                          
                    // print('Inner Web Success');
                  // })); 
                  if (widget.userLocationController.text == "" || results == null)
                      new Text(
                          "Invalid or no user location entered. Please use mobile phone to collect location data.");
                          
                  // print(results); 
                  print('Web Success');
                  // print(latitude); 
                }
                // widget.getUserLocation().then((result) async {
                //   setState(() {
                //     results = result;
                //   });
                //   widget.userLocationController.text = result.toString();
                //   // questionObservations.addAnswer(widget.questionNum, result.toString());

                //   await writeString(widget.code, widget.userLocationController.text, widget.questionNum.toString());
                //   if(widget.userLocationController.text == "")
                //     Text("Invalid or no user location entered. User Location will be set to (0.0, 0.0) ");
                //   print('Inner Success');
                // });
                // print("Success!");
              },
            ),
            if (results != null) new Text('$results'),
            
          ],
        ));
  }
}
