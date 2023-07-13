import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pet_adoption_app/app_toast.dart';
import 'package:pet_adoption_app/debouncer.dart';
import 'package:pet_adoption_app/models/pet_hive_data.dart';
import 'package:pet_adoption_app/models/pet_listing_page_data.dart';
import 'package:pet_adoption_app/theme_controller.dart';

class PetListingPageController extends GetxController {
  PetListingPageData data = PetListingPageData();
  final themeController = Get.find<ThemeController>(tag: "themeController");
  List<String> filterKeys = [];
  List<Map<String, String>> filterNames = [];
  List<Map<String, dynamic>> dogList = [];
  List<Map<String, dynamic>> catList = [];
  final filteredList = <Map<String, dynamic>>[].obs;
  final searchedList = <Map<String, dynamic>>[];
  int page = 1;
  int pageSize = 10;
  final selectedFilter = "All".obs;
  final searchedQuery = "".obs;

  final isOnLoadMoreActive = true.obs;
  final downloadImageUrl = "".obs;

  // false for dark mode true for light mode
  final theme = false.obs;


  late Box<Pet> petBox;
  final debouncer = Debouncer(milliseconds: 500);
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    petBox = Hive.box<Pet>('pets');
    theme.value = !themeController.isDarkMode;
    final keyList = data.petDataList.keys.toList();
    if (keyList.length > 1) {
      filterKeys.add("All");
      filterNames.add({"All": "All"});
    }
    filterKeys.addAll(data.petDataList.keys);
    filterNames.add({"dogData": "Dogs"});
    filterNames.add({"catData": "Cats"});
    dogList.assignAll(data.petDataList["dogData"]!.toList());
    catList.assignAll(data.petDataList["catData"]!.toList());
    filteredList.assignAll(dogList.take(pageSize));
    if (filteredList.length < 10) {
      int count = 10 - filteredList.length;
      filteredList.assignAll(catList.take(count));
    }
    int totalListLength = dogList.length + catList.length;
    if (filteredList.length == totalListLength) {
      isOnLoadMoreActive.value = false;
    }
    page++;
  }

  @override
  void onReady() {
    super.onReady();
    makeImageBlur();
  }

  @override
  void onClose() {
    petBox.close();
    Hive.close();
    super.onClose();
  }

  void onImageTap(Map<String, dynamic> parameterData) async {
    const basePath = kDebugMode ? '' : 'assets/';
    Map<String, String> params = {
      "id": parameterData["id"],
      "name": parameterData["name"],
      "age": parameterData["age"],
      "price": parameterData["price"],
      "imgSrc": basePath + parameterData["imgSrc"],
    };

    final petList = petBox.values.toList();
    final isPetPresent = petList
        .firstWhereOrNull((element) => element.id == parameterData["id"]);
    if (isPetPresent != null) {
      params.addAll({"isAdopted": "true"});
    }
    await Get.toNamed(
      "/pet-details-page",
      parameters: params,
    );
    makeImageBlur();
  }

  void makeImageBlur() {
    final list = filteredList.toList();
    final petBoxList = petBox.values.toList();
    for (var datum in list) {
      for (var petHiveDatum in petBoxList) {
        if (datum["id"] == petHiveDatum.id) {
          datum["isAdopted"].value = petHiveDatum.isAdopted;
        }
      }
    }
    filteredList.assignAll(list);
  }

  List<Map<String, dynamic>> getUpdatedList() {
    List<Map<String, dynamic>> list = [];
    if (selectedFilter.value == "dogData") {
      list.assignAll(dogList);
    } else if (selectedFilter.value == "catData") {
      list.assignAll(catList);
    } else {
      list.addAll(dogList);
      list.addAll(catList);
    }
    return list;
  }

  void onSearch(String query) {
    query = query.trim();
    searchedQuery.value = query;
    if (query.isEmpty) {
      final list = getUpdatedList();
      filteredList.assignAll(list.take(pageSize));
      if (filteredList.length == list.length) {
        isOnLoadMoreActive.value = false;
      } else {
        isOnLoadMoreActive.value = true;
      }
      page = 2;
      return;
    }
    debouncer.run(() {
      final list = <Map<String, dynamic>>[];
      final searchList = getUpdatedList();
      for (var item in searchList) {
        String itemName = item["name"];
        if (itemName.toLowerCase().contains(query)) {
          list.add(item);
        }
      }
      searchedList.assignAll(list);
      filteredList.assignAll(list.take(pageSize));
      if (filteredList.length == list.length) {
        isOnLoadMoreActive.value = false;
      } else {
        isOnLoadMoreActive.value = true;
      }
      page = 2;
    });
  }

  void onFilterTap(String filter) {
    if (filter == selectedFilter.value) return;
    selectedFilter.value = filter;
    searchController.clear();
    getDataBasisFilter();
  }

  void getDataBasisFilter() {
    page = 1;
    final list = getUpdatedList();
    filteredList.assignAll(list.take(pageSize));
    if (filteredList.length == list.length) {
      isOnLoadMoreActive.value = false;
    } else {
      isOnLoadMoreActive.value = true;
    }
    page = 2;
  }

  void onLoadMore() {
    if (!isPaginationAllowed()) {
      AppToast.showAppToast("No more content");
      return;
    }
    searchController.clear();
    final list = getUpdatedList();
    filteredList.addAll(list.skip((page - 1) * pageSize).take(pageSize));
    page++;
  }

  bool isPaginationAllowed() {
    final list = getUpdatedList();
    if (filteredList.length == list.length) {
      isOnLoadMoreActive.value = false;
    } else {
      isOnLoadMoreActive.value = true;
    }
    return filteredList.length < list.length ? true : false;
  }

  void onHistoryBtnTap() {
    Get.toNamed("/pet-adoption-history");
  }

  void onThemeChange(bool value) {
    theme.value = value;
    if (value) {
      themeController.setThemeMode(ThemeMode.light);
      return;
    }
    themeController.setThemeMode(ThemeMode.dark);
  }
}
