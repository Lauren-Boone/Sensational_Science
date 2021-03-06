
import 'package:flutter/material.dart';
import '../../Services/getproject.dart';

// class MultQuestionWidget extends StatefulWidget {
//   final Questions question;
//     final TextEditingController multChoiceController; 
//   MultQuestionWidget({this.question, this.multChoiceController});
//   @override
//   _MultQuestionWidgetState createState() => _MultQuestionWidgetState();
// }

// class _MultQuestionWidgetState extends State<MultQuestionWidget> {
//     final _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey, 
//         child: new TextFormField(
//       controller: widget.multChoiceController,
//       decoration: new InputDecoration(
//         labelText: "Multiple Choice Answer",
//         fillColor: Colors.white,
//         enabledBorder: new OutlineInputBorder(
//           borderRadius: BorderRadius.circular(25.0),
//           borderSide: BorderSide(
//             color: Colors.black,
//           ),
//         ),
//       ),
//     )
//     );
//   }
// }

class MultQuestionWidget extends StatefulWidget {
  final Questions question;
  final TextEditingController multChoiceController; 
  MultQuestionWidget({this.question, this.multChoiceController});
  @override
  _MultQuestionWidgetState createState() => _MultQuestionWidgetState();
}

class _MultQuestionWidgetState extends State<MultQuestionWidget> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, 
      child: ListView.builder(
        itemCount: widget.question.answers.length,
        itemBuilder: (context,index) {
          return RadioListTile(
            title: Text(widget.question.answers[index]),
            value: index.toString(),
            //selected: widget.multChoiceController.text == index.toString(),
            onChanged: (value) {
              setState(() {
                widget.multChoiceController.text = value;
              });
            },
            groupValue: widget.multChoiceController.text,
          );
        }
      ),
    );
  }
}