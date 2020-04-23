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
        margin: new EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            new TextField(
              //controller: controller,
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
              },
            ),
            new Text('$results')
          ],
        ));
  }
}