import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sensational_science/Screens/Teacher/teachermain.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class ChangeProjectDueDate extends StatefulWidget{
  final String teachID;
  final String classID;
  final String projectID;
  final DateTime dueDate;

  ChangeProjectDueDate({this.teachID, this.classID, this.projectID, this.dueDate});
  @override
  _ChangeProjectDueDateState createState() => _ChangeProjectDueDateState();
}
class _ChangeProjectDueDateState extends State<ChangeProjectDueDate> {
  final _formKey = GlobalKey<FormState>();
  DateTime _date;

  @override
  void initState() {
    _date = widget.dueDate;
  }
  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Due Date"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
          actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.home, color: Colors.black),
              label: Text('Home', style: TextStyle(color: Colors.black)),
          onPressed: () {
             Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherHome()),
                  (Route<dynamic> route) => false,
                );
              },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: Column(
            children: [
              Card(
                child: Text("Current Due Date: " + widget.dueDate.toString())
              ),
              Container(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  bottom: 10.0),
                width: MediaQuery.of(context).size.width * 0.9,
                child: DateTimeField(
                  format: DateFormat("yyyy-MM-dd"),
                  decoration: const InputDecoration(
                    hintText: 'Project Due Date',
                    hintStyle: TextStyle(color: Colors.green),
                  ),
                  onChanged: (dt) => setState(() => _date = dt),
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        initialDate: currentValue ??(DateTime.now().isAfter(widget.dueDate)?DateTime.now():widget.dueDate),
                        lastDate: DateTime(2100));
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Please select a due date";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () async {
                    if(_formKey.currentState.validate()) {
                      await Firestore.instance.collection('Teachers')
                      .document(widget.teachID)
                      .collection('Classes')
                      .document(widget.classID)
                      .collection('Projects')
                      .document(widget.projectID)
                      .setData({
                        'dueDate': _date, //re-set due date based on selection
                      }, merge: true);
                      await Firestore.instance.collection('Teachers')
                      .document(widget.teachID)
                      .collection('Classes')
                      .document(widget.classID)
                      .collection('Projects')
                      .document(widget.projectID)
                      .collection('Students')
                      .getDocuments().then((code) {
                        code.documents.forEach((e) async { 
                          await Firestore.instance.collection('codes').document(e.documentID).setData({
                            'dueDate': _date, //re-set due date based on selection
                          }, merge: true);
                        });
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Due Date Changed!"),
                            content: Text("The due date for this project has been changed for all students"),
                            actions: [
                              RaisedButton(
                                child: Text("Close"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }
                              )
                            ],
                          );
                        }
                      );
                      Navigator.pop(context);
                    } else {
                      return;
                    }
                  },
                  child: Text('Change Due Date'),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}


