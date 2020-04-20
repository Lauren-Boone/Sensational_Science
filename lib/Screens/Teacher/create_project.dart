import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';

class CreateProject extends StatefulWidget {
  @override
  _CreateProjectState createState() => _CreateProjectState();
}

Future<Position> getUserLocation() async {
  try {
    Position currentUserPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return currentUserPosition;
  } catch (ex) {
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
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class DynamicWidget extends StatelessWidget {
  final controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.all(8.0),
      child: new TextField(
        controller: controller,
        decoration: new InputDecoration(hintText: 'Enter Answer'),
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
  String item2, item3, item4;
  String question = 'add question';
  String dropdownValue = 'One';
  List<DynamicWidget> add_items = [];
  addField() {
    add_items.add(new DynamicWidget());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: PopupMenuButton<String>(
        onSelected: (String value) {
          setState(() {
            _selection = value;
          });
        },
        child: ListTile(
          leading: new IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              addField();
              print(add_items);
              // itemCount: add_items.length,
              itemBuilder:
              (_, index) => add_items[index];
            },
          ),
          title: Text(question),
          subtitle: Column(
            children: <Widget>[
              new Flexible(
                child: new ListView.builder(
                    itemCount: add_items.length,
                    itemBuilder: (_, index) => add_items[index]),
              ),
            ],
          ),
          trailing: Icon(Icons.account_circle),
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'Value1',
            child: Text('Choose value 1'),
          ),
          const PopupMenuItem<String>(
            value: 'Value2',
            child: Text('Choose value 2'),
          ),
          const PopupMenuItem<String>(
            value: 'Value3',
            child: Text('Choose value 3'),
          ),
        ],
      ),
    );
  }
}

class TextInputItem extends StatelessWidget {
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
          title: Text("Create New Project"),
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
                        child: Text('Text Input Field'),
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
                        child: Text('User Location'),
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
                        child: Text('Add Multiple'),
                        data: new MultipleChoice(),
                        feedback: Text('Mult choice'),
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
