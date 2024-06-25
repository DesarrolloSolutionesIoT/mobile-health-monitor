class Patient {
  final int id;
  final String firstName;
  final String lastName;
  final String dni;
  final int age;
  final String gender;

  Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.age,
    required this.gender,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['patientId'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      dni: json['dni'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dni': dni,
      'age': age,
      'gender': gender,
    };
  }
}
