import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

//function to get where app files will be stored
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  print(directory.path);
  return(directory.path);
}

Future<File> _localFolder(String code) async {
  final path = await _localPath;
  return new File('$path/$code');
}

//create a reference to the file location
//provide the student code to make a unique file path for the data
Future<File> _localFile(String code, String name) async {
  final path = await _localPath;
  return new File('$path/$code/$name').create(recursive: true);
}

//Write text data into a student's file
Future<File> writeString(String code, String content) async {
  final file = await _localFile(code, 'data.txt');
  return file.writeAsString(content);
}
//save an image into a student's file


//read content from the student's file
Future<String> readString(String code) async {
  try{
    final file = await _localFile(code, 'data.txt');
    String contents = await file.readAsString();
    return contents;
  } catch (e) {
    //return a default string, Error, if the file cannot be read
    return 'Error';
  }
}

//delete all files starting with the student's code
Future<bool> deleteFiles(String code) async {
  try{
    final file = await _localFolder(code);
    await file.delete(recursive: true);
    return true;
  } catch (e) {
    return false;
  }
}