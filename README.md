██████      ███    ██ ███████ ██████   █████  ██      ██ 
██    ██     ████   ██ ██      ██   ██ ██   ██ ██      ██ 
██    ██     ██ ██  ██ █████   ██████  ███████ ██      ██ 
██    ██     ██  ██ ██ ██      ██      ██   ██ ██      ██ 
 ██████      ██   ████ ███████ ██      ██   ██ ███████ ██ 

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

- **Flutter SDK**: Latest stable version ([Download Here](https://flutter.dev/docs/get-started/install))
- **Dart SDK**: Comes with Flutter, ensure it's up to date
- **IDE**: Android Studio / Visual Studio Code / IntelliJ IDEA
- **Android SDK**: Required for Android development
- **Xcode**: Required for iOS development (Mac only)
- **Git**: Version control system

## Installation Process
Follow these steps to set up and run the project:

1. **Clone the Repository**:
   ```sh
   git clone <https://github.com/onepali/onepali-app.git>
   cd <O-Nepali-Kids-Learning-App>
   ```
2. **Install Flutter Dependencies**:
   ```sh
   flutter pub get
   ```
3. **Run the Project**:
   ```sh
   flutter run
   ```
4. **Build for Production**:
   ```sh
   flutter build apk   # For Android
   flutter build ios   # For iOS (Mac required)
   ```

## Technical Requirements

### Development Environment
- **Flutter Version**: 3.7.2
- **Dart Version**: 3.7.2

### Architecture & State Management
- **Architecture**: Clean architecture approach with clear separation of concerns.
- **State Management**: Provider with Clean Architecture.
- **Folder Structure**: Organized into logical modules for scalability and maintainability.
- **Code Style**: Follows Dart style guide and consistent naming conventions.

## Project Structure
```
lib/
└── src/
    ├── config/         # App configuration files (themes, routes, etc.)
    ├── core/           # Common/shared utilities
    │   ├── constants/  # App-wide constants (e.g., strings, colors)
    │   ├── errors/     # Error definitions and handling
    │   ├── utils/      # Utility functions and helpers
    │   └── services/   # Core services (network, storage, etc.)
    ├── data/           # Data layer (external sources)
    │   ├── models/     # Data models (DTOs)
    │   ├── datasources/ # Local/remote data sources (e.g., APIs, DB)
    │   └── repositories/ # Repository implementations
    ├── domain/         # Business logic layer
    │   ├── entities/   # Pure business models/entities
    │   ├── usecases/   # Application-specific business logic
    │   └── repositories/ # Repository contracts (abstract interfaces)
    ├── presentation/   # UI layer
    │   ├── screens/    # Screens/views (per feature)
    │   ├── widgets/    # Reusable UI components
    │   └── viewmodels/ # State management (e.g., Riverpod/Notifier)
    └── injector.dart   # Dependency injection setup
main.dart               # App entry point
```

### **Directory Structure Description**
- **`config/`**: Contains app configuration files such as themes, routes, and other global settings.
- **`core/`**: Houses shared utilities and services used across the app.
  - **`constants/`**: Defines app-wide constants like strings, colors, and other static values.
  - **`errors/`**: Manages error definitions and handling mechanisms.
  - **`utils/`**: Provides utility functions and helper methods.
  - **`services/`**: Includes core services like network requests, local storage, etc.
- **`data/`**: Represents the data layer responsible for external data sources.
  - **`models/`**: Defines data models or DTOs (Data Transfer Objects).
  - **`datasources/`**: Handles local and remote data sources such as APIs or databases.
  - **`repositories/`**: Implements repository patterns for data access.
- **`domain/`**: Contains the business logic layer.
  - **`entities/`**: Defines pure business models or entities.
  - **`usecases/`**: Encapsulates application-specific business logic.
  - **`repositories/`**: Declares repository contracts or abstract interfaces.
- **`presentation/`**: Manages the UI layer.
  - **`screens/`**: Contains screens or views for each feature.
  - **`widgets/`**: Includes reusable UI components.
  - **`viewmodels/`**: Handles state management using tools like Riverpod or Notifier.
- **`injector.dart`**: Sets up dependency injection for the app.
- **`main.dart`**: The entry point of the application.

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
