

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/room.dart';
import '../models/message.dart';
import '../models/user.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _roomsCollection = 'rooms';
  static const String _messagesCollection = 'messages';
  static const String _usersCollection = 'users';
  static const int _pageSize = 20;

  // create or get a room by code
  Future<Room?> getRoomByCode(String code) async {
    try {
      final query = await _firestore
          .collection(_roomsCollection)
          .where('code', isEqualTo: code)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        return Room.fromMap({...doc.data(), 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching room: $e');
    }
  }

  // create a new room
  Future<Room> createRoom() async {
    try {
      final code = _generateRoomCode();
      final roomRef = await _firestore.collection(_roomsCollection).add({
        'code': code,
        'memberCount': 1,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return Room(
        id: roomRef.id,
        code: code,
        memberCount: 1,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Error creating room: $e');
    }
  }

  // save user to room
  Future<void> saveUserToRoom(String roomId, User user) async {
    try {
      await _firestore
          .collection(_roomsCollection)
          .doc(roomId)
          .collection(_usersCollection)
          .doc(user.id)
          .set(user.toMap());
    } catch (e) {
      throw Exception('Error saving user: $e');
    }
  }

  // get user from room
  Future<User?> getUserFromRoom(String roomId, String userId) async {
    try {
      final doc = await _firestore
          .collection(_roomsCollection)
          .doc(roomId)
          .collection(_usersCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        return User.fromMap({...doc.data() as Map<String, dynamic>});
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  // send a message
  Future<Message> sendMessage(String roomId, String userId, String userName, String text) async {
    try {
      const uuid = Uuid();
      final messageId = uuid.v4();

      final data = {
        'id': messageId,
        'roomId': roomId,
        'userId': userId,
        'userName': userName,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection(_roomsCollection)
          .doc(roomId)
          .collection(_messagesCollection)
          .doc(messageId)
          .set(data);

      return Message(
        id: messageId,
        roomId: roomId,
        userId: userId,
        userName: userName,
        text: text,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  // get messages stream (real-time)
  Stream<List<Message>> getMessagesStream(String roomId) {
    return _firestore
        .collection(_roomsCollection)
        .doc(roomId)
        .collection(_messagesCollection)
        .orderBy('timestamp', descending: true)
        .limit(_pageSize)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Message.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  // get messages for a specific date range (pagination)
  Future<List<Message>> getMessagesPaginated(String roomId, {int limit = _pageSize, DateTime? beforeDate}) async {
    try {
      Query query = _firestore
          .collection(_roomsCollection)
          .doc(roomId)
          .collection(_messagesCollection)
          .orderBy('timestamp', descending: true);

      if (beforeDate != null) {
        query = query.where('timestamp', isLessThan: beforeDate);
      }

      query = query.limit(limit);

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => Message.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Error fetching paginated messages: $e');
    }
  }

  // get room member count
  Future<int> getRoomMemberCount(String roomId) async {
    try {
      final snapshot = await _firestore
          .collection(_roomsCollection)
          .doc(roomId)
          .collection(_usersCollection)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      throw Exception('Error fetching member count: $e');
    }
  }

  // update room member count
  Future<void> updateRoomMemberCount(String roomId) async {
    try {
      final count = await getRoomMemberCount(roomId);
      await _firestore
          .collection(_roomsCollection)
          .doc(roomId)
          .update({'memberCount': count});
    } catch (e) {
      throw Exception('Error updating member count: $e');
    }
  }

  // listen to room member count changes
  Stream<int> getRoomMemberCountStream(String roomId) {
    return _firestore
        .collection(_roomsCollection)
        .doc(roomId)
        .collection(_usersCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  String _generateRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().microsecond;
    String code = '';
    for (int i = 0; i < 6; i++) {
      code += chars[(random + i) % chars.length];
    }

    return code;
  }
}
