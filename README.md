# Flutter GitHub Repository Explorer

Feature-first Clean Architecture Flutter app that searches GitHub for the top starred **Flutter** repositories, supports offline browsing with SQLite cache, and persists sorting preferences with GetStorage.

## Highlights
- Fetch top 50 GitHub repos (query: Flutter) sorted by stars; falls back to SQLite cache when offline.
- Sort by stars or last updated, ascending/descending; preference restored on relaunch.
- GetX for state management, DI, routing; ScreenUtil for responsive sizing.
- Cached owner avatars via `cached_network_image` + custom cache manager.
- Pure Dart domain layer (no Flutter imports) following Clean Architecture.

## Tech Stack
- Flutter 3.38+, Dart 3.10+
- GetX, flutter_screenutil, http
- sqflite + path_provider (offline cache)
- get_storage (preferences)
- cached_network_image + flutter_cache_manager
- connectivity_plus, intl

## Structure (feature-first)
```
lib/
  core/             // constants, network info, database, utils, shared widgets
  routes/           // named routes + page definitions
  features/
    repositories/   // data, domain, presentation for GitHub repos
  main.dart         // app bootstrap, ScreenUtil, GetMaterialApp
```

## Key Paths
- Routing: `lib/routes/app_routes.dart`, `lib/routes/app_pages.dart`
- Database: `lib/core/database/app_database.dart`
- Network info: `lib/core/network/network_info.dart`
- Repository feature entry: `lib/features/repositories/presentation/pages/repository_list_page.dart`
- Details page: `lib/features/repositories/presentation/pages/repository_details_page.dart`
- Controllers: `lib/features/repositories/presentation/controllers/`
- Cache manager: `lib/core/utils/custom_cache_manager.dart`
- Image loader: `lib/core/widgets/image_loader.dart`
- App bar: `lib/core/widgets/custom_app_bar.dart`

## Data Flow
1) `GithubRemoteDataSource` hits `https://api.github.com/search/repositories?q=Flutter&sort=stars&order=desc&per_page=50`.
2) `GithubRepositoryImpl` caches results into SQLite via `GithubLocalDataSource`.
3) Offline/failed fetch falls back to cached rows.
4) Sorting is applied in `GetRepositoriesUseCase` and saved/loaded with `SortPreferenceRepository` (GetStorage).
5) UI consumes GetX controllers; navigation via named routes only.

## Running
- Install Flutter, then:
  - `flutter pub get`
  - `flutter run`

## Testing & Lint
- `flutter analyze`
- `flutter test`

## Notes
- Responsive sizing uses `.w`, `.h`, `.sp` via ScreenUtil (`designSize` 375x812).
- Text scaling clamped to 1.0 in `main.dart` for consistent layout.
- Offline banner appears when no connectivity is detected.```
