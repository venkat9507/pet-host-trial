import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_adoption_app/pet_history_page/pet_history_page_controller.dart';

class PetAdoptionHistoryPage extends StatelessWidget {
  PetAdoptionHistoryPage({Key? key}) : super(key: key);

  final controller = Get.put(PetAdoptionHistoryPageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet adoption history page"),
      ),
      body: Obx(() {
        final list = controller.petList;
        if (list.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Text("No data found"),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: CustomScrollView(
            slivers: [
              sliverBox(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                    color: controller.themeController.isDarkMode
                        ? Color(0xff909090)
                        : Color(0xFF757575),
                  ),
                  child: const Row(
                    children: [
                      Expanded(child: SizedBox.shrink()),
                      SizedBox(width: 12),
                      Expanded(child: Text("Name")),
                      SizedBox(width: 12),
                      Expanded(child: Center(child: Text("Age"))),
                      SizedBox(width: 12),
                      Expanded(child: Center(child: Text("Price"))),
                      SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
              _buildSliverList(list),
            ],
          ),
        );
      }),
    );
  }

  Widget sliverBox({required Widget child}) {
    return SliverToBoxAdapter(
      child: child,
    );
  }

  Widget _buildSliverList(list) {
    final totalListLen = list.length * 2 - 1;
    return SliverList.builder(
      itemCount: totalListLen,
      itemBuilder: (_, index) {
        final data = list[index ~/ 2];
        final isLastIndex = index == totalListLen - 1;
        if (index % 2 == 0) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              borderRadius: isLastIndex
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    )
                  : BorderRadius.zero,
              color: controller.themeController.isDarkMode
                  ? Color(0xff505050)
                  : Color(0xFFF2F3F4),
            ),
            child: _buildItem(
              imgSrc: data["imgSrc"],
              name: data["name"],
              age: data["age"],
              price: data["price"],
            ),
          );
        }
        return Container(
          height: 1,
          color: Colors.grey,
        );
      },
    );
  }

  Widget _buildItem({
    required String imgSrc,
    required String name,
    required String age,
    required String price,
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imgSrc),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(name)),
        const SizedBox(width: 12),
        Expanded(child: Center(child: Text(age))),
        const SizedBox(width: 12),
        Expanded(child: Center(child: Text(price))),
        const SizedBox(width: 12),
      ],
    );
  }
}
