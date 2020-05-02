import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

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

class UserLocation extends StatefulWidget {
  final TextEditingController controller;

  UserLocation({this.controller});

  @override
  UserLocationState createState() => UserLocationState();
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

class UserLocationState extends State<UserLocation> {
  var results;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        
        //color: Colors.blue[100],
    border: Border.all(color: Colors.black),
   //backgroundBlendMode: BlendMode.darken
  ),
      child: new TextFormField(
        controller: widget.controller,
        decoration: new InputDecoration(
          labelText: " Location Answer Question",
          fillColor: Colors.white,
        ),
      /*return new Container(
          margin: EdgeInsets.all(3.0),
          child: new Card(
            child: new Container(
              margin: EdgeInsets.all(3.0),
              child: Column(
                children: <Widget>[
                  new TextField(
                    controller: widget.controller,
                    decoration: new InputDecoration(
                      hintText: 'Location Description',
                    ),
                  ),
                  RaisedButton(
                    child: Text("Location"),
                    onPressed: () {
                      getUserLocation().then((result) {
                        setState(() {
                          results = result;
                        });
                      });
                      print("Success!");
                      print(results);
                    // if(results != null)
                    // new Text('$results');
                    },
                  ),
                  if(results != null)
                    new Text('$results'),
                ],
              ),
            ),
          ),*/
        ),
    );
  }
}