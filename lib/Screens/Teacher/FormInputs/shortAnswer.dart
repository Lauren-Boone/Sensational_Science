import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ShortAnswerItem extends StatefulWidget {
  @override
  _ShortAnswerItemState createState() => _ShortAnswerItemState();
}

class _ShortAnswerItemState extends State<ShortAnswerItem> {
  final controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      decoration: new InputDecoration(
        labelText: "Short Answer",
        fillColor: Colors.white,
        enabledBorder: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}