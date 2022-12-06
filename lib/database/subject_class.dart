
class SubjectClass {
  final String ma_mon;
  final String ma_lop;
  final String ma_gv;

  SubjectClass({required this.ma_mon,required this.ma_lop,required this.ma_gv});

  factory SubjectClass.fromMap(Map<String, dynamic> json) => SubjectClass(
    ma_mon: json['ma_mon'],
    ma_lop: json['ma_lop'],
    ma_gv: json['ma_gv'],
  );

  Map<String, dynamic> toMap() {
    return {
      'ma_mon': ma_mon,
      'ma_lop': ma_lop,
      'ma_gv': ma_gv,
    };
  }
}
