import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_adoption_app/app_toast.dart';

class PetDetailsInteractiveViewerPopUpController extends GetxController {
  double minScale = 1.0;
  double maxScale = 1.0;
  final isShowPlusIcon = true.obs;
  final isShowMinusIcon = false.obs;

  final transformationController = TransformationController();

  void onZoomIn() {
    if (minScale >= 4.5) {
      isShowPlusIcon.value = false;
      AppToast.showAppToast("Can't zoom in further");
      return;
    }
    minScale += 0.1;
    transformationController.value =
        Matrix4.diagonal3Values(minScale, minScale, 0.1);

    maxScale = minScale;
    isShowMinusIcon.value = true;
  }

  void onZoomOut() {
    if (maxScale == 1.0) {
      isShowMinusIcon.value = false;
      AppToast.showAppToast("Can't zoom out further");
      return;
    }

    maxScale -= 0.1;
    transformationController.value =
        Matrix4.diagonal3Values(maxScale, maxScale, 0.1);

    minScale = maxScale;
    isShowPlusIcon.value = true;
  }
}
