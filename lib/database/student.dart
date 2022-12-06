

class Student {

  final String msv;
  final String ma_lop;
  final String ten;
  final String email;
  final String password;

  Student({required this.msv,required this.ma_lop,required this.ten,required this.email,required this.password});

  factory Student.fromMap(Map<String, dynamic> json) => Student(
    msv: json['msv'],
    ma_lop: json['ma_lop'],
    ten: json['ten'],
    email: json['email'],
    password: json['password']
  );

  Map<String, dynamic> toMap() {
    return {
      'msv': msv,
      'ma_lop': ma_lop,
      'ten': ten,
      'email': email,
      'password': password
    };
  }
}
