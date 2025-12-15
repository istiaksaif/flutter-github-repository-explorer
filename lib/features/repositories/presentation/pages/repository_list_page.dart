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
    final preference = controller.sortPreference.value;
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
        _buildMenuItem(
          label: 'Sort by Stars',
          selected: preference.field == SortField.stars,
          onTap: () => controller.updateSort(SortField.stars, preference.order),
        ),
        _buildMenuItem(
          label: 'Sort by Updated',
          selected: preference.field == SortField.updatedAt,
          onTap: () =>
              controller.updateSort(SortField.updatedAt, preference.order),
        ),
        _buildMenuItem(
          label: 'Order Asc',
          selected: preference.order == SortOrder.ascending,
          onTap: () =>
              controller.updateSort(preference.field, SortOrder.ascending),
        ),
        _buildMenuItem(
          label: 'Order Desc',
          selected: preference.order == SortOrder.descending,
          onTap: () =>
              controller.updateSort(preference.field, SortOrder.descending),
        ),
      ],
    );
  }

  PopupMenuItem<void> _buildMenuItem({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return PopupMenuItem<void>(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
            width: 18.sp,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: selected ? 1 : 0,
              child: Icon(
                Icons.check,
                size: 18.sp,
                color: Get.theme.colorScheme.primary,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(label, style: TextStyle(fontSize: 14.sp)),
        ],
      ),
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

          return RefreshIndicator(
            onRefresh: () => controller.loadRepositories(forceRefresh: true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: controller.offlineMode.value
                      ? Container(
                          key: const ValueKey('offline_banner'),
                          width: 1.sw,
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
                    child: Obx(() {
                      final showLoader = controller.isPaginating.value;
                      final itemCount =
                          controller.visibleRepositories.length +
                          (showLoader ? 1 : 0);
                      return ListView.separated(
                        controller: controller.scrollController,
                        key: ValueKey(
                          '${controller.sortPreference.value.field}_${controller.sortPreference.value.order}_${controller.repositories.length}',
                        ),
                        itemCount: itemCount,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10.h),
                        itemBuilder: (context, index) {
                          final isLoaderRow =
                              showLoader && index == itemCount - 1;
                          if (isLoaderRow) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: const Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            );
                          }
                          final repo = controller.visibleRepositories[index];
                          return RepositoryTile(repository: repo);
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
