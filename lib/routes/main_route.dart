import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:test_dropdownbutton/routes/tab_view_1/all_departments_route.dart';
import 'package:test_dropdownbutton/routes/tab_view_2/class_route.dart';
import 'package:test_dropdownbutton/routes/tab_view_3/student_info_route.dart';

import '../database/student.dart';
import 'constant.dart';

class StudentMainRoute extends StatefulWidget {
  Student stu;


  StudentMainRoute(this.stu);

  @override
  State<StudentMainRoute> createState() => _StudentMainRouteState(stu);
}

class _StudentMainRouteState extends State<StudentMainRoute> {
  late Student stu;

  _StudentMainRouteState(this.stu);

  @override
  Widget build(BuildContext context) {
    K.context = context;
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book_circle),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            List<StatefulWidget> tmp = [const AllDepartmentsRoute(),StudentInfoRoute(stu)];
            return tmp[index];
          },
        );
      },
    );
  }
}

class PdtMainRoute extends StatefulWidget {
  const PdtMainRoute({Key? key}) : super(key: key);


  @override
  State<PdtMainRoute> createState() => _PdtMainRouteState();
}

class _PdtMainRouteState extends State<PdtMainRoute> {
  @override
  Widget build(BuildContext context) {
    K.context = context;
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.archivebox),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search_circle),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            List<StatefulWidget> tmp = [const AllDepartmentsRoute(),ClassRoute()];
            return tmp[index];
          },
        );
      },
    );
  }
}

