import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_dropdownbutton/database/database.dart';
import 'package:test_dropdownbutton/database/learn.dart';
import 'package:test_dropdownbutton/database/student.dart';

class StudentManager extends StatefulWidget {
  Student student;

  StudentManager(this.student);

  @override
  State<StudentManager> createState() => _StudentManagerState(student);
}

class _StudentManagerState extends State<StudentManager> {
  late Student student;
  late String studentId;

  _StudentManagerState(this.student) {
    studentId = student.msv;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          '$studentId',
          style: TextStyle(fontSize: 17),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.all(0),
          child: Icon(CupertinoIcons.add_circled),
          onPressed: () {
            TextEditingController maMon = TextEditingController();
            TextEditingController maLop = TextEditingController();
            showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) => CupertinoActionSheet(
                      title: const Text('Đăng ký môn học'),
                      message: Column(
                        children: [
                          CupertinoTextField(
                              controller: maMon, placeholder: 'Mã Môn'),
                          SizedBox(
                            height: 13,
                          ),
                          CupertinoTextField(
                              controller: maLop, placeholder: 'Mã Lớp'),
                        ],
                      ),
                      actions: [
                        CupertinoActionSheetAction(
                          onPressed: () async {
                            String maMonHoc = maMon.text;
                            String maLopHoc = maLop.text;
                            Learn learnRecord = Learn(
                                ma_mon: maMonHoc,
                                ma_lop_mon: maLopHoc,
                                msv: studentId);
                            int tmp = await DatabaseHelper.instance.addLearnRecord(learnRecord);
                            Navigator.pop(context);
                            if (tmp == -1) {
                              showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: Text('Đăng kí môn thất bại',style: TextStyle(fontSize: 20),),
                                    content: Text('Lớp đăng kí không tồn tại',style: TextStyle(fontSize: 16),),
                                    actions: [
                                      CupertinoButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                    ],
                                  );
                                },
                              );
                            }
                            setState(() {});
                          },
                          child: Text('OK'),
                        ),
                        CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                    ));
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
                  Text('msv: $studentId'),
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
                child: FutureBuilder<List<Learn>>(
                  future: DatabaseHelper.instance.getLearns(studentId),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Learn>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    return snapshot.data!.isEmpty
                        ? const Center(
                            child: Text('This student has no class.'))
                        : ListView(
                            children: snapshot.data!.map((learn) {
                              String maMon = learn.ma_mon;
                              String lopMon = learn.ma_lop_mon;
                              double diemTk = learn.diem_tk == null? 0 : learn.diem_tk!;
                              return Card(
                                child: ListTile(
                                  title: Text('$maMon - $lopMon',style: TextStyle(color: Colors.black),),
                                  subtitle: Text('Diem Tong Ket: $diemTk',style: TextStyle(color: Colors.black),),
                                  onLongPress: (){
                                    DatabaseHelper.instance.removeLearnRecord(learn);
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
//
//