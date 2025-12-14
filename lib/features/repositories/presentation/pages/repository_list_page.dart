import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/shimmer_list.dart';
import '../controllers/repository_list_controller.dart';
import '../widgets/repository_tile.dart';
import '../../domain/entities/sort_option.dart';

class RepositoryListPage extends GetView<RepositoryListController> {
  RepositoryListPage({super.key});

  final GlobalKey _menuKey = GlobalKey();

  void _openMenu(BuildContext context) {
    final renderBox = _menuKey.currentContext?.findRenderObject() as RenderBox?;
    final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    final size = renderBox?.size ?? Size.zero;
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        0,
      ),
      items: [
        PopupMenuItem(
          child: const Text('Sort by Stars'),
          onTap: () => controller.updateSort(
            SortField.stars,
            controller.sortPreference.value.order,
          ),
        ),
        PopupMenuItem(
          child: const Text('Sort by Updated'),
          onTap: () => controller.updateSort(
            SortField.updatedAt,
            controller.sortPreference.value.order,
          ),
        ),
        PopupMenuItem(
          child: const Text('Order Asc'),
          onTap: () => controller.updateSort(
            controller.sortPreference.value.field,
            SortOrder.ascending,
          ),
        ),
        PopupMenuItem(
          child: const Text('Order Desc'),
          onTap: () => controller.updateSort(
            controller.sortPreference.value.field,
            SortOrder.descending,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Flutter GitHub Explorer',
        actions: [
          IconButton(
            key: _menuKey,
            icon: const Icon(Icons.tune),
            onPressed: () => _openMenu(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadRepositories,
          ),
          SizedBox(width: 6.w),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const ShimmerList(itemCount: 6);
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.errorMessage.value,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: controller.loadRepositories,
                    child: Text('Retry', style: TextStyle(fontSize: 14.sp)),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: controller.offlineMode.value
                    ? Container(
                        key: const ValueKey('offline_banner'),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.wifi_off),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'Offline mode: showing cached repositories',
                                style: TextStyle(fontSize: 13.sp),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: ListView.separated(
                    key: ValueKey(
                      '${controller.sortPreference.value.field}_${controller.sortPreference.value.order}_${controller.repositories.length}',
                    ),
                    itemCount: controller.visibleRepositories.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      controller.loadMoreIfNeeded(index);
                      final repo = controller.visibleRepositories[index];
                      return RepositoryTile(repository: repo);
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
