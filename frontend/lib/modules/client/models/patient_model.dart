class Patient {
  final String? id;
  final String name;
  final int age;
  final double weight;
  final double height;
  final String medicalCondition;
  final String email;
  final String phone;

  Patient({
    this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.medicalCondition,
    required this.email,
    required this.phone,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'],
      name: json['name'],
      age: json['age'],
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      medicalCondition: json['medical_condition'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'medical_condition': medicalCondition, // importante!
      'email': email,
      'phone': phone,
    };
  }
}
