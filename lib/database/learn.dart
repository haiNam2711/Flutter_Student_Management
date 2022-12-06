
class Learn {
  final String ma_mon;
  final String ma_lop_mon;
  final String msv;
  double? diem_tk = 0;

  Learn({required this.ma_mon,required this.ma_lop_mon,required this.msv, this.diem_tk});



  factory Learn.fromMap(Map<String, dynamic> json) => Learn(
    ma_mon: json['ma_mon'],
    ma_lop_mon: json['ma_lop_mon'],
    msv: json['msv'],
    diem_tk: json['diem_tk'],
  );

  Map<String, dynamic> toMap() {
    return {
      'ma_mon': ma_mon,
      'ma_lop_mon': ma_lop_mon,
      'msv': msv,
      'diem_tk': diem_tk,
    };
  }
}
