# menu-flutter-ai

Flutter app (Android/iOS) to snap or pick menu photos, parse dishes via an OpenAI-backed API, edit items, request detailed descriptions & estimated nutrition. Clean architecture with Riverpod state management, offline cache with Hive, and a Node.js Express API server for secure OpenAI calls.

## Features

### Flutter App
- **Capture Screen**: Take photos with camera or pick from gallery
- **Review Screen**: List and manage all captured menu items
- **Item Screen**: Edit details and enrich items with AI-generated descriptions and nutrition info
- **Offline Storage**: All items cached locally with Hive
- **State Management**: Riverpod for reactive state
- **Navigation**: GoRouter for type-safe routing
- **Models**: Freezed for immutable data models with JSON serialization

### Backend Server
- **POST /parse-menu**: Parse menu images using OpenAI Vision API
- **POST /enrich-dish**: Enrich dish with detailed descriptions and nutrition estimates
- **Docker support**: Easy deployment with Docker and docker-compose

## Tech Stack

### Flutter App
- **Flutter 3.0+**
- **Riverpod**: State management
- **GoRouter**: Declarative routing
- **Freezed**: Code generation for immutable models
- **json_serializable**: JSON serialization
- **Dio**: HTTP client
- **Camera & Image Picker**: Image capture and selection
- **Permission Handler**: Runtime permissions
- **Hive**: Local NoSQL database

### Backend
- **Node.js 18+**
- **Express**: Web framework
- **OpenAI SDK**: GPT-4 Vision and GPT-4 integration
- **Multer**: File upload handling
- **Docker**: Containerization

## Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Node.js 18+
- OpenAI API key

### Flutter App Setup

1. Install dependencies:
```bash
flutter pub get
```

2. Generate code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Run the app:
```bash
flutter run
```

### Server Setup

1. Navigate to server directory:
```bash
cd server
```

2. Install dependencies:
```bash
npm install
```

3. Create `.env` file:
```bash
cp .env.example .env
```

4. Add your OpenAI API key to `.env`:
```
OPENAI_API_KEY=sk-your-key-here
```

5. Start the server:
```bash
npm start
```

### Docker Setup

Run the entire stack with docker-compose:

```bash
# Set your OpenAI API key
export OPENAI_API_KEY=sk-your-key-here

# Start services
docker-compose up -d
```

## Project Structure

```
menu-flutter-ai/
├── lib/
│   ├── models/           # Freezed data models
│   │   ├── menu_item.dart
│   │   └── nutrition.dart
│   ├── providers/        # Riverpod providers
│   │   └── providers.dart
│   ├── screens/          # UI screens
│   │   ├── capture_screen.dart
│   │   ├── review_screen.dart
│   │   └── item_screen.dart
│   ├── services/         # Business logic services
│   │   ├── api_service.dart
│   │   ├── image_service.dart
│   │   └── storage_service.dart
│   ├── router/           # Navigation configuration
│   │   └── router.dart
│   └── main.dart
├── android/              # Android platform code
├── ios/                  # iOS platform code
├── server/               # Node.js backend
│   ├── index.js          # Express server
│   ├── Dockerfile
│   └── package.json
├── docker-compose.yml
└── pubspec.yaml
```

## API Configuration

By default, the Flutter app connects to `http://localhost:3000`. 

### Important Notes:
- **Android Emulator**: Use `http://10.0.2.2:3000` to connect to localhost on your development machine
- **iOS Simulator**: Use `http://localhost:3000`
- **Physical Devices**: Use your computer's IP address, e.g., `http://192.168.1.100:3000`

To change the API endpoint:

1. Open `lib/services/api_service.dart`
2. Update the `baseUrl` parameter in the `ApiService` constructor:

```dart
ApiService({String? baseUrl})
    : baseUrl = baseUrl ?? 'http://10.0.2.2:3000',  // For Android Emulator
```

## Permissions

### Android
The app requires the following permissions (already configured in AndroidManifest.xml):
- Camera
- Read/Write External Storage
- Internet

### iOS
The app requires the following permissions (already configured in Info.plist):
- Camera Usage
- Photo Library Usage
- Photo Library Add Usage

## Development

### Code Generation

When modifying Freezed models or adding new ones, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or watch for changes:

```bash
flutter pub run build_runner watch
```

## License

MIT
