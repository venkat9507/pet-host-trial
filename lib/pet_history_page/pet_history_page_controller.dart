import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pet_adoption_app/models/pet_hive_data.dart';
import 'package:pet_adoption_app/models/pet_listing_page_data.dart';
import 'package:pet_adoption_app/theme_controller.dart';

class PetAdoptionHistoryPageController extends GetxController {
  late Box<Pet> petBox;
  final petList = <Map<String, dynamic>>[].obs;
  PetListingPageData data = PetListingPageData();
  final themeController = Get.put(ThemeController(), tag: "themeController");
  @override
  void onInit() {
    super.onInit();
    petBox = Hive.box<Pet>('pets');
  }

  @override
  void onReady() {
    super.onReady();
    final petBoxList = petBox.values.toList();
    List<List<Map<String, dynamic>>> petDataListOfList =
        data.petDataList.values.toList();
    final petDataList = petDataListOfList.expand((list) => list).toList();
    for (var datum in petDataList) {
      for (var pet in petBoxList) {
        if (pet.id == datum["id"]) {
          petList.add(datum);
        }
      }
    }
    petList.sort(
      ((item1, item2) {
        String nameStr1 = item1["name"];
        String nameStr2 = item2["name"];
        return nameStr1.toLowerCase().compareTo(nameStr2.toLowerCase());
      }),
    );
  }
}
