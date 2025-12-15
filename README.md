# Flutter GitHub Repository Explorer 🚀

<div align="center">

A production-ready Flutter application that explores GitHub repositories using the GitHub Search API. Built with **Clean Architecture**, **GetX** state management, and **offline-first** SQLite caching for a seamless user experience.

[![Flutter Version](https://img.shields.io/badge/Flutter-3.38+-blue.svg)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/Dart-3.10+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Screenshots](#-screenshots)
- [Tech Stack](#-tech-stack)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Project Structure](#-project-structure)
- [Architecture](#-architecture)
- [Data Flow](#-data-flow)
- [Usage](#-usage)
- [Testing](#-testing)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🌟 Overview

**Flutter GitHub Repository Explorer** is a feature-rich mobile application that allows users to search and explore top-starred Flutter repositories on GitHub. The app demonstrates modern Flutter development practices with a focus on:

- **Clean Architecture** with feature-first organization
- **Offline-first** approach with SQLite caching
- **Reactive state management** using GetX
- **Responsive UI** with flutter_screenutil
- **Beautiful dark/light themes** with smooth transitions
- **Optimized performance** with image caching and lazy loading

---

## ✨ Key Features

### 🔍 Repository Discovery
- 📊 Fetch top 50 Flutter repositories sorted by stars
- 🔄 Pull-to-refresh for latest data
- 📜 Infinite scroll pagination
- 🔎 View detailed repository information

### 💾 Offline Support
- 📦 SQLite database for local caching
- 🌐 Automatic offline fallback
- ⚡ 24-hour cache strategy with force refresh option
- 📱 Connectivity detection with offline banner

### 🎨 User Experience
- 🎭 Light & Dark theme support (system-aware)
- 📐 Responsive design with ScreenUtil (375x812 design)
- 🖼️ Cached network images with custom cache manager
- ✨ Skeleton loading states
- 🎬 Hero animations for smooth transitions
- 🔢 Formatted numbers and dates (stars, forks, etc.)

### 🔧 Smart Sorting
- ⭐ Sort by stars (ascending/descending)
- 📅 Sort by last updated (ascending/descending)
- 💾 Persistent sort preferences
- 🔄 Sort preferences restored on app launch

### 📱 Rich Repository Details
- ⭐ Stars, forks, watchers, and open issues count
- 📋 Repository description and topics
- 📜 License information
- 🔗 Homepage and repository links
- 👤 Owner information with cached avatars
- 📅 Created and updated timestamps

---

## 📸 Screenshots

> Add your app screenshots here

---

## 🛠️ Tech Stack

### **Framework & Language**
- **Flutter** 3.38+
- **Dart** 3.10+

### **State Management & Navigation**
- **GetX** 4.6.6 - State management, dependency injection, and routing

### **UI & Theming**
- **flutter_screenutil** 5.9.3 - Responsive sizing
- **skeletonizer** 2.1.1 - Loading skeleton screens
- Custom Material 3 themes with dark/light mode

### **Networking & Data**
- **http** 1.2.2 - HTTP requests
- **sqflite** 2.3.3 - Local SQLite database
- **get_storage** 2.1.1 - Key-value storage for preferences
- **connectivity_plus** 6.0.5 - Network connectivity monitoring

### **Performance & Caching**
- **cached_network_image** 3.4.1 - Image caching
- **flutter_cache_manager** 3.4.1 - Custom cache management
- **compute()** - Isolate-based JSON parsing

### **Utilities**
- **path** 1.9.0 & **path_provider** 2.1.4 - File system access
- **intl** 0.20.1 - Internationalization and formatting
- **url_launcher** 6.3.1 - Opening external URLs

### **Development**
- **flutter_lints** 6.0.0 - Recommended linting rules

---

## 📦 Prerequisites

Before you begin, ensure you have the following installed:

1. **Flutter SDK** (3.38 or higher)
   - Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
   - Verify installation: `flutter --version`

2. **Dart SDK** (3.10.4 or higher)
   - Bundled with Flutter SDK

3. **Android Studio** or **VS Code** with Flutter extensions

4. **Git** for version control

5. **Android/iOS Development Tools**:
   - **Android**: Android SDK, Android Studio
   - **iOS**: Xcode (macOS only)

---

## 🚀 Installation

### **Step 1: Clone the Repository**

```bash
git clone https://github.com/istiaksaif/flutter-github-repository-explorer.git
cd flutter-github-repository-explorer
```

### **Step 2: Install Dependencies**

```bash
flutter pub get
```

This will install all dependencies listed in `pubspec.yaml`.

### **Step 3: Verify Flutter Setup**

```bash
flutter doctor
```

Ensure all necessary components are installed. Fix any issues reported.

### **Step 4: Run the Application**

#### **On Android Emulator/Device:**
```bash
flutter run
```

#### **On iOS Simulator/Device (macOS only):**
```bash
flutter run
```

#### **On Web:**
```bash
flutter run -d chrome
```

#### **Build Release APK (Android):**
```bash
flutter build apk --release
```

#### **Build Release App Bundle (Android):**
```bash
flutter build appbundle --release
```

#### **Build iOS App (macOS only):**
```bash
flutter build ios --release
```

---

## 📁 Project Structure

The project follows **feature-first Clean Architecture** principles:

```
flutter_github_repository_explorer/
├── lib/
│   ├── core/                           # Core functionality shared across features
│   │   ├── bindings/
│   │   │   └── initial_binding.dart    # Initial GetX dependencies
│   │   ├── constants/
│   │   │   ├── api_constants.dart      # API endpoints and configurations
│   │   │   └── storage_keys.dart       # Storage key constants
│   │   ├── database/
│   │   │   └── app_database.dart       # SQLite database setup
│   │   ├── network/
│   │   │   └── network_info.dart       # Connectivity checker
│   │   ├── services/
│   │   │   └── api_client.dart         # HTTP client wrapper
│   │   ├── utils/
│   │   │   ├── app_colors.dart         # Color palette
│   │   │   ├── app_failure.dart        # Error handling
│   │   │   ├── app_fonts.dart          # Typography
│   │   │   ├── custom_cache_manager.dart # Image caching
│   │   │   ├── date_formatter.dart     # Date formatting utilities
│   │   │   └── session_manager.dart    # Session management
│   │   └── widgets/
│   │       ├── custom_app_bar.dart     # Reusable app bar
│   │       ├── image_loader.dart       # Cached image widget
│   │       └── shimmer_list.dart       # Skeleton loader
│   │
│   ├── features/
│   │   └── repositories/               # GitHub repositories feature
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   ├── local/
│   │       │   │   │   └── github_local_data_source.dart
│   │       │   │   └── remote/
│   │       │   │       └── github_remote_data_source.dart
│   │       │   ├── models/
│   │       │   │   └── repository_model.dart  # Data model with JSON parsing
│   │       │   └── repositories/
│   │       │       ├── github_repository_impl.dart
│   │       │       └── sort_preference_repository_impl.dart
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   ├── repository_entity.dart  # Pure Dart entity
│   │       │   │   └── sort_option.dart
│   │       │   ├── repositories/
│   │       │   │   ├── github_repository.dart  # Repository contract
│   │       │   │   └── sort_preference_repository.dart
│   │       │   └── usecases/
│   │       │       ├── get_repositories_usecase.dart
│   │       │       ├── get_repository_details_usecase.dart
│   │       │       ├── load_sort_preference_usecase.dart
│   │       │       └── save_sort_preference_usecase.dart
│   │       └── presentation/
│   │           ├── bindings/
│   │           │   └── repository_bindings.dart  # Feature dependencies
│   │           ├── controllers/
│   │           │   ├── repository_details_controller.dart
│   │           │   └── repository_list_controller.dart
│   │           ├── pages/
│   │           │   ├── repository_details_page.dart
│   │           │   └── repository_list_page.dart
│   │           └── widgets/
│   │               └── repository_tile.dart
│   │
│   ├── routes/
│   │   ├── app_pages.dart              # GetX page definitions
│   │   └── app_routes.dart             # Route constants
│   │
│   └── main.dart                        # App entry point
│
├── android/                             # Android-specific files
├── ios/                                 # iOS-specific files
├── web/                                 # Web-specific files
├── test/                                # Unit and widget tests
├── pubspec.yaml                         # Project dependencies
└── README.md                            # This file
```

---

## 🏗️ Architecture

This project implements **Clean Architecture** with clear separation of concerns:

### **Layers**

1. **Presentation Layer** (`presentation/`)
   - UI pages and widgets
   - GetX controllers for state management
   - Feature-specific bindings for dependency injection

2. **Domain Layer** (`domain/`)
   - Pure Dart entities (no Flutter dependencies)
   - Repository interfaces (contracts)
   - Use cases (business logic)

3. **Data Layer** (`data/`)
   - Repository implementations
   - Data sources (remote API, local database)
   - Data models with JSON serialization

### **Design Patterns**

- **Repository Pattern**: Abstracts data sources
- **Dependency Injection**: GetX bindings for loose coupling
- **Use Case Pattern**: Single responsibility business logic
- **Observer Pattern**: GetX reactive state management

---

## 🔄 Data Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                        Presentation Layer                        │
│  ┌──────────────────┐         ┌─────────────────────────────┐  │
│  │  UI Pages/Widgets│ ◄─────► │  GetX Controllers           │  │
│  └──────────────────┘         └─────────────────────────────┘  │
└────────────────────────────────────┬────────────────────────────┘
                                     │
                                     ▼
┌─────────────────────────────────────────────────────────────────┐
│                         Domain Layer                             │
│  ┌──────────────────┐         ┌─────────────────────────────┐  │
│  │  Use Cases       │ ◄─────► │  Repository Interfaces      │  │
│  │  (Business Logic)│         │  (Contracts)                │  │
│  └──────────────────┘         └─────────────────────────────┘  │
└────────────────────────────────────┬────────────────────────────┘
                                     │
                                     ▼
┌─────────────────────────────────────────────────────────────────┐
│                          Data Layer                              │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │           Repository Implementations                       │  │
│  │  ┌──────────────────┐         ┌───────────────────────┐  │  │
│  │  │ Remote Data Source│ ◄─────►│ Local Data Source    │  │  │
│  │  │ (GitHub API)     │         │ (SQLite Database)    │  │  │
│  │  └──────────────────┘         └───────────────────────┘  │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### **Request Flow**

1. **User Action** → UI triggers controller method
2. **Controller** → Calls appropriate use case
3. **Use Case** → Executes business logic via repository interface
4. **Repository** → Determines data source (cache or API)
5. **Data Source** → Fetches from network or local database
6. **Response** → Flows back through layers with proper error handling
7. **UI Update** → Controller updates reactive state, UI rebuilds

### **Caching Strategy**

- First fetch attempts from remote API
- Successful data is cached in SQLite
- Last sync timestamp stored in GetStorage
- If last sync < 24 hours, use cache
- Offline mode automatically uses cached data
- Pull-to-refresh forces API fetch

---

## 📱 Usage

### **Home Screen**

- View list of top 50 Flutter repositories
- Pull down to refresh data
- Scroll to bottom for pagination
- Tap sort icon to change sort order
- Tap repository card for details

### **Sort Options**

- **Stars:** Ascending ⬆️ / Descending ⬇️
- **Updated:** Ascending ⬆️ / Descending ⬇️
- Preference is saved automatically

### **Repository Details**

- View comprehensive repository information
- Tap GitHub icon to open repository
- Tap homepage icon to visit project website
- View topics, license, and statistics

### **Offline Mode**

- App automatically detects connectivity
- Shows offline banner when disconnected
- Uses cached data seamlessly
- Refreshes when connection restored

---

## 🧪 Testing

### **Run All Tests**
```bash
flutter test
```

### **Run Tests with Coverage**
```bash
flutter test --coverage
```

### **Code Analysis**
```bash
flutter analyze
```

### **Format Code**
```bash
flutter format .
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Istiak Saif**

- GitHub: [@istiaksaif](https://github.com/istiaksaif)

---

## 🙏 Acknowledgments

- GitHub API for providing free access to repository data
- Flutter and Dart teams for the amazing framework
- Open source community for the excellent packages

---

<div align="center">

**Made with ❤️ using Flutter**

If you find this project helpful, please consider giving it a ⭐!

</div>
