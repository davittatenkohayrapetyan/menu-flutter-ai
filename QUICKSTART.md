# Quick Start Guide

This guide will help you get the Menu Flutter AI app up and running quickly.

## Prerequisites

- Flutter SDK 3.0 or higher ([Install Flutter](https://docs.flutter.com/get-started/install))
- Node.js 18 or higher ([Install Node.js](https://nodejs.org/))
- An OpenAI API key ([Get API key](https://platform.openai.com/api-keys))
- Android Studio (for Android development) or Xcode (for iOS development)

## Step 1: Clone the Repository

```bash
git clone https://github.com/davittatenkohayrapetyan/menu-flutter-ai.git
cd menu-flutter-ai
```

## Step 2: Set Up the Backend Server

1. Navigate to the server directory:
```bash
cd server
```

2. Install dependencies:
```bash
npm install
```

3. Create a `.env` file:
```bash
cp .env.example .env
```

4. Edit `.env` and add your OpenAI API key:
```
OPENAI_API_KEY=sk-your-actual-api-key-here
PORT=3000
```

5. Start the server:
```bash
npm start
```

The server should now be running on http://localhost:3000

## Step 3: Set Up the Flutter App

1. Open a new terminal and navigate to the project root:
```bash
cd ..  # If you're in the server directory
```

2. Install Flutter dependencies:
```bash
flutter pub get
```

3. Generate code for Freezed models:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Step 4: Run the App

### On Android

1. Connect an Android device or start an emulator
2. Run the app:
```bash
flutter run
```

### On iOS (macOS only)

1. Connect an iOS device or start a simulator
2. Run the app:
```bash
flutter run
```

### On Web

```bash
flutter run -d chrome
```

## Step 5: Test the App

1. **Capture a Menu**: 
   - Tap "Take Photo" to capture a menu with your camera
   - Or tap "Pick from Gallery" to select an existing image
   
2. **Parse the Menu**:
   - After selecting an image, tap "Parse Menu"
   - The app will send the image to the server
   - Wait for the AI to extract menu items

3. **View Items**:
   - Navigate to the Review screen to see all parsed items
   - Tap on any item to view details

4. **Enrich an Item**:
   - On the item detail screen, tap "Enrich with AI"
   - The AI will generate a detailed description and nutrition information

## Using Docker (Alternative)

If you prefer to run the server in Docker:

1. Set your API key:
```bash
export OPENAI_API_KEY=sk-your-actual-api-key-here
```

2. Start with docker-compose:
```bash
docker-compose up -d
```

The server will be available at http://localhost:3000

## Troubleshooting

### Server Issues

- **"OpenAI API Key not configured"**: Make sure you've created a `.env` file with a valid `OPENAI_API_KEY`
- **Port already in use**: Change the `PORT` in your `.env` file

### Flutter Issues

- **Build errors**: Run `flutter clean` and then `flutter pub get`
- **Code generation errors**: Run `flutter pub run build_runner clean` then rebuild
- **Permission errors**: Make sure you've granted camera and storage permissions on your device

### Connection Issues

- **Can't connect to server**: 
  - On Android emulator, use `http://10.0.2.2:3000` instead of `http://localhost:3000`
  - On iOS simulator, `http://localhost:3000` should work
  - Update the `baseUrl` in `lib/services/api_service.dart` if needed

## Need Help?

- Check the main [README.md](README.md) for detailed documentation
- Review the [Server README](server/README.md) for API details
- Open an issue on GitHub if you encounter problems
