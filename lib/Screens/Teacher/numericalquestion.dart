import 'package:flutter/material.dart';
import '../../Services/getproject.dart';

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
        fillColor: Colors.white,
        enabledBorder: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
    )
    );
  }
}