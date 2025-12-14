import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/custom_cache_manager.dart';

class ImageLoader extends StatelessWidget {
  const ImageLoader({
    super.key,
    required this.url,
    this.size,
    this.shape = BoxShape.circle,
  });

  final String url;
  final double? size;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final dimension = size ?? 56.w;
    final placeholder = Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        shape: shape,
      ),
      child: Icon(Icons.person, size: (dimension * 0.6).sp),
    );

    if (url.isEmpty) return placeholder;

    final radius = shape == BoxShape.circle
        ? BorderRadius.circular(dimension)
        : null;
    return ClipRRect(
      borderRadius: radius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: url,
        width: dimension,
        height: dimension,
        fit: BoxFit.cover,
        cacheManager: CustomCacheManager.instance,
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, dynamic error) => placeholder,
      ),
    );
  }
}
