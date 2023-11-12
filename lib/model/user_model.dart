class UserModel {
  final String lastname;
  final String firstname;
  final String email;
  final String password;

  UserModel(
      {required this.lastname,
      required this.firstname,
      required this.email,
      required this.password});

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      firstname: map['firstname'],
      lastname: map['lastname'],
      password: map['password'],
      email: map['email'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "password": password
    };
  }
}
