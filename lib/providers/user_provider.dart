import 'package:flutter/material.dart';
import '../models/user.dart' as app_user;
import '../models/room.dart';
import '../services/firestore_service.dart';
import '../services/random_user_service.dart';
import '../services/local_storage_service.dart';

class UserProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final LocalStorageService _localStorageService = LocalStorageService();

  app_user.User? _currentUser;
  bool _regenerateLoading = false;
  String? _error;
  int _memberCount = 0;

  app_user.User? get currentUser => _currentUser;
  bool get regenerateLoading => _regenerateLoading;
  String? get error => _error;
  int get memberCount => _memberCount;

  Future<void> initializeUser(Room room) async {
    _regenerateLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Check if user already exists locally
      final savedUser = await _localStorageService.getUserForRoom(room.id);
      
      if (savedUser != null) {
        _currentUser = savedUser;
        _regenerateLoading = false;
        notifyListeners();
      } else {
        // Generate new user
        await generateNewUser(room);
      }
    } catch (e) {
      _error = 'Error loading user: $e';
      _regenerateLoading = false;
      notifyListeners();
    }
  }

  Future<void> generateNewUser(Room room) async {
    try {
      _regenerateLoading = true;
      notifyListeners();

      final randomUser = await RandomUserService.fetchRandomUser();
      
      final newUser = app_user.User(
        id: '${room.id}_${DateTime.now().millisecondsSinceEpoch}',
        displayName: randomUser.displayName,
        avatar: randomUser.picture,
      );

      // Save user locally
      await _localStorageService.saveUserForRoom(room.id, newUser);
      
      // Save user to Firestore
      await _firestoreService.saveUserToRoom(room.id, newUser);

      _currentUser = newUser;
      _regenerateLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Error generating name: $e';
      _regenerateLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMemberCount(String roomId) async {
    try {
      final count = await _firestoreService.getRoomMemberCount(roomId);
      _memberCount = count;
      notifyListeners();
    } catch (e) {
    debugPrint(e.toString());
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void reset() {
    _currentUser = null;
    _regenerateLoading = false;
    _error = null;
    _memberCount = 0;
    notifyListeners();
  }
}
