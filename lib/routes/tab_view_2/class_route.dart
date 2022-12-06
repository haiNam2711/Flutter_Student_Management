import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_dropdownbutton/database/class.dart';
import 'package:test_dropdownbutton/routes/tab_view_2/student_class_route.dart';

import '../../database/database.dart';
import '../constant.dart';

class ClassRoute extends StatefulWidget {
  @override
  State<ClassRoute> createState() => _ClassRouteState();
}

class _ClassRouteState extends State<ClassRoute> {
  late TextEditingController subjectIdEditingController;
  late TextEditingController subjectNameEditingController;

  _ClassRouteState() {
    subjectIdEditingController = TextEditingController();
    subjectNameEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'All Classes',
          style: TextStyle(fontSize: 17),
        ),
        trailing: K.isStudent == false
            ? CupertinoButton(
            child: Icon(Icons.login),
            padding: EdgeInsets.all(0),
            onPressed: () {
              K.popScaf();
            })
            : null,
      ),
      child: SafeArea(
        child: Center(
            child: FutureBuilder<List<Class>>(
              future: DatabaseHelper.instance.getAllClasses(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Class>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
                return snapshot.data!.isEmpty
                    ? const Center(child: Text('No Classes in Dep.'))
                    : ListView(
                        children: snapshot.data!.map((depClass) {
                          String maLop = depClass.ma_lop;
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 7.0, horizontal: 10.0),
                            child: ListTile(
                              title: Text('$maLop'),
                              onTap: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (BuildContext context) {
                                  return StudentClassRoute(depClass);
                                }));
                              },
                            ),
                          );
                        }).toList(),
                      );
              },
            ),
          ),
        ),
      );
  }
}
