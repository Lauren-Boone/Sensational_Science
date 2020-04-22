import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';


class CreateProject extends StatefulWidget {
  @override

  _CreateProjectState createState() => _CreateProjectState();
}

Future<Position> getUserLocation()async{
  try{
    Position currentUserPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(currentUserPosition); 
     return currentUserPosition; 
  }catch(ex){
    Position currentUserPosition; 
    currentUserPosition = null;
    print('Error getting user location');  
    return currentUserPosition; 
  }
}

class UserLocation extends StatelessWidget {
  final locationController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.all(8.0),
      child: RaisedButton(
              child: Text("Location"),
                onPressed: () {
                 getUserLocation(); 
                  print("Success!"); 
                    },
                      ),        
      );
  }
}

class TextInputItem extends StatefulWidget {
  @override
  _TextInputItemState createState() => _TextInputItemState();
}

class _TextInputItemState extends State<TextInputItem>{
  final controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(3.0),
      child: new Card(
        child: new Container(
          margin: EdgeInsets.all(3.0),
          child: new Column(
            children: <Widget> [
              new Text('Text Input Prompt'),
              new TextField(
                controller: controller,
                decoration: new InputDecoration(
                  hintText: 'Text Input Prompt',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _CreateProjectState extends State<CreateProject> {

  @override
  Widget build(BuildContext context) {
    List<Widget> acceptData = [];

    return MaterialApp(
      home: Scaffold(
      appBar: AppBar (
        title: Text("Create New Project"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: DragTarget(
                onWillAccept: (Widget addItem) {
                  print('checking if will accept item');
                  print(addItem);
                  if (addItem == null) {
                    return false;
                  }
                  return true;
                },
                onAccept: (Widget addItem) {
                  print('accepting an item');
                  acceptData.add(addItem);
                },
                builder: (context, List<dynamic> candidateData, List<dynamic> rejectedData) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.lightBlue[50],
                    child: acceptData.isEmpty 
                      ? Center(child: Text('Add Form Fields Here'),) 
                      : Column(children: acceptData),
                  );
                },

              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child:  Column(
                children: <Widget> [
                  Container(
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width/3,
                    child: Draggable<Widget>(
                      child: Text('Text Input Field'),
                      data: new TextInputItem(),
                      feedback: Text('Text'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width/3,
                    child: Draggable<Widget>(
                      child: Text('User Location'),
                      data: new UserLocation(),
                      feedback: Text('Text'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}