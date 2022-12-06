import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_dropdownbutton/database/learn.dart';
import 'package:test_dropdownbutton/database/mixed_sv_hocmon.dart';
import 'package:test_dropdownbutton/database/subject_class.dart';
import 'package:test_dropdownbutton/database/department.dart';
import 'package:test_dropdownbutton/database/subject.dart';
import 'student.dart';
import 'class.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'students.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE SINHVIEN (
      msv varchar(8) primary key,
      ma_lop nvarchar(15),
      ten ntext,
      email ntext,
      password ntext
      )
      ''');
    await db.execute('''
      CREATE TABLE LOP (
      ma_lop nvarchar(15) primary key, -- 13248   KTCC126  123
      ten_khoa ntext,
      foreign key(ten_khoa) references KHOA(ten)
      )
      ''');
    await db.execute('''
      CREATE TABLE KHOA (
      ten ntext primary key, -- Cong nghe thong tin
      nam_thanh_lap varchar(6) -- thêm n để viết được unicode
      )
      ''');
    await _createDep(db);
    await _createClass(db);
    await db.execute('''
      CREATE TABLE MONHOC (
      ma_mon varchar(12) primary key, -- int1001_10
      ten_mon ntext,
      ten_khoa ntext,  -- Cong nghe thong tin
      foreign key(ten_khoa) references KHOA(ten)
      )
      ''');

    await db.execute('''
      CREATE TABLE LOPMON (
      ma_mon varchar(12) , -- int1001
      ma_lop varchar(5) , -- 10
      ma_gv varchar(10), -- CNTT10
      primary key(ma_mon,ma_lop)
      )
      ''');

    await db.execute('''
      CREATE TABLE HOCMON (
      ma_mon varchar(12) , -- int1001
      ma_lop_mon varchar(5) , -- 10
      msv varchar(8), -- 21020110
      diem_tk REAL, --08.50
      primary key(ma_mon,ma_lop_mon,msv)
      )
      ''');
  }

  Future _createDep(Database db) async {
    await db.execute('''
      INSERT INTO KHOA(ten,nam_thanh_lap) VALUES("Khoa Công Nghệ Thông Tin","2010");
      ''');
    await db.execute('''
      INSERT INTO KHOA(ten,nam_thanh_lap) VALUES("Khoa Điện Tử Viễn Thông","2010");
      ''');
    await db.execute('''
      INSERT INTO KHOA(ten,nam_thanh_lap) VALUES("Khoa Tự Động Hoá","2010");
      ''');
  }

  Future _createClass(Database db) async {
    for (int i = 1; i <= 3; i++) {
      await db.execute('''
      INSERT INTO LOP(ma_lop,ten_khoa) VALUES("2021-CACLC$i","Khoa Công Nghệ Thông Tin");
      ''');
    }
  }

  // Future _createStudent(Database db) async {
  //   await db.execute('''
  //     INSERT INTO SINHVIEN(msv) VALUES("21020110");
  //     ''');
  // }

  Future<List<Class>> getClasses(String depName) async {
    Database db = await instance.database;
    var classes = await db.rawQuery(
        'SELECT * FROM LOP WHERE ten_khoa = "$depName" ORDER BY ma_lop');
    List<Class> classList =
        classes.isNotEmpty ? classes.map((c) => Class.fromMap(c)).toList() : [];
    return classList;
  }

  Future<List<Class>> getAllClasses() async {
    Database db = await instance.database;
    var classes = await db.rawQuery(
        'SELECT * FROM LOP ORDER BY ma_lop');
    List<Class> classList =
    classes.isNotEmpty ? classes.map((c) => Class.fromMap(c)).toList() : [];
    return classList;
  }

  Future<int> addClass(Class class_) async {
    Database db = await instance.database;
    //return await db.insert('LOP', class_.toMap());
    String maLop = class_.ma_lop;
    return await db.transaction((txn) async {
      int id1 = await txn.rawInsert('INSERT INTO LOP(ma_lop) VALUES("$maLop")');
      return id1;
    });
  }

  Future<int> removeClass(String ma_lop) async {
    Database db = await instance.database;
    return await db.rawDelete('DELETE FROM LOP WHERE ma_lop = ?', ['$ma_lop']);
  }

  Future<List<Student>> getStudent(String ma_lop) async {
    Database db = await instance.database;
    var students = await db.rawQuery(
        'SELECT * FROM SINHVIEN WHERE ma_lop = "$ma_lop" ORDER BY msv');
    List<Student> studentList = students.isNotEmpty
        ? students.map((c) => Student.fromMap(c)).toList()
        : [];
    return studentList;
  }

  Future<List<Student>> getAllStudent(String query) async {
    Database db = await instance.database;
    var students = await db.rawQuery('SELECT * FROM SINHVIEN ORDER BY msv');
    List<Student> studentList = students.isNotEmpty
        ? students.map((json) => Student.fromMap(json)).where((student) {
            final titleLower = student.msv;

            return titleLower.contains(query);
          }).toList()
        : [];
    return studentList;
  }

  Future<List<Learn>> getStudentFromSubjectClass(
      String maMon, String maLop) async {
    Database db = await instance.database;
    var students = await db.rawQuery(
        'SELECT * FROM HOCMON WHERE ma_mon = "$maMon" AND ma_lop_mon = "$maLop" ORDER BY msv');
    List<Learn> studentList = students.isNotEmpty
        ? students.map((c) => Learn.fromMap(c)).toList()
        : [];
    return studentList;
  }

  Future<int> addStudent(Student student) async {
    Database db = await instance.database;
    return await db.insert('SINHVIEN', student.toMap());
  }

  Future<int> addStudentToClass(Class dClass, String studentId) async {
    Database db = await instance.database;
    String classId = dClass.ma_lop;
    return await db.rawUpdate('UPDATE SINHVIEN SET ma_lop = ? WHERE msv = ?',
        ['$classId', '$studentId']);
  }

  Future<int> removeStudentFromClass(String studentId) async {
    Database db = await instance.database;
    return await db.rawUpdate(
        'UPDATE SINHVIEN SET ma_lop = ? WHERE msv = ?', [null, '$studentId']);
  }

  Future<int> removeStudent(String msv) async {
    Database db = await instance.database;
    return await db.delete('SINHVIEN', where: 'msv = ?', whereArgs: [msv]);
  }

  Future<List<Department>> getDepartments() async {
    Database db = await instance.database;
    var departments = await db.rawQuery('SELECT * FROM KHOA ORDER BY ten');
    List<Department> depList = departments.isNotEmpty
        ? departments.map((c) => Department.fromMap(c)).toList()
        : [];
    return depList;
  }

  Future<List<Subject>> getSubjects(String depName) async {
    Database db = await instance.database;
    var subjects = await db.rawQuery(
        'SELECT * FROM MONHOC WHERE ten_khoa = "$depName" ORDER BY ten_mon');
    List<Subject> depList = subjects.isNotEmpty
        ? subjects.map((c) => Subject.fromMap(c)).toList()
        : [];
    return depList;
  }

  Future<int> addSubject(Subject subject) async {
    Database db = await instance.database;
    return await db.insert('MONHOC', subject.toMap());
  }

  Future<int> removeSubject(String maMon) async {
    Database db = await instance.database;
    await db.delete('MONHOC', where: 'ma_mon = ?', whereArgs: [maMon]);
    await db.rawDelete('DELETE FROM LOPMON WHERE ma_mon = ?', ['$maMon']);
    return await db
        .rawDelete('DELETE FROM HOCMON WHERE ma_mon = ?', ['$maMon']);
  }

  Future<List<SubjectClass>> getSubjectClasses(String maMon) async {
    Database db = await instance.database;
    var subjectClasses = await db.rawQuery(
        'SELECT * FROM LOPMON WHERE ma_mon = "$maMon" ORDER BY ma_lop');
    List<SubjectClass> depList = subjectClasses.isNotEmpty
        ? subjectClasses.map((c) => SubjectClass.fromMap(c)).toList()
        : [];
    return depList;
  }

  Future<int> addSubjectClass(SubjectClass subjectClass) async {
    Database db = await instance.database;
    return await db.insert('LOPMON', subjectClass.toMap());
  }

  Future<int> removeSubjectClass(String maMon, String maLop) async {
    Database db = await instance.database;
    await db.rawDelete('DELETE FROM LOPMON WHERE ma_mon = ? AND ma_lop = ?',
        ['$maMon', '$maLop']);
    return await db.rawDelete(
        'DELETE FROM HOCMON WHERE ma_mon = ? AND ma_lop_mon = ?',
        ['$maMon', '$maLop']);
  }

  Future<int> addLearnRecord(Learn learn) async {
    Database db = await instance.database;
    String maMon = learn.ma_mon;
    String maLop = learn.ma_lop_mon;
    var students = await db.rawQuery(
        'SELECT * FROM LOPMON WHERE ma_mon = "$maMon" AND ma_lop = "$maLop"');
    if (students.isEmpty) {
      return -1;
    }
    return await db.insert('HOCMON', learn.toMap());
  }

  Future<List<Learn>> getLearns(String msv) async {
    Database db = await instance.database;
    var learns = await db
        .rawQuery('SELECT * FROM HOCMON WHERE msv = $msv ORDER BY ma_mon');
    List<Learn> depList =
        learns.isNotEmpty ? learns.map((c) => Learn.fromMap(c)).toList() : [];
    return depList;
  }

  Future<int> removeLearnRecord(Learn learn) async {
    Database db = await instance.database;
    String msv = learn.msv;
    String maMon = learn.ma_mon;
    String maLop = learn.ma_lop_mon;
    return await db.rawDelete(
        'DELETE FROM HOCMON WHERE msv = ? AND ma_mon = ? AND ma_lop_mon = ?',
        ['$msv', '$maMon', '$maLop']);
  }

  Future<int> updateScore(Learn learn, double newDiem) async {
    Database db = await instance.database;
    String msv = learn.msv;
    String maMon = learn.ma_mon;
    String maLop = learn.ma_lop_mon;
    return await db.rawUpdate(
        'UPDATE HOCMON SET diem_tk = ? WHERE msv = ? AND ma_mon = ? AND ma_lop_mon = ?',
        ['$newDiem', '$msv', '$maMon', '$maLop']);
  }

  Future<double> getMaxScore() async {
    Database db = await instance.database;
    var learns =
        await db.rawQuery('SELECT * FROM HOCMON ORDER BY ma_mon DESC LIMIT 1');
    List<Learn> depList =
        learns.isNotEmpty ? learns.map((c) => Learn.fromMap(c)).toList() : [];
    return depList[0] == null ? 0 : depList[0].diem_tk!;
  }

  Future<List<MixedSvH>> getAllStudentInfo(String msv) async {
    Database db = await instance.database;
    var students = await db.rawQuery(
        'SELECT SINHVIEN.msv,SINHVIEN.ma_lop,HOCMON.ma_mon,HOCMON.ma_lop_mon,HOCMON.diem_tk '
        'FROM SINHVIEN INNER JOIN HOCMON ON SINHVIEN.msv = HOCMON.msv '
        'WHERE SINHVIEN.msv = "$msv"');

    List<MixedSvH> studentInfo = students.isNotEmpty
        ? students.map((c) => MixedSvH.fromMap(c)).toList()
        : [];
    return studentInfo;
  }
}
