# Project Summary: Menu Flutter AI

## Overview
This project is a complete Flutter 3 application with a Node.js backend for parsing menu images using OpenAI's API. It allows users to capture or select menu photos, parse them into structured data, and enrich individual items with AI-generated descriptions and nutrition information.

## Architecture

### Flutter App (Frontend)
- **Framework**: Flutter 3.0+ (Android, iOS, Web support)
- **State Management**: Riverpod 2.4+
- **Navigation**: GoRouter 13.0+
- **Data Models**: Freezed + json_serializable
- **HTTP Client**: Dio 5.4+
- **Local Storage**: Hive 2.2+ (with JSON serialization)
- **Image Handling**: Camera + Image Picker plugins
- **Permissions**: Permission Handler 11.1+

### Backend Server
- **Runtime**: Node.js 18+
- **Framework**: Express 4.18+
- **AI Integration**: OpenAI SDK 4.20+ (GPT-4 Vision + GPT-4)
- **File Handling**: Multer for multipart uploads
- **Deployment**: Docker + docker-compose ready

## Project Structure

```
menu-flutter-ai/
├── lib/                      # Flutter application code
│   ├── models/               # Data models (Freezed)
│   │   ├── menu_item.dart    # MenuItem model
│   │   └── nutrition.dart    # Nutrition model
│   ├── providers/            # Riverpod state providers
│   │   └── providers.dart    # All app providers
│   ├── router/               # Navigation configuration
│   │   └── router.dart       # GoRouter setup
│   ├── screens/              # UI screens
│   │   ├── capture_screen.dart  # Camera/gallery capture
│   │   ├── review_screen.dart   # List all items
│   │   └── item_screen.dart     # View/edit item details
│   ├── services/             # Business logic services
│   │   ├── api_service.dart     # HTTP client for backend
│   │   ├── image_service.dart   # Camera/gallery access
│   │   └── storage_service.dart # Local Hive storage
│   └── main.dart             # App entry point
├── android/                  # Android platform code
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       ├── kotlin/...
│   │       └── res/...
│   ├── build.gradle
│   └── settings.gradle
├── ios/                      # iOS platform code
│   └── Runner/
│       ├── AppDelegate.swift
│       └── Info.plist
├── web/                      # Web platform code
│   ├── index.html
│   └── manifest.json
├── server/                   # Node.js backend
│   ├── index.js              # Express server + OpenAI integration
│   ├── package.json          # Dependencies
│   ├── Dockerfile            # Docker configuration
│   ├── .env.example          # Environment variables template
│   └── README.md             # Server documentation
├── test/                     # Flutter tests
│   └── widget_test.dart
├── QUICKSTART.md             # Quick setup guide
├── CONTRIBUTING.md           # Contribution guidelines
├── LICENSE                   # MIT License
├── README.md                 # Main documentation
├── pubspec.yaml              # Flutter dependencies
├── docker-compose.yml        # Docker compose configuration
└── analysis_options.yaml     # Dart/Flutter linting rules
```

## Key Features Implemented

### 1. Capture Screen
- Take photos with device camera
- Select images from gallery
- Send images to backend for parsing
- Visual preview of selected image

### 2. Review Screen
- List all parsed menu items
- Delete items with confirmation
- Navigate to item details
- Empty state with helpful message
- Visual indicators for enriched items

### 3. Item Screen
- Edit item name, description, and price
- View nutrition information (when enriched)
- Enrich item with AI-generated details
- Save changes to local storage
- Navigation back to review screen

### 4. Data Models

#### MenuItem
```dart
{
  id: String,
  name: String,
  description: String,
  price: double,
  nutrition: Nutrition?,
  imagePath: String,
  isEnriched: bool,
  createdAt: DateTime?
}
```

#### Nutrition
```dart
{
  calories: double,
  protein: double,
  carbs: double,
  fat: double,
  fiber: double,
  sugar: double,
  sodium: double
}
```

### 5. Backend API

#### POST /parse-menu
- Accepts: multipart/form-data with image file
- Uses: GPT-4 Vision to extract menu items
- Returns: Array of MenuItem objects

#### POST /enrich-dish
- Accepts: JSON with name and description
- Uses: GPT-4 to generate detailed info
- Returns: Enriched MenuItem with nutrition data

## Configuration

### Environment Variables (Server)
- `OPENAI_API_KEY`: Required for AI features
- `PORT`: Server port (default: 3000)

### Platform-Specific API URLs
- Android Emulator: `http://10.0.2.2:3000`
- iOS Simulator: `http://localhost:3000`
- Physical Device: Use computer's IP address

### Permissions
- **Android**: Camera, Storage, Internet
- **iOS**: Camera, Photo Library

## Code Generation

The project uses build_runner for code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Generates:
- Freezed models (*.freezed.dart)
- JSON serialization (*.g.dart)

## Deployment Options

### Development
1. Run server: `npm start` in server/
2. Run Flutter: `flutter run` in root/

### Docker
```bash
export OPENAI_API_KEY=your-key
docker-compose up -d
```

## Dependencies Summary

### Flutter
- flutter_riverpod: State management
- go_router: Navigation
- freezed: Immutable models
- dio: HTTP client
- hive: Local database
- camera: Camera access
- image_picker: Gallery access
- permission_handler: Runtime permissions

### Node.js
- express: Web framework
- openai: AI integration
- multer: File uploads
- cors: CORS support
- dotenv: Environment variables

## Testing Strategy

### Flutter Tests
- Unit tests for models and services
- Widget tests for UI components
- Basic test infrastructure in place

### Server Tests
- Manual testing with health endpoint
- Ready for integration testing

## Security Considerations

1. **API Key Protection**: Never commit .env files
2. **CORS**: Configured for development (should be restricted in production)
3. **File Upload**: Temporary files are deleted after processing
4. **Input Validation**: Basic validation on endpoints

## Future Enhancements

Potential areas for expansion:
- Batch image processing
- Recipe generation
- Ingredient detection
- Dietary restrictions filtering
- Price comparison
- Social sharing
- Multi-language support
- Offline mode improvements

## Documentation

- **README.md**: Complete project overview
- **QUICKSTART.md**: Step-by-step setup guide
- **CONTRIBUTING.md**: Development guidelines
- **server/README.md**: API documentation
- **LICENSE**: MIT License

## Status

✅ All core features implemented
✅ Full project scaffolding complete
✅ Documentation comprehensive
✅ Server tested and operational
✅ Ready for development and deployment

## Next Steps for Users

1. Add OpenAI API key to server/.env
2. Run `flutter pub get`
3. Run `flutter pub run build_runner build`
4. Start server with `npm start`
5. Run Flutter app with `flutter run`
6. Test with real menu images

## Technology Versions

- Flutter: 3.0+ (stable)
- Dart: 3.0+
- Node.js: 18+
- OpenAI API: GPT-4 and GPT-4 Vision
- Gradle: 8.3
- Android: Min SDK 21, Target SDK 34
- iOS: iOS 12.0+
