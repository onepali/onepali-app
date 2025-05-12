██████      ███    ██ ███████ ██████   █████  ██      ██ 
██    ██     ████   ██ ██      ██   ██ ██   ██ ██      ██ 
██    ██     ██ ██  ██ █████   ██████  ███████ ██      ██ 
██    ██     ██  ██ ██ ██      ██      ██   ██ ██      ██ 
 ██████      ██   ████ ███████ ██      ██   ██ ███████ ██ 
                                                                         
# O Nepali Learning App Documentation

## Overview
This document provides an in-depth overview of the O Nepali Learning App project structure, including its directory organization, purpose of each folder, and best practices for maintaining a scalable and modular application.

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
   git clone <https://github.com/ONepali/O-Nepali-Learning-App>
   cd <O-Nepali-Learning-App>
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

## Project Structure
```
- .dart_tool/          # Internal Dart tools directory
- .idea/               # IDE-specific settings (for Android Studio/IntelliJ)
- android/             # Native Android code
- assets/              # Static assets (images, fonts, etc.)
- docs/                # Documentation files
- ios/                 # Native iOS code
- lib/                 # Main Dart source code
  - src/               # Core application source code
    - common/          # Shared resources
      - constants/     # Application-wide constant values
      - enums/         # Enum classes for better type safety
      - extensions/    # Extension methods for reusable functionalities
      - utils/         # Utility functions and helper classes
      - widget/        # Common reusable UI widgets
    - config/          # App configuration files
    - domain/          # Business logic and core entities
      - entities/      # Core business objects
      - usecases/      # Application-specific business rules
    - provider/        # State management using Provider
    - repository/      # Data sources (API, database, local storage)
      - datasources/   # API and local storage handlers
      - models/        # Data structures for API/database
    - screen/          # UI screens (pages)
    - utils/           # Additional utility classes
    - widget/          # UI components
  - main.dart          # Application entry point
  - navigator_key.dart # Global navigator key
- linux/               # Linux platform support
- macos/               # macOS platform support
- web/                 # Web platform support
- windows/             # Windows platform support
- .env                 # Environment variables file
- .gitignore           # Git ignore rules
- analysis_options.yaml # Static analysis configurations
- pubspec.lock         # Lock file for dependencies
- pubspec.yaml         # Project metadata and dependencies
- README.md            # Project documentation
```

## Architecture: Clean Architecture with Enhanced View Layer
This project follows the **Clean Architecture** principles, ensuring a clear separation of concerns and high testability. The architecture is divided into distinct layers, each with a specific responsibility.

### **Clean Architecture Structure**
- **Presentation Layer**:
  - Contains the UI (View) and state management logic.
  - The View is responsible for rendering the UI and delegating user interactions to the ViewModel.
  - Example: `lib/src/screen/` and `lib/src/provider/`

- **Domain Layer**:
  - Contains the business logic and use cases.
  - Independent of any framework or external libraries.
  - Example: `lib/src/domain/`
    - `usecases/`: Contains application-specific business rules.
    - `entities/`: Defines core business objects.

- **Data Layer**:
  - Responsible for data handling, including API calls, database operations, and local storage.
  - Example: `lib/src/repository/`
    - `datasources/`: Handles data fetching from APIs or local storage.
    - `models/`: Defines data structures for API responses or database records.

### **Layered Interaction**
1. **View (Presentation Layer)**:
   - Displays data and captures user interactions.
   - Delegates user actions to the ViewModel.

2. **ViewModel (Presentation Layer)**:
   - Acts as a mediator between the View and the Domain Layer.
   - Fetches data from the Domain Layer and updates the View.

3. **Use Cases (Domain Layer)**:
   - Encapsulates business logic and application rules.
   - Interacts with the Repository to fetch or persist data.

4. **Repository (Data Layer)**:
   - Provides a unified interface for data operations.
   - Fetches data from remote APIs or local storage.

### **Directory Structure**
```
- lib/
  - src/
    - common/          # Shared resources
      - constants/     # Application-wide constant values
      - enums/         # Enum classes for better type safety
      - extensions/    # Extension methods for reusable functionalities
      - utils/         # Utility functions and helper classes
      - widget/        # Common reusable UI widgets
    - config/          # App configuration files
    - domain/          # Business logic and core entities
      - entities/      # Core business objects
      - usecases/      # Application-specific business rules
    - provider/        # State management using Provider
    - repository/      # Data sources (API, database, local storage)
      - datasources/   # API and local storage handlers
      - models/        # Data structures for API/database
    - screen/          # UI screens (pages)
    - utils/           # Additional utility classes
    - widget/          # UI components
  - main.dart          # Application entry point
  - navigator_key.dart # Global navigator key
```

### **Benefits of Clean Architecture**
1. **Separation of Concerns**: Each layer has a distinct responsibility.
2. **Testability**: Business logic is independent of the UI, making it easier to test.
3. **Scalability**: Modular structure allows for easy addition of new features.
4. **Maintainability**: Clear boundaries between layers simplify code maintenance.
5. **Reusability**: Domain logic can be reused across different platforms (e.g., mobile, web).

## Best Practices
1. **Separation of Concerns**: Keep UI, business logic, and data management separate.
2. **State Management**: Use Provider efficiently for state handling.
3. **Consistent Naming Conventions**: Follow Dart and Flutter best practices.
4. **Code Reusability**: Utilize common widgets and utility functions.
5. **Scalability**: Organize code into logical modules.
6. **Error Handling**: Implement robust error handling.
7. **Localization & Theming**: Ensure adaptability for different languages and themes.

## Conclusion
This structured approach ensures maintainability and scalability, making it easier for developers to collaborate and build upon the existing architecture. Proper use of Clean Architecture improves code efficiency and overall app performance.
