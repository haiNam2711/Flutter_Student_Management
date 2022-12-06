class MixedSvH {
  final String msv;
  final String? ma_lop;
  final String ma_mon;
  final String ma_lop_mon;
  double? diem_tk;

  MixedSvH(
      {required this.msv,
      this.ma_lop,
      required this.ma_mon,
      required this.ma_lop_mon,
      this.diem_tk});

  factory MixedSvH.fromMap(Map<String, dynamic> json) => MixedSvH(
        msv: json['msv'],
        ma_lop: json['ma_lop'],
        ma_mon: json['ma_mon'],
        ma_lop_mon: json['ma_lop_mon'],
        diem_tk: json['diem_tk'],
      );

  Map<String, dynamic> toMap() {
    return {
      'msv': msv,
      'ma_lop': ma_lop,
      'ma_mon': ma_mon,
      'ma_lop_mon': ma_lop_mon,
      'diem_tk': diem_tk,
    };
  }
}
