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
    return new Container(
      margin: EdgeInsets.all(3.0),
      child: new Card(
        child: new Container(
        margin: EdgeInsets.all(3.0),
        child: Column(
          children: <Widget>[
            new TextFormField(
              controller: widget.controller,
              decoration: new InputDecoration(
                labelText: "Numerical Input",
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}