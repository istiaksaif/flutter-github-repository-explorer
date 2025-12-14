import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/bindings/initial_binding.dart';
import 'core/utils/app_colors.dart';
import 'core/utils/app_fonts.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const GithubExplorerApp());
}

class GithubExplorerApp extends StatelessWidget {
  const GithubExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: const TextScaler.linear(1.0)),
          child: GetMaterialApp(
            navigatorKey: Get.key,
            title: 'Flutter GitHub Explorer',
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.home,
            getPages: AppPages.pages,
            initialBinding: InitialBinding(),
            theme: _buildTheme(Brightness.light),
            darkTheme: _buildTheme(Brightness.dark),
            themeMode: ThemeMode.system,
          ),
        );
      },
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
      onPrimary: isDark ? AppColors.darkOnPrimary : AppColors.lightOnPrimary,
      secondary: isDark ? AppColors.darkAccent : AppColors.lightAccent,
      onSecondary: isDark ? AppColors.darkOnPrimary : AppColors.lightOnPrimary,
      error: Colors.red.shade400,
      onError: Colors.white,
      surface: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      onSurface: isDark ? Colors.white : const Color(0xFF0F172A),
      surfaceContainerHighest: isDark
          ? AppColors.darkSurfaceVariant
          : AppColors.lightSurfaceVariant,
      onSurfaceVariant: isDark ? Colors.white70 : const Color(0xFF334155),
      outline: isDark ? Colors.white24 : const Color(0xFFE2E8F0),
      shadow: Colors.black.withValues(
        alpha: isDark ? 0.25 : 0.08,
        red: null,
        green: null,
        blue: null,
      ),
      inverseSurface: isDark ? AppColors.lightSurface : AppColors.darkSurface,
      onInverseSurface: isDark ? const Color(0xFF0F172A) : Colors.white,
      tertiary: isDark ? Colors.tealAccent : Colors.teal,
      onTertiary: isDark ? AppColors.darkOnPrimary : Colors.white,
      surfaceTint: Colors.transparent,
      primaryContainer: isDark
          ? AppColors.darkSurfaceVariant
          : AppColors.lightSurfaceVariant,
      onPrimaryContainer: isDark ? Colors.white : const Color(0xFF0F172A),
      secondaryContainer: isDark
          ? AppColors.darkSurface
          : AppColors.lightSurfaceVariant,
      onSecondaryContainer: isDark ? Colors.white : const Color(0xFF0F172A),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      textTheme: AppFonts.textTheme(brightness),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      cardColor: colorScheme.surface,
    );
  }
}
