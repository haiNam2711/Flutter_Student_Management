
class Subject {
  final String ma_mon;
  final String ten_mon;
  final String ten_khoa;

  Subject({required this.ma_mon,required this.ten_mon,required this.ten_khoa});

  factory Subject.fromMap(Map<String, dynamic> json) => Subject(
    ma_mon: json['ma_mon'],
    ten_mon: json['ten_mon'],
    ten_khoa: json['ten_khoa'],
  );

  Map<String, dynamic> toMap() {
    return {
      'ma_mon': ma_mon,
      'ten_mon': ten_mon,
      'ten_khoa': ten_khoa,
    };
  }
}
