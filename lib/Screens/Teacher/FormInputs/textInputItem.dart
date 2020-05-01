import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TextInputItem extends StatefulWidget {
  final TextEditingController controller;

  TextInputItem({this.controller});

  @override
  _TextInputItemState createState() => _TextInputItemState();
}

class _TextInputItemState extends State<TextInputItem> {

  @override
  Widget build(BuildContext context) {
    
     return Container(
       height: 2,
       margin: EdgeInsets.all(2),

       decoration: BoxDecoration(
        
        //color: Colors.blue[100],
    border: Border.all(color: Colors.black),
   //backgroundBlendMode: BlendMode.darken
  ),
            child: new TextFormField(
            
        controller: widget.controller,
        decoration: new InputDecoration(
          labelText: " Text Input Question",
          fillColor: Colors.white,

           
              
        ),
        ),
     );
    
  }
}