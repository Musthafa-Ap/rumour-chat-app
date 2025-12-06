class RandomUserResponse {
  final String firstName;
  final String lastName;
  final String picture;

  RandomUserResponse({
    required this.firstName,
    required this.lastName,
    required this.picture,
  });

  factory RandomUserResponse.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List;
    if (results.isEmpty) {
      throw Exception('No user data received');
    }

    final user = results[0];
    final name = user['name'] as Map<String, dynamic>;
    final picture = user['picture'] as Map<String, dynamic>;

    return RandomUserResponse(
      firstName: name['first'] ?? 'User',
      lastName: name['last'] ?? 'Anonymous',
      picture: picture['large'] ?? '',
    );
  }

  String get displayName => '$firstName $lastName';
}
