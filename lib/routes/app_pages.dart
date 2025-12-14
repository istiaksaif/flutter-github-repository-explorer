import 'package:get/get.dart';

import '../features/repositories/presentation/bindings/repository_bindings.dart';
import '../features/repositories/presentation/pages/repository_details_page.dart';
import '../features/repositories/presentation/pages/repository_list_page.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.home,
      page: () => RepositoryListPage(),
      binding: RepositoryListBinding(),
    ),
    GetPage(
      name: AppRoutes.repositoryDetails,
      page: () => const RepositoryDetailsPage(),
      binding: RepositoryDetailsBinding(),
    ),
  ];
}
