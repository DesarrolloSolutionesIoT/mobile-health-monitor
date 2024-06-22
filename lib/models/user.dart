class User {
  final String name;
  final String email;
  final String password;
  final String type; // 'admin' or 'user'
  final String role; // 'doctor', 'nurse', 'family' (only for 'user')

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.type,
    required this.role,
  });
}
