import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TextInputItem extends StatefulWidget {
  final TextEditingController controller;

  TextInputItem({
    @required this.controller,
  }) : assert(controller != null);

  @override
  _TextInputItemState createState() => _TextInputItemState();
}

class _TextInputItemState extends State<TextInputItem> {

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(3.0),
      child: new Card(
        child: new Container(
          height: 70.0,
          margin: EdgeInsets.all(3.0),
          child: new Column(
            children: <Widget>[
              new Text('Text Input Prompt'),
              new TextField(
                controller: widget.controller,
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