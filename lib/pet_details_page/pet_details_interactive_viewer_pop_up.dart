import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_adoption_app/pet_details_page/pet_details_pop_up_controller.dart';
import 'package:pet_adoption_app/theme_controller.dart';

class PetDetailsInteractiveViewerPopUp extends StatelessWidget {
  PetDetailsInteractiveViewerPopUp({
    Key? key,
    required this.imgSrc,
    required this.stopConfettiController,
  }) : super(key: key);

  String imgSrc;
  final VoidCallback stopConfettiController;

  final controller = Get.put(PetDetailsInteractiveViewerPopUpController());
  final themeController = Get.put(ThemeController(), tag: "themeController");

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: const Text("Zoom me in/out")),
          Obx(() {
            final isShowPlusIcon = controller.isShowPlusIcon.value;
            final isShowMinusIcon = controller.isShowMinusIcon.value;
            final darkModePlusIconColor =
                isShowPlusIcon ? Colors.white : Colors.grey.shade400;
            final lightModePlusIconColor =
                isShowPlusIcon ? Colors.black : Colors.grey.shade400;
            final darkModeMinusIconColor =
                isShowMinusIcon ? Colors.white : Colors.grey.shade400;
            final lightModeMinusIconColor =
                isShowMinusIcon ? Colors.black : Colors.grey.shade400;
            return Row(
              children: [
                InkWell(
                  onTap: controller.onZoomIn,
                  child: Icon(
                    Icons.add_outlined,
                    color: themeController.isDarkMode
                        ? darkModePlusIconColor
                        : lightModePlusIconColor,
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: controller.onZoomOut,
                  child: Icon(
                    Icons.remove,
                    color: themeController.isDarkMode
                        ? darkModeMinusIconColor
                        : lightModeMinusIconColor,
                  ),
                ),
              ],
            );
          })
        ],
      ),
      content: InteractiveViewer(
        transformationController: controller.transformationController,
        minScale: 1,
        maxScale: 5,
        boundaryMargin: const EdgeInsets.all(20),
        child: Image.asset(
          imgSrc,
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            'Close',
            style: TextStyle(
              color: themeController.isDarkMode
                  ? Colors.white
                  : Colors.grey.shade400,
            ),
          ),
          onPressed: () {
            stopConfettiController();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
