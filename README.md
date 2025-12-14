# Flutter GitHub Repository Explorer

Feature-first Clean Architecture Flutter app that searches GitHub for the top starred **Flutter** repositories, supports offline browsing with SQLite cache, and persists sorting preferences with GetStorage. Built with GetX, ScreenUtil, SQLite, and GitHub Search API.

## Highlights
- Fetch top 50 GitHub repos (query: Flutter) sorted by stars; caches into SQLite and auto-falls back offline.
- Sort by stars or last updated, ascending/descending; preference persisted in GetStorage and restored on launch.
- GetX for state, DI, routing; ScreenUtil for responsive sizing; pull-to-refresh + infinite scroll pagination.
- Cached owner avatars with `cached_network_image` + custom cache manager.
- Light/dark themes with custom palette and typography; UI-safe text scaling locked at 1.0.
- Repo details show stars/forks/watchers/issues, license, homepage, topics, and hero avatar.
- Pure Dart domain layer (no Flutter imports) with feature-first Clean Architecture.

## Tech Stack
- Flutter 3.38+, Dart 3.10+
- GetX (state/DI/routing), flutter_screenutil
- http + custom ApiClient, compute() JSON parsing
- sqflite + path_provider (offline cache)
- get_storage (preferences)
- cached_network_image + flutter_cache_manager
- skeletonizer (loading skeletons), connectivity_plus, intl

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
- Network: `lib/core/network/network_info.dart`, `lib/core/services/api_client.dart`
- Theme: `lib/core/utils/app_colors.dart`, `lib/core/utils/app_fonts.dart`
- Feature entry: `lib/features/repositories/presentation/pages/repository_list_page.dart`
- Details: `lib/features/repositories/presentation/pages/repository_details_page.dart`
- Controllers: `lib/features/repositories/presentation/controllers/`
- Cache manager: `lib/core/utils/custom_cache_manager.dart`
- Image loader: `lib/core/widgets/image_loader.dart`

## Data Flow
1) `GithubRemoteDataSource` -> GitHub Search API (`Flutter`, stars desc, per_page=50) via `ApiClient`.
2) `GithubRepositoryImpl` caches into SQLite via `GithubLocalDataSource`; last-sync persisted in GetStorage.
3) Offline/failed fetch falls back to cached rows; cache reused if last sync < 24h unless force refresh.
4) Sorting is applied in `GetRepositoriesUseCase`, saved/loaded with `SortPreferenceRepository` (GetStorage).
5) UI consumes GetX controllers; navigation via named routes only.
6) Pagination: controllers maintain visible list and load more on scroll end; pull-to-refresh reloads from API/cache.

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
- Offline banner appears when no connectivity is detected.
- Loading states use skeleton cards aligned to live card layout; avatars are cached; hero animations between list/detail.
- SQLite schema includes forks/watchers/issues/topics/license/homepage for richer detail view.```
