import 'package:flutter/material.dart';

class FireStorageService extends ChangeNotifier {
  FireStorageService._();
  FireStorageService();

  static Future<dynamic> loadImage(BuildContext context, dynamic image) {
    throw ("Platform not found");
  }

  static Future<dynamic> deleteFile(BuildContext context, dynamic filePath) {
    throw ("Platform not found");
  }
}