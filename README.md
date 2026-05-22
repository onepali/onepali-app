<p align="center">
  <img src="assets/images/logo.png" alt="O Nepali logo" width="120" />
</p>

# O Nepali Kids Learning App Documentation

## Overview
This document provides an in-depth overview of the O Nepali Kids Learning App project structure, including its directory organization, purpose of each folder, and best practices for maintaining a scalable and modular application.

## Hardware Requirements
To develop and run this Flutter application efficiently, your system should meet the following hardware requirements:

- **Minimum Requirements:**
  - Processor: Intel Core i3 (8th Gen) or AMD Ryzen 3
  - RAM: 8GB
  - Storage: 40GB available space
  - OS: Windows 10 (64-bit) / macOS Monterey / Linux (Ubuntu 20.04+)
  - GPU: Integrated Graphics

- **Recommended Requirements:**
  - Processor: Intel Core i5/i7 (10th Gen) or AMD Ryzen 5/7
  - RAM: 16GB or more
  - Storage: SSD with at least 40-70GB free space
  - OS: Windows 11 / macOS Ventura / Latest Linux (Ubuntu 22.04+)
  - GPU: Dedicated GPU for better rendering performance

## Software Requirements
Ensure the following software dependencies are installed:

- **Flutter SDK**: See Technical Requirements below for version guidance. ([Download Here](https://flutter.dev/docs/get-started/install))
- **Dart SDK**: Comes with Flutter. See Technical Requirements below for version guidance
- **IDE**: Android Studio / Visual Studio Code / IntelliJ IDEA
- **Android SDK**: Required for Android development
- **Xcode**: Required for iOS development (Mac only)
- **Git**: Version control system

## Installation Process
Follow these steps to set up and run the project:

1. **Clone the Repository**:
   ```sh
   git clone <your-repository-url>
   cd onepali
   ```
2. **Install Flutter Dependencies**:
   ```sh
   flutter pub get
   ```
3. **Run the Project**:
   ```sh
   flutter run
   ```
4. **Build for Production** (example for Android APK):
   ```sh
   flutter build apk
   # For other platforms: flutter build <ios|web|linux|macos|windows>
   ```

## Technical Requirements

### Development Environment
- **Dart SDK Version**: `^3.7.2` (as specified in `pubspec.yaml`)
- **Flutter Version**: Ensure you are using a Flutter SDK version compatible with Dart `^3.7.2`. (Note: The project's `.metadata` file currently indicates Flutter 3.7.0 via revision `c23637390482d4cf9598c3ce3f2be31aa7332daf`, which typically uses Dart 2.19.0. You may need to ensure your `pubspec.yaml` and actual Flutter environment are aligned.)
- **IDE**: Android Studio / Visual Studio Code / IntelliJ IDEA
- **Android SDK**: Required for Android development
- **Xcode**: Required for iOS development (Mac only)
- **Git**: Version control system

### Architecture & State Management
- **Architecture**: Clean architecture approach with clear separation of concerns.
- **State Management**: Provider with Clean Architecture.
- **Folder Structure**: Organized into logical modules for scalability and maintainability.
- **Code Style**: Follows Dart style guide and consistent naming conventions.

## Project Structure
The project follows a standard Flutter project structure, with additional organization for clarity and scalability, aligning with Clean Architecture principles.
```
onepali/
├── android/              # Android specific platform code and configurations
├── assets/               # Static assets like images, fonts, audio, and JSON data
│   ├── audio/            # Sound files and music (e.g., animals/, sfx/)
│   ├── brand/            # Branding assets (logos, etc.)
│   ├── fonts/            # Custom fonts (Poppins, Mukta)
│   ├── images/           # Image assets (backgrounds, placeholders, category images)
│   ├── json/             # JSON data files (categories, lessons, stories, localization)
│   ├── lottie/           # Lottie animation files
│   └── svg/              # SVG vector graphics (icons, illustrations)
├── ios/                  # iOS specific platform code and configurations
├── lib/                  # Core application source code (Dart)
│   ├── main.dart         # Main application entry point
│   ├── navigator_key.dart # Global navigator key (present in workspace)
│   └── src/              # Main source code, typically organized by features/layers
│       │                 # (e.g., data, domain, presentation layers for Clean Architecture)
│       ├── config/       # (Example) App configuration (themes, routes)
│       └── injector.dart # (Example) Dependency injection setup
├── linux/                # Linux specific platform code
├── macos/                # macOS specific platform code
├── scripts/              # Utility scripts (build, analysis, format, etc.)
│   ├── analyze.sh
│   ├── build_apk.sh
│   ├── clean.sh
│   ├── format.sh
│   └── ... (other project-specific scripts)
├── test/                 # Automated tests (unit, widget, integration)
│   ├── widget_test.dart  # Example widget test
│   ├── core/             # Tests for core logic/domain
│   ├── provider/         # Tests for providers/state management
│   └── repo/             # Tests for data repositories
├── web/                  # Web specific platform code and configurations
├── windows/              # Windows specific platform code
├── .gitignore            # Specifies intentionally untracked files
├── analysis_options.yaml # Dart static analysis tool configuration
├── pubspec.yaml          # Project metadata and dependencies
├── pubspec.lock          # Records exact versions of all dependencies
└── README.md             # This documentation file
```

### **Directory Structure Description**
Key directories include:
- **`lib/`**: This is where the vast majority of the Dart code for the application resides.
  - **`lib/main.dart`**: The entry point of the Flutter application.
  - **`lib/src/`**: Contains the core application logic, structured to support a Clean Architecture approach. This typically includes UI (presentation), business logic (domain), data handling (data layer), dependency injection, routing, and utility classes.
- **`assets/`**: Holds all static assets like images, fonts, JSON files, Lottie animations, audio files, etc., which are bundled with the app. The subdirectory structure (e.g., `assets/images/animals/`) indicates organized asset management.
- **`test/`**: Contains all automated tests. The subdirectories (`core/`, `provider/`, `repo/`) suggest tests are organized by architectural layers or features.
- **Platform-specific folders (`android/`, `ios/`, `linux/`, `macos/`, `web/`, `windows/`)**: Contain code and configuration specific to each target platform.
- **`scripts/`**: Contains various utility shell scripts for common development tasks such as building the app, running analysis, cleaning the project, and code formatting.

## Packages Used
The following packages are used in this project:
- **Provider**: State management (`provider: ^6.1.5`)
- **Dio**: HTTP client for API integration (`dio: ^5.8.0+1`)
- **Flutter Dotenv**: Environment variable management (`flutter_dotenv: ^5.2.1`)
- **Photo View**: Image zooming and panning (`photo_view: ^0.15.0`)
- **Share Plus**: Sharing content (`share_plus: ^11.0.0`)
- **Connectivity Plus**: Network connectivity status (`connectivity_plus: ^6.1.4`)
- **Google Sign-In**: Google authentication (`google_sign_in: ^6.3.0`)
- **HTTP Parser**: Parsing HTTP requests (`http_parser: ^4.1.2`)
- **Flutter SVG**: SVG rendering (`flutter_svg: ^2.1.0`)
- **URL Launcher**: Launching URLs (`url_launcher: ^6.3.1`)
- **Audioplayers**: Audio playback (`audioplayers: ^6.4.0`)
- **Cached Network Image**: Image caching (`cached_network_image: ^3.4.1`)
- **Lottie**: Lottie animations (`lottie: ^3.3.1`)

## Best Practices
1. **Separation of Concerns**: Keep UI, business logic, and data management separate.
2. **State Management**: Use Provider efficiently for state handling.
3. **Consistent Naming Conventions**: Follow Dart and Flutter best practices.
4. **Code Reusability**: Utilize common widgets and utility functions.
5. **Scalability**: Organize code into logical modules.
6. **Error Handling**: Implement robust error handling.
7. **Localization & Theming**: Ensure adaptability for different languages and themes.

## Conclusion
This structured approach ensures maintainability and scalability, making it easier for developers to collaborate and build upon the existing architecture.
