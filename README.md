# Rumour - Anonymous Room-Code Chat App

A Flutter + Firebase Cloud Firestore-based anonymous chat application allowing users to join or create rooms using room codes and communicate with randomly generated identities.

## 🎯 Features

- **Anonymous Chat**: Chat with randomly generated identities per room
- **Room Codes**: Simple alphanumeric codes to join existing rooms
- **Persistent Identity**: Your identity persists when rejoining a room from the same device
- **Real-time Messaging**: Server-timestamped messages with instant delivery
- **Offline Support**: Previously loaded messages visible without connectivity
- **Message Pagination**: Load chat history as needed
- **Member Count**: See active members in each room
- **Date Separators**: Messages grouped by date for better organization
- **Dark Theme**: Modern dark UI optimized for readability

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point with Firebase initialization
├── firebase_options.dart     # Firebase configuration
├── constants/
│   └── app_constants.dart   # App-level constants
├── models/
│   ├── user.dart            # User model with serialization
│   ├── message.dart         # Message model with Firestore timestamps
│   ├── room.dart            # Room model for chat rooms
│   └── random_user_response.dart  # API response model
├── services/
│   ├── firestore_service.dart     # Firestore CRUD operations & streams
│   ├── random_user_service.dart   # Random User API integration
│   └── local_storage_service.dart # SharedPreferences for offline caching
├── screens/
│   ├── join_room_screen.dart      # Room joining/creation UI
│   ├── name_generation_screen.dart # Identity assignment UI
│   └── chat_screen.dart           # Main chat interface
├── theme/
│   └── app_theme.dart       # Theme colors and styling
└── widgets/
    ├── message_bubble.dart  # Message display component
    ├── date_separator.dart  # Date group separator
    └── loading_overlay.dart # Loading indicator overlay
```

## 🏗️ Firebase Cloud Firestore Structure

### Rooms Collection
```
rooms/
├── {roomId}
│   ├── id: string (document ID)
│   ├── code: string (6-character alphanumeric code)
│   ├── memberCount: integer
│   ├── createdAt: timestamp
│   ├── users/
│   │   └── {userId}
│   │       ├── id: string
│   │       ├── displayName: string
│   │       └── avatar: string (image URL)
│   └── messages/
│       └── {messageId}
│           ├── id: string
│           ├── roomId: string
│           ├── userId: string
│           ├── userName: string
│           ├── text: string
│           └── timestamp: timestamp (server time)
```

### Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /rooms/{roomId} {
      allow read, write: if true;
      match /users/{userId} {
        allow read, write: if true;
      }
      match /messages/{messageId} {
        allow read, write: if true;
      }
    }
  }
}
```

## 🔧 Getting Started

### Prerequisites
- Flutter SDK (3.10.1+)
- Dart SDK
- Firebase project configured with Firestore

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd chat_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Firebase**
- Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
- Enable Cloud Firestore database (start in test mode for development)
- Generate Firebase configuration files using FlutterFire CLI:
```bash
flutterfire configure
```
- Update `lib/firebase_options.dart` with your credentials

4. **Run the app**
```bash
flutter run
```

## 📱 Usage Flow

### 1. Join or Create Room
- **Join Existing Room**: Enter a 6-character room code
- **Create New Room**: Select "Create New Room" to get a new code

### 2. Generate Identity
- Random identity is fetched from [randomuser.me API](https://randomuser.me/api/)
- Identity persists locally for future room visits
- Can regenerate new identity before entering chat

### 3. Chat
- Send and receive messages in real-time
- View other members' identities and member count
- Load earlier messages via pagination
- Automatic date separators for message organization

## 🔌 API Integration

### Random User API
- **Endpoint**: `https://randomuser.me/api/`
- **Rate Limit**: 5000 requests/minute
- **Data Used**: First name, last name, user avatar

## 💾 Local Storage

Using SharedPreferences for offline capability:
- User identity per room
- Message history per room
- Room codes for quick access

Keys format:
- User: `user_{roomId}`
- Messages: `messages_{roomId}`
- Room Code: `room_code_{roomId}`

## 🎨 Theme System

### Color Palette
- **Primary**: `#CBFF00` (Lime Green)
- **Secondary**: `#1A1A1A` (Dark)
- **Background**: `#0F0F0F` (Almost Black)
- **Surface**: `#2A2A2A` (Light Dark)
- **Error**: `#FF6B6B` (Red)

## 🏗️ Architecture

### Service Layer
- **FirestoreService**: Real-time data operations and streams
- **RandomUserService**: External API integration
- **LocalStorageService**: Offline persistence

### State Management
- setState() for screen-level state
- Stream listeners for real-time updates
- Local caching fallback for connectivity issues

## 📦 Dependencies

```yaml
firebase_core: ^3.6.0         # Firebase initialization
cloud_firestore: ^5.5.0       # Cloud database
http: ^1.2.2                  # HTTP requests
shared_preferences: ^2.3.2    # Local storage
intl: ^0.20.1                 # Date formatting
uuid: ^4.3.1                  # Unique ID generation
```

## 🐛 Error Handling

- Network timeouts: 10-second default timeout for API calls
- Firestore errors: User-friendly error messages
- Offline mode: Local data loads when connectivity lost
- Invalid room codes: Clear feedback messages

## 📊 Performance Considerations

- **Message Pagination**: 20 messages per load to reduce bandwidth
- **Real-time Streams**: Automatic pagination for large message lists
- **Local Caching**: Reduces Firestore reads for returning users
- **Lazy Loading**: Images loaded on demand

## 🚀 Building for Production

### Android APK
```bash
flutter build apk --split-per-abi
```

### iOS IPA
```bash
flutter build ios
```

### Web
```bash
flutter build web
```

## 📸 Screenshots

The app includes three main screens:
1. **Join Room Screen**: Room code entry and creation
2. **Name Generation Screen**: Identity preview and confirmation
3. **Chat Screen**: Real-time messaging interface

## 🔒 Security Notes

- Anonymous by design (no user authentication required)
- Firestore rules can be restricted by IP or user authentication
- Room codes are simple but effective for casual use
- Consider implementing rate limiting for production

## 📝 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- [randomuser.me](https://randomuser.me/) for user generation
- [Google Firebase](https://firebase.google.com/) for backend services
- [Flutter](https://flutter.dev/) framework

---

**Note**: This is a fully functional prototype. For production deployment, consider:
- Implementing user authentication
- Adding content moderation
- Setting up analytics
- Implementing message encryption
- Adding rate limiting and abuse prevention

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# rumour-chat-app
