import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pet_adoption_app/models/pet_hive_data.dart';
import 'package:pet_adoption_app/pet_details_page/pet_details_interactive_viewer_pop_up.dart';
import 'package:pet_adoption_app/theme_controller.dart';

class PetDetailsPageController extends GetxController {
  String? imgSrc;
  String? name;
  String? id;
  String? age;
  String? price;
  late Box<Pet> petBox;
  final isAdoptBtnActive = false.obs;

  final _confettiController = ConfettiController();
  final themeController = Get.put(ThemeController(), tag: "themeController");
  

  @override
  void onInit() {
    super.onInit();
    petBox = Hive.box<Pet>('pets');
    final params = Get.parameters;
    imgSrc = params["imgSrc"];
    name = params["name"] ?? 'NA';
    id = params["id"];
    age = params["age"] ?? 'NA';
    price = params["price"] ?? 'NA';
    isAdoptBtnActive.value = params['isAdopted'] == "true" ? false : true;
  }

  @override
  void onReady() {
    super.onReady();
    if (imgSrc == null || imgSrc!.isEmpty || id == null || id!.isEmpty) {
      Get.toNamed("/");
      return;
    }
    if (name!.isEmpty) {
      name = 'NA';
    }
    if (age!.isEmpty) {
      age = 'NA';
    }
    if (price!.isEmpty) {
      price = 'NA';
    }
  }

  @override
  void onClose() {
    _confettiController.dispose();
    super.onClose();
  }

  void onAdoptBtnTap(BuildContext context) {
    if (!isAdoptBtnActive.value) return;
    Pet pet = Pet(id!, true);
    petBox.add(pet);
    isAdoptBtnActive.value = false;
    openPopup(context);
  }

  void openPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("You've adopted $name"),
              const SizedBox(height: 16),
              ConfettiWidget(
                blastDirectionality: BlastDirectionality.explosive,
                confettiController: _confettiController,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 25,
                gravity: 0.05,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.red,
                  Colors.yellow,
                  Colors.blue,
                ],
              ),
            ],
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
                _confettiController.stop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).whenComplete(
      () => _confettiController.play(),
    );
  }

  void onImageTap(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PetDetailsInteractiveViewerPopUp(
        imgSrc: imgSrc!,
        stopConfettiController: stopConfettiController,
      ),
    );
  }

  void stopConfettiController() {
    _confettiController.stop();
  }
}
