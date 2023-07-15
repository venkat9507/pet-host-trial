import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pet_adoption_app/pet_listing_page/pet_listing_page_controller.dart';

class PetListingPage extends StatelessWidget {
  PetListingPage({Key? key}) : super(key: key);

  final controller = Get.find<PetListingPageController>();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      final width = constraints.maxWidth;
      return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text("Pet Listing Page"),
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/moon.svg",
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 4),
                    Obx(() {
                      return Switch(
                        value: controller.theme.value,
                        onChanged: controller.onThemeChange,
                      );
                    }),
                    SizedBox(width: 4),
                    Icon(Icons.wb_sunny_sharp),
                  ],
                ),
                SizedBox(width: 10),
                Wrap(
                  children: [
                    InkWell(
                      onTap: controller.onHistoryBtnTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: controller.themeController.isDarkMode
                                ? Color(0xff303030)
                                : Color(0x101010),
                            width: 1.0,
                          ),
                          color: controller.themeController.isDarkMode
                              ? Color(0xff303030)
                              : Color(0xFFA1A1A1),
                        ),
                        child: const Text("View adopted pets"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              children: [
                if (width < 530) ...[
                  _buildSearchBox,
                  const SizedBox(height: 10),
                  _buildFilters,
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSearchBox,
                      const SizedBox(width: 12),
                      _buildFilters,
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                Expanded(child: _buildGridView),
                const SizedBox(height: 12),
              ],
            ),
          ));
    });
  }

  Widget get _buildSearchBox {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        controller: controller.searchController,
        onChanged: controller.onSearch,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Search pet name',
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ),
    );
  }

  Widget get _buildFilters {
    return Row(
      children: List.generate(
        controller.filterKeys.length,
        (index) {
          final filter = controller.filterKeys[index];
          final filterName = controller.filterNames[index][filter];
          return Obx(() {
            final selectedFilter = controller.selectedFilter.value;
            final selectedFilterColor =
                controller.theme.value ? Color(0xffA1A1A1) : Color(0xff303030);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: IntrinsicWidth(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => controller.onFilterTap(filter),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        color: filter == selectedFilter
                            ? selectedFilterColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(filterName!),
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget get _buildGridView {
    return Obx(() {
      final list = controller.filteredList.toList();
      if (list.isEmpty) {
        return Text(
          "No search result found for pet name : ${controller.searchedQuery.value}",
        );
      }

      return Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: list.length,
              itemBuilder: (_, index) {
                return _buildPetImage(list, index);
              },
            ),
          ),
          const SizedBox(height: 12),
          _buildLoadMore,
          const SizedBox(height: 12),
        ],
      );
    });
  }

  Widget _buildPetImage(List<Map<String, dynamic>> list, int index) {
    return Obx(() {
      final datum = list[index];
      final isKeepImageBlur = datum["isAdopted"].value;

      return Card(
        color: controller.themeController.isDarkMode
            ? Color(0xFF808080)
            : Color(0xFFD1D1D1),
        elevation: 20,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Hero(
                      tag: datum["imgSrc"],
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => controller.onImageTap(datum),
                          child: Container(
                            width: 400,
                            height: 400,
                            decoration:  BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      AssetImage(datum["imgSrc"].toString())),
                            ),
                            // child: Image.asset('${datum["imgSrc"]}'),
                          ),
                        ),
                      ),
                    ),
                    if (isKeepImageBlur) ...[
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => controller.onImageTap(datum),
                          child: Container(
                            width: 400,
                            height: 400,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      )
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(datum["name"]),
              const SizedBox(height: 2),
              if (isKeepImageBlur) ...[
                const SizedBox(height: 10),
                Text("Already adopted"),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget get _buildLoadMore {
    return Obx(() {
      final buttonColor =
          controller.theme.value ? Color(0xffA1A1A1) : Color(0xff303030);
      final isBtnActive = controller.isOnLoadMoreActive.value;
      return InkWell(
        onTap: controller.onLoadMore,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          child: Text(isBtnActive ? "Load More" : "No more Content"),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            color: isBtnActive ? buttonColor : Colors.transparent,
          ),
        ),
      );
    });
  }
}
