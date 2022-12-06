
class Class {
  final String ma_lop;
  final String ten_khoa;

  Class({required this.ma_lop,required this.ten_khoa});

  factory Class.fromMap(Map<String, dynamic> json) => Class(
    ma_lop: json['ma_lop'],
    ten_khoa: json['ten_khoa'],
  );

  Map<String, dynamic> toMap() {
    return {
      'ma_lop': ma_lop,
      'ten_khoa': ten_khoa,
    };
  }
}
