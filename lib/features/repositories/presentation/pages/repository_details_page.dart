import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/image_loader.dart';
import '../controllers/repository_details_controller.dart';

class RepositoryDetailsPage extends GetView<RepositoryDetailsController> {
  const RepositoryDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final repo = controller.repository.value;
          return Text(
            repo?.name ?? 'Repository',
            style: TextStyle(fontSize: 18.sp),
          );
        }),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final repo = controller.repository.value;
          if (repo == null) {
            return Center(
              child: Text(
                controller.errorMessage.value.isNotEmpty
                    ? controller.errorMessage.value
                    : 'Repository unavailable',
                style: TextStyle(fontSize: 14.sp),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'repo_avatar_${repo.id}',
                      child: ImageLoader(
                        url: repo.ownerAvatarUrl,
                        size: 64.w,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            repo.ownerName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            DateFormatter.formatDetail(repo.updatedAt),
                            style: TextStyle(fontSize: 13.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    _InfoChip(
                      icon: Icons.star,
                      label: '${repo.stargazersCount} stars',
                      color: Colors.amber,
                    ),
                    _InfoChip(
                      icon: Icons.call_split,
                      label: '${repo.forksCount} forks',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    _InfoChip(
                      icon: Icons.visibility,
                      label: '${repo.watchersCount} watchers',
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    _InfoChip(
                      icon: Icons.bug_report_outlined,
                      label: '${repo.openIssuesCount} open issues',
                      color: Colors.redAccent,
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                if (repo.licenseName.isNotEmpty)
                  Text(
                    'License: ${repo.licenseName}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (repo.homepage.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  Text(
                    'Homepage: ${repo.homepage}',
                    style: TextStyle(fontSize: 13.sp),
                  ),
                ],
                SizedBox(height: 18.h),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(
                        alpha: 0.2,
                        red: null,
                        green: null,
                        blue: null,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        repo.description.isNotEmpty
                            ? repo.description
                            : 'No description provided.',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                if (repo.topics.isNotEmpty) ...[
                  Text(
                    'Topics',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: repo.topics
                        .map(
                          (t) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(t, style: TextStyle(fontSize: 12.sp)),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.12,
          red: null,
          green: null,
          blue: null,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: 6.w),
          Text(label, style: TextStyle(fontSize: 12.sp)),
        ],
      ),
    );
  }
}
