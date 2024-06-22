class Patient {
  final String code;
  final String firstName;
  final String lastName;
  final int age;
  final String dni;
  final String contactNumber;
  final DateTime admissionDate;
  final String currentState;

  Patient({
    required this.code,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.dni,
    required this.contactNumber,
    required this.admissionDate,
    required this.currentState,
  });
}