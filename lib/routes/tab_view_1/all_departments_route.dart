import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_dropdownbutton/database/department.dart';
import 'package:test_dropdownbutton/routes/tab_view_1/all_subject_route.dart';

import '../../database/database.dart';
import '../constant.dart';

class AllDepartmentsRoute extends StatefulWidget {
  const AllDepartmentsRoute({Key? key}) : super(key: key);

  @override
  State<AllDepartmentsRoute> createState() => _AllDepartmentsRouteState();
}

class _AllDepartmentsRouteState extends State<AllDepartmentsRoute> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'All Departments',
          style: TextStyle(fontSize: 17),
        ),
        trailing: CupertinoButton(child: Icon(Icons.login),padding: EdgeInsets.all(0), onPressed: (){K.popScaf();}),
      ),
      child: Center(
        child: FutureBuilder<List<Department>>(
          future: DatabaseHelper.instance.getDepartments(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Department>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CupertinoActivityIndicator());
            }
            return snapshot.data!.isEmpty
                ? const Center(child: Text('No Departments in List.'))
                : ListView(
                    children: snapshot.data!.map((dep) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 7.0, horizontal: 10.0),
                        child: ListTile(
                          title: Text(dep.ten),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (BuildContext context) {
                              return AllSubjectsRoute(dep);
                            }));
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
