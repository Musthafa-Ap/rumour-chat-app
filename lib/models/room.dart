import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String id;
  final String code;
  final int memberCount;
  final DateTime createdAt;

  Room({
    required this.id,
    required this.code,
    required this.memberCount,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'memberCount': memberCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] ?? '',
      code: map['code'] ?? '',
      memberCount: map['memberCount'] ?? 0,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Room copyWith({
    String? id,
    String? code,
    int? memberCount,
    DateTime? createdAt,
  }) {
    return Room(
      id: id ?? this.id,
      code: code ?? this.code,
      memberCount: memberCount ?? this.memberCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
