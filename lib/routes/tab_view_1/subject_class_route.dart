import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/database.dart';
import '../../database/learn.dart';
import '../../database/subject_class.dart';
import '../constant.dart';

class SubjectClassRoute extends StatefulWidget {
  SubjectClass subjectClass;

  SubjectClassRoute(this.subjectClass);

  @override
  State<SubjectClassRoute> createState() =>
      _SubjectClassRouteState(subjectClass);
}

class _SubjectClassRouteState extends State<SubjectClassRoute> {
  late SubjectClass subjectClass;
  late String maMon;
  late String maLop;
  late String maGv;
  late Learn maxLearn;

  _SubjectClassRouteState(SubjectClass subClass) {
    subjectClass = subClass;
    maMon = subClass.ma_mon;
    maLop = subClass.ma_lop;
    maGv = subClass.ma_gv;
    maxLearn = Learn(ma_mon: maMon, ma_lop_mon: maLop, msv: '', diem_tk: 0);
  }

  getMax() async {
    Learn max = await getMax();
    print(max.diem_tk);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'Sinh Vien',
          style: TextStyle(fontSize: 17),
        ),
        trailing: K.isStudent == true
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(
                  CupertinoIcons.add_circled,
                  size: 24,
                ),
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: Text('Đăng kí môn'),
                        content: Text('Bạn chắc chắn muốn đăng kí lớp này ?'),
                        actions: [
                          CupertinoButton(
                              child: Text('OK'),
                              onPressed: () async {
                                Learn learnRecord = Learn(
                                    ma_mon: maMon,
                                    ma_lop_mon: maLop,
                                    msv: K.stu!.msv);
                                await DatabaseHelper.instance
                                    .addLearnRecord(learnRecord);
                                Navigator.pop(context);
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
              )
            : CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(
                  CupertinoIcons.search_circle_fill,
                  size: 24,
                ),
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      double maxDiem = maxLearn.diem_tk!;
                      String msv = maxLearn.msv;
                      return CupertinoAlertDialog(
                        title: Text('Điểm cao nhất'),
                        content: Column(
                          children: [
                            Text('Msv: $msv'),
                            Text('Điểm: $maxDiem'),
                          ],
                        ),
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
                  Text('Lớp: $maMon - $maLop'),
                  Text('Giảng viên: $maGv')
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
                  future: DatabaseHelper.instance
                      .getStudentFromSubjectClass(maMon, maLop),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Learn>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    return snapshot.data!.isEmpty
                        ? const Center(child: Text('No Students.'))
                        : ListView(
                            children: snapshot.data!.map((learn) {
                              double dtk =
                                  learn.diem_tk == null ? 0 : learn.diem_tk!;
                              if (dtk > maxLearn.diem_tk!) {
                                maxLearn = learn;
                              }
                              String msv = learn.msv;
                              TextEditingController diemMoi =
                                  TextEditingController();
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 7.0, horizontal: 10.0),
                                child: ListTile(
                                  //enabled: !K.isStudent,
                                  title: Text('$msv'),
                                  subtitle: Text('Điểm tổng kết: $dtk'),
                                  onTap: K.isStudent == true
                                      ? () {}
                                      : () {
                                          showCupertinoDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CupertinoAlertDialog(
                                                title: Text(
                                                    'Cập nhập điểm tổng kết'),
                                                content: CupertinoTextField(
                                                  keyboardType: TextInputType
                                                      .numberWithOptions(
                                                          decimal: true),
                                                  controller: diemMoi,
                                                  placeholder:
                                                      'Enter Subject Id',
                                                ),
                                                actions: [
                                                  CupertinoButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        double dMoi =
                                                            double.parse(
                                                                diemMoi.text);
                                                        if (dMoi >
                                                            maxLearn.diem_tk!) {
                                                          maxLearn = learn;
                                                          maxLearn.diem_tk =
                                                              dMoi;
                                                        }
                                                        DatabaseHelper.instance
                                                            .updateScore(
                                                                learn, dMoi);
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      }),
                                                  CupertinoButton(
                                                      child: Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      })
                                                ],
                                              );
                                            },
                                          );
                                        },
                                  onLongPress: () {
                                    if (K.isStudent && learn.msv != K.stu!.msv) {
                                      return;
                                    }
                                    DatabaseHelper.instance
                                        .removeLearnRecord(learn);
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
