class PatientModel {
  final String? id;
  final String name;
  final String email;
  final String phone;

  PatientModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
