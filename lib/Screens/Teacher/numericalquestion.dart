import 'package:flutter/material.dart';
import '../../Services/getproject.dart';
import 'package:flutter/services.dart';

class NumericalQuestion extends StatefulWidget {
  final Questions question;
  final TextEditingController numAnswerController; 
  NumericalQuestion({this.question, this.numAnswerController});
  @override
  _NumericalQuestionState createState() => _NumericalQuestionState();
}

class _NumericalQuestionState extends State<NumericalQuestion> {
    final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
      key: _formKey, 
        child: Padding(
          padding: EdgeInsets.all(10.0),
        child: new TextFormField(
      controller: widget.numAnswerController,
      
      decoration: new InputDecoration(
        
        labelText: "Numerical Answer",
        fillColor: Colors.white,
        enabledBorder: new OutlineInputBorder(borderSide: BorderSide( color: Colors.black, width: 1.0)),
        focusedBorder: new OutlineInputBorder(borderSide: BorderSide( color: Colors.black, width: 1.0)),

      ),
       keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
       inputFormatters: <TextInputFormatter>[
    //WhitelistingTextInputFormatter.digitsOnly,
    
  
], // Only numbers can be entered
    ),
    ),
      ),
    );
  }
}