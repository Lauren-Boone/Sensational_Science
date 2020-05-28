import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sensational_science/Screens/Student/student_view_class_data.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/userlocation.dart';
import 'package:sensational_science/Services/projectDB.dart';
import '../../models/project.dart';
import '../../Services/getproject.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Map<MarkerId, Marker> marker = <MarkerId, Marker>{};

// void add(lat, lon){
//   final String markerIdValue = "1";
//   final MarkerId markerId = MarkerId(markerIdValue);
//   final Marker marker = Marker(
//     markerId: markerId,
//     position: LatLng(43.65, -70.25)
//     );
// }
class LocationMap extends StatefulWidget {
  final TextEditingController controller;
  final locationInfo lms;
  // final List<String> locations;

  LocationMap({this.controller, this.lms});

  @override
  LocationMapState createState() => LocationMapState();
}

class LocationMapState extends State<LocationMap> {
  var results;
  final List<Marker> markers = [];
  void add(lat, lon) {
    final String markerIdValue = "1";

    setState(() {
      markers.clear();
      final Marker marker = Marker(GeoCoord(lat, lon));
      markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(locationInfo);
    //print("in location" + widget.lms.toString());
    RegExp exp = new RegExp(r"^Lat: (.*), Long: (.*)");
    var lms_actual = widget.lms.toString();
    var lms_test = widget.lms.latlonInfo;
    print("LMS TEST: " + lms_test);
    var check = true;
    double lat, lon;
    print(lms_actual);
    if (lms_test != "" && lms_test != "null") {
      Iterable<RegExpMatch> matches = exp.allMatches(lms_test);

      lat = double.parse(matches.toList()[0].group(1));
      lon = double.parse(matches.toList()[0].group(2));
    } else {
      //print("No valid location info available. Location Info set to (0.0, 0.0)");
      lat = 0.0;
      lon = 0.0;
      check = false;
    }

    add(lat, lon);

    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    final heightSize = MediaQuery.of(context).size.height / 3 - 10;
    final widthSize = MediaQuery.of(context).size.width / 2;
    return Material(
        child: new AspectRatio(
      aspectRatio: 100 / 100,
      child: new Container(
        child: Column(
          children: <Widget>[
            if (check)
              new Container(
                margin: EdgeInsets.only(top: 10),
                height: heightSize,
                width: widthSize,
                child: GoogleMap(
                    mapType: MapType.hybrid,
                    initialPosition: GeoCoord(lat, lon),
                    markers: Set.from(markers)),
              )
            else if (!check)
              Text(
                  "No valid location entered. Location Info temporarily set to (0.0, 0.0)")
            else
              Expanded(child: Text('Location')),
          ],
        ),
      ),
    ));
  }
}

class locationInfo {
  String latlonInfo;

  locationInfo({this.latlonInfo});
}
