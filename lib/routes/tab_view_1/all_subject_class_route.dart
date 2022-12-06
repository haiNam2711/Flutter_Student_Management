import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_dropdownbutton/database/subject_class.dart';
import 'package:test_dropdownbutton/routes/tab_view_1/subject_class_route.dart';

import '../../database/database.dart';
import '../../database/subject.dart';
import '../constant.dart';

class AllSubjectClassRoute extends StatefulWidget {
  Subject subject;

  AllSubjectClassRoute(this.subject);

  @override
  State<AllSubjectClassRoute> createState() =>
      _AllSubjectClassRouteState(subject);
}

class _AllSubjectClassRouteState extends State<AllSubjectClassRoute> {
  late Subject subject;

  _AllSubjectClassRouteState(Subject subject) {
    this.subject = subject;
  }

  @override
  Widget build(BuildContext context) {
    String subName = subject.ten_mon;
    TextEditingController classIdEditingController = TextEditingController();
    TextEditingController lecturerIdEditingController = TextEditingController();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('$subName'),
        trailing: K.isStudent == true? Container(width: 1,) :  CupertinoButton(
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
                  title: const Text('Add a Subject Class'),
                  content: Column(
                    children: [
                      CupertinoTextField(
                        controller: classIdEditingController,
                        placeholder: 'Enter Class Id',
                      ),
                      const SizedBox(
                        height: 1,
                        child: Divider(
                          color: Colors.white,
                        ),
                      ),
                      CupertinoTextField(
                        controller: lecturerIdEditingController,
                        placeholder: 'Enter Lecturer Id',
                      ),
                    ],
                  ),
                  actions: [
                    CupertinoButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                          SubjectClass subjectClass = SubjectClass(
                              ma_mon: subject.ma_mon,
                              ma_lop: classIdEditingController.text,
                              ma_gv: lecturerIdEditingController.text);
                          DatabaseHelper.instance.addSubjectClass(subjectClass);
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
      child: SafeArea(
        child: Center(
          child: FutureBuilder<List<SubjectClass>>(
            future: DatabaseHelper.instance.getSubjectClasses(subject.ma_mon),
            builder: (BuildContext context,
                AsyncSnapshot<List<SubjectClass>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              return snapshot.data!.isEmpty
                  ? Center(child: Text('0 Classes of Subject: $subName.'))
                  : ListView(
                      children: snapshot.data!.map((subClass) {
                        String maMon = subClass.ma_mon;
                        String maLop = subClass.ma_lop;
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 7.0, horizontal: 10.0),
                          child: ListTile(
                            title: Text('$maMon - $maLop'),
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (BuildContext context) {
                                return SubjectClassRoute(subClass);
                              }));
                            },
                            onLongPress: () {
                              DatabaseHelper.instance
                                  .removeSubjectClass(maMon, maLop);
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
    );
  }
}
