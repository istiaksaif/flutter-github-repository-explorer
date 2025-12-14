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

  void _openMenu(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx + 16.w,
        offset.dy + kToolbarHeight + 12.h,
        16.w,
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
              SizedBox(height: 12.h),
              _SortToolbar(controller: controller),
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

class _SortToolbar extends StatelessWidget {
  const _SortToolbar({required this.controller});

  final RepositoryListController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Icon(Icons.tune, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _ChoiceChip<SortField>(
                  label: 'Stars',
                  value: SortField.stars,
                  groupValue: controller.sortPreference.value.field,
                  onSelected: (value) => controller.updateSort(
                    value,
                    controller.sortPreference.value.order,
                  ),
                ),
                _ChoiceChip<SortField>(
                  label: 'Updated',
                  value: SortField.updatedAt,
                  groupValue: controller.sortPreference.value.field,
                  onSelected: (value) => controller.updateSort(
                    value,
                    controller.sortPreference.value.order,
                  ),
                ),
                _ChoiceChip<SortOrder>(
                  label: 'Asc',
                  value: SortOrder.ascending,
                  groupValue: controller.sortPreference.value.order,
                  onSelected: (value) => controller.updateSort(
                    controller.sortPreference.value.field,
                    value,
                  ),
                ),
                _ChoiceChip<SortOrder>(
                  label: 'Desc',
                  value: SortOrder.descending,
                  groupValue: controller.sortPreference.value.order,
                  onSelected: (value) => controller.updateSort(
                    controller.sortPreference.value.field,
                    value,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () => _openBottomSheet(context),
          ),
        ],
      ),
    );
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sorting',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 12.h),
              Text('Field', style: TextStyle(fontSize: 13.sp)),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                children: [
                  _ChoiceChip<SortField>(
                    label: 'Stars',
                    value: SortField.stars,
                    groupValue: controller.sortPreference.value.field,
                    onSelected: (value) => controller.updateSort(
                      value,
                      controller.sortPreference.value.order,
                    ),
                  ),
                  _ChoiceChip<SortField>(
                    label: 'Last Updated',
                    value: SortField.updatedAt,
                    groupValue: controller.sortPreference.value.field,
                    onSelected: (value) => controller.updateSort(
                      value,
                      controller.sortPreference.value.order,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text('Order', style: TextStyle(fontSize: 13.sp)),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                children: [
                  _ChoiceChip<SortOrder>(
                    label: 'Ascending',
                    value: SortOrder.ascending,
                    groupValue: controller.sortPreference.value.order,
                    onSelected: (value) => controller.updateSort(
                      controller.sortPreference.value.field,
                      value,
                    ),
                  ),
                  _ChoiceChip<SortOrder>(
                    label: 'Descending',
                    value: SortOrder.descending,
                    groupValue: controller.sortPreference.value.order,
                    onSelected: (value) => controller.updateSort(
                      controller.sortPreference.value.field,
                      value,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChoiceChip<T> extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onSelected,
  });

  final String label;
  final T value;
  final T groupValue;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final bool selected = value == groupValue;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 12.sp)),
      selected: selected,
      onSelected: (_) => onSelected(value),
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    );
  }
}
