import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ShortAnswerItem extends StatefulWidget {
  final TextEditingController controller;

  ShortAnswerItem({this.controller});

  @override
  _ShortAnswerItemState createState() => _ShortAnswerItemState();
}

class _ShortAnswerItemState extends State<ShortAnswerItem> {

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
          labelText: " Short Answer Question",
          fillColor: Colors.white,
         /* enabledBorder: new OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),*/
        ),
      ),
    );
  }
}