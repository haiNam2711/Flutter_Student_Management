import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:test_dropdownbutton/database/database.dart';
import 'package:test_dropdownbutton/routes/main_route.dart';
import 'package:test_dropdownbutton/routes/sign_up.dart';

import '../database/student.dart';
import 'constant.dart';

class SignInRoute extends StatefulWidget {
  const SignInRoute({Key? key}) : super(key: key);

  @override
  State<SignInRoute> createState() => _SignInRouteState();
}

class _SignInRouteState extends State<SignInRoute> {
  String query = '';
  List<Student> students = [];
  TextEditingController idText = TextEditingController();
  TextEditingController passText = TextEditingController();

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
          const Text(
            'Welcome back!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Sign in to continue.',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: CupertinoTextField(
              controller: idText,
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
              obscureText: true,
              controller: passText,
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
                  color: Color(0xff8215ef),
                  borderRadius: BorderRadius.circular(12)),
              child: CupertinoButton(
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                onPressed: () {
                  String id = idText.text;
                  String pass = passText.text;
                  if (id == 'pdt' && pass == 'pdt') {
                    K.isStudent = false;
                    K.stu = null;
                    Navigator.of(context).push(
                        CupertinoPageRoute(builder: (BuildContext context) {
                          return PdtMainRoute();
                        }));
                    idText.text = '';
                    passText.text = '';
                    return;
                  }
                  if (id != '' && pass != '') {
                    for (int i = 0; i < students.length; i++) {
                      Student stu = students[i];

                      if (id == stu.msv && pass == stu.password) {
                        K.isStudent = true;
                        K.stu = stu;
                        idText.text = '';
                        passText.text = '';
                        Navigator.of(context).push(
                            CupertinoPageRoute(builder: (BuildContext context) {
                          return StudentMainRoute(stu);
                        }));
                      }
                    }
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Not a member? ', style: TextStyle(fontSize: 16)),
              RichText(
                  text: TextSpan(
                      text: 'Sign up',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (BuildContext context) {
                            return SignUpRoute(init);
                          }));
                          init();
                        }))
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final students = await DatabaseHelper.instance.getAllStudent(query);
    setState(() => this.students = students);
  }
}
