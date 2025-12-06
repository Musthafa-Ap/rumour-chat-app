class User {
  final String id;
  final String displayName;
  final String avatar;

  User({
    required this.id,
    required this.displayName,
    required this.avatar,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'avatar': avatar,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      displayName: map['displayName'] ?? 'Anonymous',
      avatar: map['avatar'] ?? '',
    );
  }

  User copyWith({
    String? id,
    String? displayName,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
    );
  }
}
