import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PublicProjectsList extends StatefulWidget {
  @override
  _PublicProjectsListState createState() => _PublicProjectsListState();
}

class _PublicProjectsListState extends State<PublicProjectsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View All Public Projects"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            new Text('Current Roster'),
            new StreamBuilder(
              stream: Firestore.instance.collection('Projects')
                .snapshots(),
              builder: (BuildContext context, snapshot) {
                if(!snapshot.hasData) return new Text('...Loading');
                return new Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: new ListView(
                      children: snapshot.data.documents.map<Widget>((doc){
                        return new ListTile(
                          title: new Text(doc['title']),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ]
        ),
      ),
    );
  }
}