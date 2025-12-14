import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager extends CacheManager {
  CustomCacheManager._()
    : super(
        Config(
          key,
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 20000,
        ),
      );

  static const String key = 'customCache';
  static final CacheManager instance = CustomCacheManager._();
}
