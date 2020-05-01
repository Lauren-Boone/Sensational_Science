import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

class NumericalInputItem extends StatefulWidget {
  final TextEditingController controller;

  NumericalInputItem({this.controller});

  @override
  _NumericalInputItemState createState() => _NumericalInputItemState();
}

class _NumericalInputItemState extends State<NumericalInputItem> {

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
          labelText: " Numerical Input Question",
          fillColor: Colors.white,
        ),
      ),
    );
   
  }
}