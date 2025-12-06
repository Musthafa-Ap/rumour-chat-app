//Code structre

lib/
├── main.dart                 
├── firebase_options.dart     
├── constants/
│   └── app_constants.dart  
├── models/
│   ├── user.dart            
│   ├── message.dart        
│   ├── room.dart            
│   └── random_user_response.dart  
├── services/
│   ├── firestore_service.dart    
│   ├── random_user_service.dart  
│   └── local_storage_service.dart
├── screens/
│   ├── join_room_screen.dart     
│   ├── name_generation_screen.dart 
│   └── chat_screen.dart         
├── theme/
│   └── app_theme.dart       
└── widgets/
    ├── message_bubble.dart  
    ├── date_separator.dart  
    └── loading_overlay.dart 





//Firebase Cloud Firestore Structure

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






//rumour-chat-app workflow video link - https://drive.google.com/file/d/1Zg4VXlEgHAx7xu5KjZ0RImODxUuCge62/view?usp=sharing




//apk link - https://drive.google.com/file/d/1hLYX-u_E8xuwC4O7M-WvKe0DwRp6eFMX/view?usp=sharing