import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_dropdownbutton/routes/sign_in.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //deleteDatabase();
  runApp(const MyApp());
}
Future<void> deleteDatabase() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, 'students.db');
  databaseFactory.deleteDatabase(path);
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Demo',
      home: SignInRoute(),
      theme: CupertinoThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
    );
  }
}

