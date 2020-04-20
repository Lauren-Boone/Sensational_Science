import 'package:flutter/material.dart';

class PopUp extends StatefulWidget {
  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  String _selection = 'hello';
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: ListView(
            children:  <Widget>[
                  Card(child: ListTile(
                title: Text('Classes'),
                subtitle: Text('View All Classes'),
                trailing: Icon(Icons.arrow_forward_ios), 
                
                ),
              ),
              Card(
               child:  PopupMenuButton<String>(
    onSelected: (String value) {
    setState(() {
        _selection = value;
    });
  },
  child: ListTile(
    leading: IconButton(
      icon: Icon(Icons.add_alarm),
      onPressed: () {
        print('Hello world');
      },
    ),
    title: Text('Title'),
    subtitle: Column(
      children: <Widget>[
        Text('Sub title'),
        Text(_selection == null ? 'Nothing selected yet' : _selection.toString()),
      ],
    ),
    trailing: Icon(Icons.account_circle),
  ),
  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Value1',
          child: Text('Choose value 1'),
        ),
        const PopupMenuItem<String>(
          value: 'Value2',
          child: Text('Choose value 2'),
        ),
        const PopupMenuItem<String>(
          value: 'Value3',
          child: Text('Choose value 3'),
        ),
      ],
     
    ),
                
              ),
     
            ]
     ),
   );
  }
}