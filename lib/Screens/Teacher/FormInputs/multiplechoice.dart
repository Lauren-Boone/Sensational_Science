import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


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
  String mult_question = '';
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

  final controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: <Widget>[
          new Flexible(
            child: new TextFormField(
              controller: controller,
              decoration: new InputDecoration(
                hintText: 'Enter Question Here',
              ),
              onChanged: (val) => setState(() => mult_question = val),
            ),
          ),
          new IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              addField();
            },
            tooltip: 'Add Answer',
          ),
          new Container(
            child: Text('Add answer'),
          ),
          new Flexible(
            child: new ListView.builder(
              itemCount: add_items.length,
              itemBuilder: (_, index) => add_items[index],
            ),
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