import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/repository_entity.dart';
import '../../../../routes/app_routes.dart';

class RepositoryTile extends StatelessWidget {
  const RepositoryTile({super.key, required this.repository});

  final RepositoryEntity repository;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: () =>
          Get.toNamed(AppRoutes.repositoryDetails, arguments: repository),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              repository.name,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(Icons.account_circle_outlined, size: 16.sp),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    repository.ownerName,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.star, size: 16.sp, color: Colors.amber.shade700),
                SizedBox(width: 4.w),
                Text(
                  repository.stargazersCount.toString(),
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(width: 12.w),
                Icon(Icons.update, size: 16.sp),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    DateFormatter.formatCompact(repository.updatedAt),
                    style: TextStyle(fontSize: 13.sp),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
