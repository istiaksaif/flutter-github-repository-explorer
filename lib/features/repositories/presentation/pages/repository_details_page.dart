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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ImageLoader(
                    url: repo.ownerAvatarUrl,
                    size: 56.w,
                    shape: BoxShape.circle,
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
              SizedBox(height: 16.h),
              Text(
                repo.description.isNotEmpty
                    ? repo.description
                    : 'No description provided.',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber.shade700, size: 18.sp),
                  SizedBox(width: 6.w),
                  Text(
                    '${repo.stargazersCount} stars',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
