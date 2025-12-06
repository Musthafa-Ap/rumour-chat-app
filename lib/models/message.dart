import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String roomId;
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.userName,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomId': roomId,
      'userId': userId,
      'userName': userName,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  Map<String, dynamic> toLocalMap() {
    return {
      'id': id,
      'roomId': roomId,
      'userId': userId,
      'userName': userName,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Message.fromLocalMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      roomId: map['roomId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Anonymous',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'] as String)
          : DateTime.now(),
    );
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      roomId: map['roomId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Anonymous',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Message copyWith({
    String? id,
    String? roomId,
    String? userId,
    String? userName,
    String? text,
    DateTime? timestamp,
  }) {
    return Message(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
