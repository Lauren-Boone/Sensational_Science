import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class TextInputItem extends StatefulWidget {
  @override
  _TextInputItemState createState() => _TextInputItemState();
}

class _TextInputItemState extends State<TextInputItem> {
  final controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(3.0),
      child: new Card(
        child: new Container(
          margin: EdgeInsets.all(3.0),
          child: new Column(
            children: <Widget>[
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