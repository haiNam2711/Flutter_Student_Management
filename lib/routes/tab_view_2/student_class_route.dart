import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_dropdownbutton/routes/tab_view_3/student_info_route.dart';

import '../../database/class.dart';
import '../../database/database.dart';
import '../../database/student.dart';

class StudentClassRoute extends StatefulWidget {
  Class dClass;

  StudentClassRoute(this.dClass);

  @override
  State<StudentClassRoute> createState() => _StudentClassRouteState(dClass);
}

class _StudentClassRouteState extends State<StudentClassRoute> {
  late Class dClass;

  _StudentClassRouteState(this.dClass);

  @override
  Widget build(BuildContext context) {
    TextEditingController studentIdController = TextEditingController();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'All Students',
          style: TextStyle(fontSize: 17),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            CupertinoIcons.add,
            size: 30,
          ),
          onPressed: () {
            showCupertinoDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Text('Add a student to this class.'),
                  content: Column(
                    children: [
                      CupertinoTextField(
                        controller: studentIdController,
                        placeholder: 'Enter Student Id',
                      ),
                    ],
                  ),
                  actions: [
                    CupertinoButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                          String studentId = studentIdController.text;
                          DatabaseHelper.instance.addStudentToClass(dClass,studentId);
                          setState(() {});
                        }),
                    CupertinoButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                );
              },
            );
          },
        ),
      ),
      child: Center(
        child: FutureBuilder<List<Student>>(
          future: DatabaseHelper.instance.getStudent(dClass.ma_lop),
          builder:
              (BuildContext context, AsyncSnapshot<List<Student>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CupertinoActivityIndicator());
            }
            return snapshot.data!.isEmpty
                ? const Center(child: Text('No Students in List.'))
                : ListView(
              children: snapshot.data!.map((student) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 7.0, horizontal: 10.0),
                  child: ListTile(
                    title: Text(student.msv),
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (BuildContext context) {
                            return StudentInfoRoute(student);
                          }));
                    },
                    onLongPress: (){
                      DatabaseHelper.instance.removeStudentFromClass(student.msv);
                      setState(() {});
                    },
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
