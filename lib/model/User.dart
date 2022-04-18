class User {
  final int id;
  final String name;
  final String username;

  User({required this.id, required this.name, required this.username});

  factory User.fromJson(Map<String, dynamic> jObj) {
    return User(id: jObj['id'], name: jObj['name'], username: jObj['username']);
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, username: $username}';
  }
}