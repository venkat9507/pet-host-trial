import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_adoption_app/pet_details_page/pet_details_page_controller.dart';

class PetDetailsPage extends StatelessWidget {
  PetDetailsPage({Key? key}) : super(key: key);

  final controller = Get.find<PetDetailsPageController>();

  @override
  Widget build(BuildContext context) {
    if (controller.imgSrc == null &&
        controller.imgSrc!.isEmpty &&
        controller.id == null &&
        controller.id!.isEmpty) return const SizedBox.shrink();
    return Scaffold(
      appBar: AppBar(title: const Text("Pet Details Page")),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Obx(
          () {
            final isAdoptBtnActive = controller.isAdoptBtnActive.value;
            
            return Center(
              child: Card(
                color: controller.themeController.isDarkMode
                    ? Color(0xFF808080)
                    : Color(0xFFD1D1D1),
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Hero(
                            tag: controller.imgSrc!,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => controller.onImageTap(context),
                                child: Container(
                                  width: 400,
                                  height: 400,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        controller.imgSrc!,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller.name!),
                              Text("Age : " + controller.age!),
                              Text(
                                  "Price : \$ " + controller.price!.toString()),
                              const SizedBox(height: 12),
                              InkWell(
                                onTap: () => controller.onAdoptBtnTap(context),
                                child: Container(
                                  width: 320,
                                  height: 28,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    color: isAdoptBtnActive
                                        ? controller.themeController.isDarkMode
                                            ? Color(0xff303030)
                                            : Color(0xffA1A1A1)
                                        : Colors.transparent,
                                  ),
                                  child: Center(
                                    child: Text(
                                      isAdoptBtnActive
                                          ? "Adopt me!"
                                          : "Already adopted",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
