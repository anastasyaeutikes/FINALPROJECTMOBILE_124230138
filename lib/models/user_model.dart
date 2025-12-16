class User {
  final int? id;
  final String name;
  final String username;
  final String email;
  final String password;

  User({
    this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  User copy({
    int? id,
    String? name,
    String? username,
    String? email,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, username: $username, email: $email}';
  }
}
