import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/multiplechoice.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/userlocation.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/textInputItem.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/image_capture.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/shortAnswer.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/numericalInput.dart';
import 'package:sensational_science/models/user.dart';
import '../../models/project.dart';
import '../../Services/projectDB.dart';

var createLocationHandler = new UserLocation();

var locationResult = createLocationHandler.getUserLocation();

var createTextInputHandler =
    new TextInputItem(controller: new TextEditingController());

var createMultipleChoice = new MultipleChoice();

var createImageCapture = new AddImageInput();

var createShortAnswer = new ShortAnswerItem();

var createNumericalInput = new NumericalInputItem();

class ScrollTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Example Draggable'),
        ),
        body: SizedBox.expand(child: DraggableScrollableSheet(
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              color: Colors.blue,
              child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
            );
          },
        )));
  }
}

class CreateProject extends StatefulWidget {
  final String title;
  AddProject proj;
  CreateProject({this.title, this.proj});
  @override
  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
   /*
addProjectDataToDoc(String uid, List<Widget> acceptData, List<String> acceptType,List<List<TextEditingController>> multAnswers, int numQuestions, String docID)async{

   DocumentReference docRef = Firestore.instance
   .collection('Projects')
   .document(docID);
   for(var i =0; i < numQuestions; ++i){
     
     docRef
     .updateData({
       'TESTINGtype': acceptType[i].toString(),
       'TestQUEstion': acceptData[i].toString(), 

     });
 
 

   }

     Firestore.instance
  .runTransaction((transaction) async{
    await transaction.set(Firestore.instance
    .collection("Teachers")
  .document(uid)
  .collection('Created Projects')
  .document(),{
    'docIDref': docID,
    'title': widget.title,
  });
});

  
}*/

  List<TextEditingController> controllers = [];
  List<List<TextEditingController>> answerControllers = [];
  List<Widget> acceptData = [];
  List<String> acceptType = [];
  int questionCount = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text("Create Project Details"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
            backgroundColor: Colors.deepPurple,
            
            ),
        backgroundColor: Colors.grey[100],
        body: Padding(
          padding: EdgeInsets.all(10),
          child: new Expanded(
          // child: Align(
            child: new ListView(
              shrinkWrap: true,
                                children: <Widget>[
            new Container(
              // child: SingleChildScrollView(
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 4 * 2,
                          height: MediaQuery.of(context).size.height / 10 * 7,
                          child: DragTarget(
                            onWillAccept: (Widget addItem) {
                              if (addItem == null) {
                                return false;
                              }
                              return true;
                            },
                            onAccept: (Widget addItem) {
                              if (addItem.toString() ==
                                  createTextInputHandler.toString()) {
                                controllers.add(new TextEditingController());
                                acceptData.add(new TextInputItem(
                                  controller: controllers[questionCount],
                                ));
                                questionCount++;
                                acceptType.add(addItem.toString());
                              } else if (addItem.toString() ==
                                  createShortAnswer.toString()) {
                                controllers.add(new TextEditingController());
                                acceptData.add(new ShortAnswerItem(
                                  controller: controllers[questionCount],
                                ));
                                questionCount++;
                                acceptType.add(addItem.toString());
                              } else if (addItem.toString() ==
                                  createNumericalInput.toString()) {
                                controllers.add(new TextEditingController());
                                acceptData.add(new NumericalInputItem(
                                  controller: controllers[questionCount],
                                ));
                                questionCount++;
                                acceptType.add(addItem.toString());
                              } else if (addItem.toString() ==
                                  createImageCapture.toString()) {
                                controllers.add(new TextEditingController());
                                acceptData.add(new AddImageInput(
                                    controller: controllers[questionCount]));
                                questionCount++;
                                acceptType.add(addItem.toString());
                              } else if (addItem.toString() ==
                                  createLocationHandler.toString()) {
                                controllers.add(new TextEditingController());
                                acceptData.add(new UserLocation(
                                    controller: controllers[questionCount]));
                                questionCount++;
                                acceptType.add(addItem.toString());
                              } else if (addItem.toString() ==
                                  createMultipleChoice.toString()) {
                                controllers.add(new TextEditingController());
                                answerControllers.add([]);
                                acceptData.add(new MultipleChoice(
                                    controller: controllers[questionCount],
                                    answers: answerControllers[
                                        answerControllers.length - 1]));
                                questionCount++;
                                acceptType.add(addItem.toString());
                              }
                            },
                            builder: (context, List<dynamic> candidateData,
                                List<dynamic> rejectedData) {
                              return Container(
                                height: MediaQuery.of(context).size.height,
                                color: Colors.lightBlue[50],
                                child: acceptData.isEmpty
                                    ? Center(
                                        child: Text('Add Form Fields Here'),
                                      )
                                    : Column(children: acceptData),
                              );
                            },
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: RaisedButton(
                              child: Text('Submit Project'),
                              onPressed: () async {
                                widget.proj.addProjectDataToDoc(
                                    user.uid,
                                    controllers,
                                    acceptType,
                                    answerControllers,
                                    questionCount,
                                    widget.proj.getDocID());
                                widget.proj.addtodb(questionCount);
                                var answerCount = 0;
                                //print('submit project onPressed');
                                for (var i = 0; i < questionCount; i++) {
                                  // print(acceptType[i] +
                                  //     ': ' +
                                  //     controllers[i].text);
                                  if (acceptType[i] ==
                                      createMultipleChoice.toString()) {
                                    for (var item
                                        in answerControllers[answerCount]) {
                                      //print('answer option: ' + item.text);
                                    }
                                    answerCount++;
                                  }
                                }
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width / 3,
                            child: Draggable<Widget>(
                              child: Text('Text Input Field'),
                              data: createTextInputHandler,
                              feedback: Text('Text'),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width / 3,
                            child: Draggable<Widget>(
                              child: Text('Image Upload'),
                              data: createImageCapture,
                              feedback: Text('Image'),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width / 2,
                            child: Draggable<Widget>(
                              child: Text('User Location'),
                              data: createLocationHandler,
                              feedback: Text('Text'),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width / 3,
                            child: Draggable<Widget>(
                              child: Text('Multiple Choice'),
                              data: createMultipleChoice,
                              feedback: Text('Mult choice'),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width / 3,
                            child: Draggable<Widget>(
                              child: Text('Short Answer'),
                              data: createShortAnswer,
                              feedback: Text('Short Answer'),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width / 3,
                            child: Draggable<Widget>(
                              child: Text('Numerical Input'),
                              data: createNumericalInput,
                              feedback: Text('Numerical Input'),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width / 3,
                            child: SizedBox(width: 100, height: 100, child: ScrollTest(),),
                            
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]
            ),
          ),
        ),
      )
    );
  }
}
