import 'package:flutter/material.dart';
import '../../../Services/getproject.dart';
import 'QuestionWidget.dart';

class NumericalQuestion extends StatefulQuestionWidget {
  final Questions question;
  final TextEditingController numAnswerController = new TextEditingController(); 
  NumericalQuestion({this.question});
  @override
  _NumericalQuestionState createState() => _NumericalQuestionState();

  @override
  getAnswer() {
    // TODO: implement getAnswer
    return numAnswerController.text; 
  }
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