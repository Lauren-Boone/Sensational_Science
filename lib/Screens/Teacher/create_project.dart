import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';

class CreateProject extends StatefulWidget {
  final String title;
  final bool pub;
  CreateProject({this.title, this.pub});
  @override
  _CreateProjectState createState() => _CreateProjectState();
}

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

class DynamicWidget extends StatefulWidget {
  @override
  _DynamicWidgetState createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
  List<String> items = [];
  String item = '';
  //var results;
  final controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          new TextField(
          controller: controller,
          decoration: new InputDecoration(hintText: 'Enter Answer'),
          //onChanged: (val) => setState(() => item = val),
     
        ),
        //new Text('$results')
        ],
              
        
      ),
      
    );
  }
}

class MultipleChoice extends StatefulWidget {
  @override
  _MultipleChoiceState createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice> {
  List<String> items = [];
  String _selection = '';
  String item1;
  String result;
  String item2, item3, item4;
  String question = 'add question';
  String dropdownValue = 'One';
  List<DynamicWidget> add_items = [];
  addField() {
    add_items.add(new DynamicWidget());
    setState(() {
      //results=result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              itemCount: add_items.length,
              itemBuilder: (_, index) => add_items[index],
            ),
          ),
          new IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              addField();
            },
          ),
          new Flexible(
            child: Text('Add answer'),
          ),
        ],
      ),
      /*
        child: ListTile(
          leading: new IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              addField();
            },
          ),
        ),
          title: Text(question),
          //Remove from subtitle
          subtitle: Column(
            children: <Widget>[
              new Flexible(
                child: new ListView.builder(
                  itemCount: add_items.length,
                  itemBuilder: (_, index) => add_items[index],
                ),
              ),
            ],
          ),
          trailing: Icon(Icons.account_circle),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: addStudent,
          child: new Icon(Icons.add),
        ),
        */
    );
  }
}
class TextInputItem extends StatefulWidget {
  @override
  _TextInputItemState createState() => _TextInputItemState();
}

class _TextInputItemState extends State<TextInputItem> {
   final controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.all(8.0),
      child: new TextField(
        controller: controller,
        decoration: new InputDecoration(
          hintText: 'Text Input Prompt',
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
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            child: Column(
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
                      print(acceptData);
                    },
                    builder: (context, List<dynamic> candidateData,
                        List<dynamic> rejectedData) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        color: Colors.lightBlue[50],
                        child: acceptData.isEmpty
                            ? Center(
                                child: Text('Add Form Fields Here'),
                              )
                            : Column(children: acceptData),
                      );
                    },
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Draggable<Widget>(
                        child: ListTile(
                          title: Text('Add Text Response'),
                          trailing: Icon(Icons.text_fields),
                        ),
                        data: new TextInputItem(),
                        feedback: Text('Text'),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Draggable<Widget>(
                        child: ListTile(
                          title: Text('Add User Location'),
                          trailing: Icon(Icons.location_on),
                        ),
                        //child: Text('User Location'),
                        data: new UserLocation(),
                        feedback: Text('Text'),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Draggable<Widget>(
                        data: new MultipleChoice(),
                        feedback: Text('Mult choice'),
                        child: ListTile(
                          title: Text('Add Multiple choice'),
                          trailing: Icon(Icons.add_box),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
