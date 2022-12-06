import 'package:flutter/cupertino.dart';

import '../database/student.dart';

class K {
  static bool isStudent = false;
  static Student? stu;
  static BuildContext? context;

  static void popScaf() {
    Navigator.pop(K.context!);
  }
}