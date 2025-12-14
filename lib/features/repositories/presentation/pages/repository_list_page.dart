import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../domain/entities/sort_option.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/shimmer_list.dart';
import '../controllers/repository_list_controller.dart';
import '../widgets/repository_tile.dart';

class RepositoryListPage extends GetView<RepositoryListController> {
  const RepositoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Flutter GitHub Explorer',
        actions: [
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
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _SortDropdown<SortField>(
                      label: 'Sort by',
                      value: controller.sortPreference.value.field,
                      items: const {
                        SortField.stars: 'Stars',
                        SortField.updatedAt: 'Last Updated',
                      },
                      onChanged: (value) {
                        if (value != null) {
                          controller.updateSort(
                            value,
                            controller.sortPreference.value.order,
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _SortDropdown<SortOrder>(
                      label: 'Order',
                      value: controller.sortPreference.value.order,
                      items: const {
                        SortOrder.descending: 'Descending',
                        SortOrder.ascending: 'Ascending',
                      },
                      onChanged: (value) {
                        if (value != null) {
                          controller.updateSort(
                            controller.sortPreference.value.field,
                            value,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
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

class _SortDropdown<T> extends StatelessWidget {
  const _SortDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T value;
  final Map<T, String> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: DropdownButton<T>(
            isExpanded: true,
            value: value,
            underline: const SizedBox.shrink(),
            items: items.entries
                .map(
                  (entry) => DropdownMenuItem<T>(
                    value: entry.key,
                    child: Text(entry.value, style: TextStyle(fontSize: 13.sp)),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
