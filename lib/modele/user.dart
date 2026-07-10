class User {
  int? id;
  String username;
  String password;
  String? photoPath;
  String theme;
  String langue;

  User({
    this.id,
    required this.username,
    required this.password,
    this.photoPath,
    this.theme = 'clair',
    this.langue = 'fr',
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'password': password,
      'photo_path': photoPath,
      'theme': theme,
      'langue': langue,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      username: map['username'] as String,
      password: map['password'] as String,
      photoPath: map['photo_path'] as String?,
      theme: map['theme'] as String? ?? 'clair',
      langue: map['langue'] as String? ?? 'fr',
    );
  }
}