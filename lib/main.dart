import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pet_adoption_app/models/pet_hive_adapter.dart';
import 'package:pet_adoption_app/models/pet_hive_data.dart';
import 'package:pet_adoption_app/pet_details_page/pet_details_page.dart';
import 'package:pet_adoption_app/pet_details_page/pet_details_page_controller.dart';
import 'package:pet_adoption_app/pet_history_page/pet_history_page.dart';
import 'package:pet_adoption_app/pet_listing_page/pet_listing_page.dart';
import 'package:pet_adoption_app/pet_listing_page/pet_listing_page_controller.dart';
import 'package:pet_adoption_app/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PetAdapter());
  await Hive.openBox<Pet>('pets');
  await Hive.openBox<String>('theme');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final themeController = Get.put(
    ThemeController(),
    tag: "themeController",
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pet Adoption Web App',
        initialRoute: "/",
        theme: themeController.currentTheme.value,
        getPages: [
          GetPage(
            name: "/",
            page: () => PetListingPage(),
            binding: BindingsBuilder(
              () => Get.create(
                () => PetListingPageController(),
              ),
            ),
          ),
          GetPage(
            name: "/pet-details-page",
            page: () => PetDetailsPage(),
            binding: BindingsBuilder(
              () => Get.create(
                () => PetDetailsPageController(),
              ),
            ),
          ),
          GetPage(
            name: "/pet-adoption-history",
            page: () => PetAdoptionHistoryPage(),
          ),
        ],
      );
    });
  }
}
