import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_dropdownbutton/database/mixed_sv_hocmon.dart';

import '../../database/database.dart';
import '../../database/student.dart';
import '../constant.dart';

class StudentInfoRoute extends StatefulWidget {
  Student student;

  StudentInfoRoute(this.student);

  @override
  State<StudentInfoRoute> createState() => _StudentInfoRouteState(student);
}

class _StudentInfoRouteState extends State<StudentInfoRoute> {
  late Student student;
  final double coverHeight = 280;
  final double profileHeight = 144;

  _StudentInfoRouteState(this.student);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Thông tin sinh viên'),
        trailing: K.isStudent == true
            ? CupertinoButton(
                child: Icon(Icons.login),
                padding: EdgeInsets.all(0),
                onPressed: () {
                  K.popScaf();
                })
            : null,
      ),
      child: FutureBuilder<List<MixedSvH>>(
        future: DatabaseHelper.instance.getAllStudentInfo(student.msv),
        builder:
            (BuildContext context, AsyncSnapshot<List<MixedSvH>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CupertinoActivityIndicator());
          }
          List<MixedSvH> tmpList = snapshot.data!;
          return buildList(tmpList);
        },
      ),
    );
  }

  Widget buildList(List<MixedSvH> inp) {
    double tong = 0;
    int dai = inp.length;
    for (int i = 0; i < inp.length; i++) {
      tong += inp[i].diem_tk != null ? inp[i].diem_tk! : 0;
    }
    if (inp.isNotEmpty) {
      tong /= inp.length;
    }

    List<Widget> children = [];
    children.add(buildTop());
    children.add(buildContent());
    children.add(Divider());
    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildThongTin('Subjects', '$dai'),
        const SizedBox(
          width: 40,
        ),
        const SizedBox(
          width: 5,
          height: 10,
          child: Divider(
            color: Colors.black,
          ),
        ),
        const SizedBox(
          width: 40,
        ),
        buildThongTin('GPA', '$tong')
      ],
    ));
    children.add(Divider());

    for (int i=0;i<inp.length;i++) {
      String maMon = inp[i].ma_mon;
      String maLop = inp[i].ma_lop_mon;
      double dtk = inp[i].diem_tk == null? 0 : inp[i].diem_tk!;
      children.add(Card(
        child: ListTile(
          title: Text('$maMon $maLop'),
          subtitle: Text('Điểm tổng kết: $dtk'),
        ),
      ));
    }

    return ListView(padding: EdgeInsets.zero, children: children);
  }

  Widget buildThongTin(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            '$title',
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }


  Widget buildContent() {
    String stuName = student.ten;
    String email = student.email;
    String msv = student.msv;
    String malop = student.ma_lop;

    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          stuName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        Text(
          'Email: $email',
          style: TextStyle(
              color: Colors.black26, fontWeight: FontWeight.w400, fontSize: 20),
        ),
        Text(
          'Msv: $msv',
          style: TextStyle(
              color: Colors.black26, fontWeight: FontWeight.w400, fontSize: 20),
        ),
        Text(
          'Mã Lớp: $malop',
          style: TextStyle(
              color: Colors.black26, fontWeight: FontWeight.w400, fontSize: 20),
        )
      ],
    ));
  }

  Widget buildTop() => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: profileHeight / 2),
              child: buildCoverImage()),
          Positioned(
            child: buildProfileImage(),
            top: coverHeight - profileHeight / 2,
          )
        ],
      );

  Widget buildCoverImage() => Container(
        child: Image.network(
            'https://www.thenews.com.pk//assets/uploads/akhbar/2020-07-04/681766_5445089_uet_akhbar.jpg',
            width: double.infinity,
            height: coverHeight,
            fit: BoxFit.cover),
      );

  Widget buildProfileImage() => CircleAvatar(
        backgroundImage: NetworkImage(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGWshrzXkDcZqCW_YziWe9HYcTKFH4FDSjjg&usqp=CAU'),
        radius: profileHeight / 2,
      );

}

// child:
