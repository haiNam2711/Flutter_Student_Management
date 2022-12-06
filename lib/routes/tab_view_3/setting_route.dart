import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_dropdownbutton/database/student.dart';
import 'package:test_dropdownbutton/routes/tab_view_3/student_info_route.dart';

import '../../database/database.dart';

class SettingRoute extends StatefulWidget {
  const SettingRoute({Key? key}) : super(key: key);

  @override
  State<SettingRoute> createState() => _SettingRouteState();
}

class _SettingRouteState extends State<SettingRoute> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: CupertinoSearchTextField(
            placeholder: 'Search for student ID',
            onChanged: (String str) {
              this.query = str;
              setState(() {});
            },
          ),
        ),
        child: Center(
          child: FutureBuilder<List<Student>>(
            future: DatabaseHelper.instance.getAllStudent(query),
            builder:
                (BuildContext context, AsyncSnapshot<List<Student>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CupertinoActivityIndicator());
              }
              return snapshot.data!.isEmpty
                  ? const Center(child: Text('No Departments in List.'))
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
                          ),
                        );
                      }).toList(),
                    );
            },
          ),
        ));
  }
}
