import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

//if you are on a web app, do not use local storage
const bool kIsWeb = identical(0, 0.0);

//function to get where app files will be stored
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return(directory.path);
}

//create reference to file location folder so all files can be deleted
//upon uploading to cloud storage
Future<File> _localFolder(String code) async {
  final path = await _localPath;
  return new File('$path/codes/$code');
}

//create a reference to the file location
//provide the student code to make a unique file path for the data
Future<File> _localFile(String code, String name) async {
  final path = await _localPath;
  return new File('$path/codes/$code/$name').create(recursive: true);
}

//get an existing image file

//Write text data into a student's file
Future<File> writeString(String code, String content, String qNum) async {
  if (kIsWeb) return null;
  final file = await _localFile(code, '$qNum.txt');
  return file.writeAsString(content);
}

//save an image into a student's file
Future<File> writeImage(String code, String qNum, File copyImage) async {
  if (kIsWeb) return null;
  final toFile = await _localFile(code, '$qNum.png');
  final file = await copyImage.copy(toFile.path);
  return file;
}

//get image from the student's file
Future<File> getImage(String code, String qNum) async {
  if(kIsWeb) {
    return null;
  }
  final file = await _localFile(code, '$qNum.png');
  int size = await file.length();
  print("size of file: " + size.toString());
  if(size < 1) {
    return null;
  }
  return file;
}

//read content from the student's file
Future<String> readString(String code, String qNum) async {
  if(kIsWeb) {
    return '!ERROR!';
  }
  try{
    final file = await _localFile(code, '$qNum.txt');
    String contents = await file.readAsString();
    return contents;
  } catch (e) {
    //return a default string, Error, if the file cannot be read
    return '!ERROR!';
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

