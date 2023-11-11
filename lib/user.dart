// user.dart
class User {
  final int id; // Unique identifier for the user
  final String username; // Email as the username
  final String passwordHash; // Hashed password

  User({
    this.id = 0,
    required this.username,
    required this.passwordHash,
  });
}
