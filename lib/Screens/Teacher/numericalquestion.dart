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
    return Form(
      key: _formKey, 
        child: new TextFormField(
      controller: widget.numAnswerController,
      
      decoration: new InputDecoration(
        labelText: "Numerical Answer",
        
      ),
       inputFormatters: <TextInputFormatter>[
    WhitelistingTextInputFormatter.digitsOnly
], // Only numbers can be entered
    )
    );
  }
}