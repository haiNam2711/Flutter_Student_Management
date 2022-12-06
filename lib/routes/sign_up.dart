import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:test_dropdownbutton/database/class.dart';
import 'package:test_dropdownbutton/database/student.dart';

import '../database/database.dart';

class SignUpRoute extends StatefulWidget {
  Function initial;


  SignUpRoute(this.initial);

  @override
  State<SignUpRoute> createState() => _SignUpRouteState(initial);
}

class _SignUpRouteState extends State<SignUpRoute> {
  Function initial = (){};
  String classValue = '';
  List<Class> classes = [];
  String malopText = '';
  int _selectedClass = 0;
  TextEditingController studentId = TextEditingController();
  TextEditingController studentName = TextEditingController();
  TextEditingController studentEmail = TextEditingController();
  TextEditingController studentPass = TextEditingController();


  _SignUpRouteState(this.initial);

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    final classes =
        await DatabaseHelper.instance.getClasses("Khoa Công Nghệ Thông Tin");
    setState(() => this.classes = classes);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Color(0xffE0DFE1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.book_solid,
            size: 70,
            color: Colors.black,
          ),
          const SizedBox(
            height: 65,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: CupertinoTextField(
              controller: studentId,
              padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              cursorWidth: 2,
              cursorColor: Colors.black,
              style: const TextStyle(color: Colors.black),
              placeholderStyle: const TextStyle(color: Colors.black12),
              placeholder: 'Student Id',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: CupertinoTextField(
              controller: studentName,
              padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              cursorWidth: 2,
              cursorColor: Colors.black,
              style: const TextStyle(color: Colors.black),
              placeholderStyle: const TextStyle(color: Colors.black12),
              placeholder: 'Student Name',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: CupertinoTextField(
              controller: studentEmail,
              padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              cursorWidth: 2,
              cursorColor: Colors.black,
              style: const TextStyle(color: Colors.black),
              placeholderStyle: const TextStyle(color: Colors.black12),
              placeholder: 'Email',
            ),
          ),
          const SizedBox(
            height: 10,
          ),Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: CupertinoTextField(
              obscureText: true,
              controller: studentPass,
              padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              cursorWidth: 2,
              cursorColor: Colors.black,
              style: const TextStyle(color: Colors.black),
              placeholderStyle: const TextStyle(color: Colors.black12),
              placeholder: 'Password',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: CupertinoButton(
                padding: EdgeInsets.only(left: 19, top: 15, bottom: 15),
                alignment: Alignment.centerLeft,
                child: Text(
                  classes[_selectedClass].ma_lop,
                  style: TextStyle(color: Colors.black12,fontSize: 17,fontWeight: FontWeight.w400),
                ),
                  onPressed: () => _showDialog(
                    CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: 32.0,
                      // This is called when selected item is changed.
                      onSelectedItemChanged: (int selectedItem) {
                        setState(() {
                          _selectedClass = selectedItem;
                        });
                      },
                      children:
                      List<Widget>.generate(classes.length, (int index) {
                        return Center(
                          child: Text(
                            classes[index].ma_lop,
                          ),
                        );
                      }),
                    ),
                  ),
              ),
            ),
          ),
          const SizedBox(
            height: 65,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xff8215ef),
                  borderRadius: BorderRadius.circular(12)),
              child: CupertinoButton(
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                onPressed: () {
                  String id = studentId.text;
                  String email = studentEmail.text;
                  String name = studentName.text;
                  String pass = studentPass.text;

                  if (id != '' && email != '' && name != '' && pass != '') {
                    Student stu = Student(msv: id, ma_lop: classes[_selectedClass].ma_lop, ten: name, email: email,password: pass);
                    DatabaseHelper.instance.addStudent(stu);
                    Navigator.pop(context);
                    initial();
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              width: double.infinity,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: CupertinoButton(
                child: const Text(
                  'Back to Sign In',
                  style: TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }
}
