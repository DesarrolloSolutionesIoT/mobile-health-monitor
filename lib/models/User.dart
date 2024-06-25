class User {
  final String firstName;
  final String lastName;
  final String email;
  final String typeId;

  User({required this.firstName, required this.lastName, required this.email, required this.typeId});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      typeId: json['typeOfUser']['typeId'].toString(),
    );
  }
}

class UserMemory {
  static User? currentUser;

  static void setUser(User user) {
    currentUser = user;
  }

  static User? getUser() {
    return currentUser;
  }
}
