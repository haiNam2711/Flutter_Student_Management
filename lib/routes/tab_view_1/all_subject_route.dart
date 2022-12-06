import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_dropdownbutton/database/department.dart';
import 'package:test_dropdownbutton/database/subject.dart';
import 'package:test_dropdownbutton/routes/tab_view_1/all_subject_class_route.dart';

import '../../database/database.dart';
import '../constant.dart';

class AllSubjectsRoute extends StatefulWidget {
  Department department;

  AllSubjectsRoute(this.department);

  @override
  State<AllSubjectsRoute> createState() => _AllSubjectsRouteState(department);
}

class _AllSubjectsRouteState extends State<AllSubjectsRoute> {
  late TextEditingController subjectIdEditingController;
  late TextEditingController subjectNameEditingController;
  late Department department;
  late String depName;
  late String depYear;

  _AllSubjectsRouteState(Department dep) {
    department = dep;
    depName = department.ten;
    depYear = department.nam_thanh_lap!;
    subjectIdEditingController = TextEditingController();
    subjectNameEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          '$depName',
          style: const TextStyle(fontSize: 17),
        ),
        trailing: K.isStudent == true? Container(width: 1,) : CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            CupertinoIcons.add,
            size: 27,
          ),
          onPressed: () {
            showCupertinoDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Text('Add a Subject'),
                  content: Column(
                    children: [
                      CupertinoTextField(
                        controller: subjectIdEditingController,
                        placeholder: 'Enter Subject Id',
                      ),
                      const SizedBox(
                        height: 1,
                        child: Divider(
                          color: Colors.white,
                        ),
                      ),
                      CupertinoTextField(
                        controller: subjectNameEditingController,
                        placeholder: 'Enter Subject Name',
                      ),
                    ],
                  ),
                  actions: [
                    CupertinoButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                          Subject subject = Subject(
                              ma_mon: subjectIdEditingController.text,
                              ten_mon: subjectNameEditingController.text,
                              ten_khoa: depName);
                          DatabaseHelper.instance.addSubject(subject);
                          subjectIdEditingController.text = '';
                          subjectNameEditingController.text = '';
                          setState(() {});
                        }),
                    CupertinoButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                          subjectIdEditingController.text = '';
                          subjectNameEditingController.text = '';
                        }),
                  ],
                );
              },
            );
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Năm thành lập: $depYear'),
                ],
              ),
            ),
            const SizedBox(
              height: 1,
              child: Divider(
                color: Colors.white,
              ),
            ),
            Expanded(
              flex: 6,
              child: Center(
                child: FutureBuilder<List<Subject>>(
                  future: DatabaseHelper.instance.getSubjects(depName),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Subject>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    return snapshot.data!.isEmpty
                        ? const Center(child: Text('No Subjects in Dep.'))
                        : ListView(
                            children: snapshot.data!.map((sub) {
                              String tenMon = sub.ten_mon;
                              String maMon = sub.ma_mon;
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 7.0, horizontal: 10.0),
                                child: ListTile(
                                  title: Text('$tenMon - $maMon'),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (BuildContext context) {
                                      return AllSubjectClassRoute(sub);
                                    }));
                                  },
                                  onLongPress: () {
                                    DatabaseHelper.instance
                                        .removeSubject(sub.ma_mon);
                                    setState(() {});
                                  },
                                ),
                              );
                            }).toList(),
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
