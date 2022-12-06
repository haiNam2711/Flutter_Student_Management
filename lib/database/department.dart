
class Department {
  final String ten;
  final String? nam_thanh_lap;

  Department({required this.ten, this.nam_thanh_lap});

  factory Department.fromMap(Map<String, dynamic> json) => Department(
    ten: json['ten'],
    nam_thanh_lap: json['nam_thanh_lap'],
  );

  Map<String, dynamic> toMap() {
    return {
      'ten': ten,
      'nam_thanh_lap': nam_thanh_lap,
    };
  }
}
