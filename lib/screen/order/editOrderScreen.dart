// Add this import at the top
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:orderapp/constants/app_colors.dart';
import 'package:orderapp/services/controllers/bookOrderController.dart';
import '../../constants/app_strings.dart';
import '../../models/menu_model.dart';
import '../../services/controllers/editOrderController.dart';
import '../../services/controllers/menuController.dart';
import '../../utils/toast_utils.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input_field.dart';

class EditOrderScreen extends StatefulWidget {
  const EditOrderScreen({super.key});

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  final EditOrderController controller = Get.put(EditOrderController());
  late final MenusController menusController;
  @override
  void initState() {
    super.initState();

    menusController = Get.put(MenusController());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppStrings.editYourOrder),
        leading: IconButton(
          icon: const Icon(IconlyLight.arrow_left_2),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() {

          return ListView(
            children: [
              // Name & Phone
              CustomInputField(
                label: AppStrings.fieldName,
                controller: controller.nameController,
                currentFocus: controller.nameFocus,
                nextFocus: controller.phoneFocus,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                label: AppStrings.fieldPhone,
                controller: controller.phoneController,
                currentFocus: controller.phoneFocus,
                nextFocus: controller.personFocus,
                inputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),


                CustomInputField(
                  label: AppStrings.fieldPersons,
                  controller: controller.personController,
                  currentFocus: controller.personFocus,
                  keyboardType: TextInputType.number,
                  nextFocus: controller.addressFocus,
                  inputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: AppStrings.fieldAddress,
                  controller: controller.addressController,
                  currentFocus: controller.addressFocus,
                  nextFocus: controller.dateFocus,
                  inputAction: TextInputAction.newline,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => controller.pickDate(context),
                  child: AbsorbPointer(
                    child: CustomInputField(
                      label: AppStrings.selectDate,
                      controller: controller.dateController,
                      currentFocus: controller.dateFocus,
                      keyboardType: TextInputType.datetime,
                      nextFocus: controller.timeFocus,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => controller.pickTime(context),
                  child: AbsorbPointer(
                    child: CustomInputField(
                      label: AppStrings.selectTime,
                      controller: controller.timeController,
                      currentFocus: controller.timeFocus,
                      keyboardType: TextInputType.datetime,
                      nextFocus: controller.notesFocus,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 🍽️ Menu
                Text(
                  AppStrings.addFoodItems,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),

              GestureDetector(
                onTap: () => _showMenuTypeDialog(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primarySwatch.shade50,
                    // border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.selectedMenus.isNotEmpty
                            ? "${controller.selectedMenus.length} ${AppStrings.menuSuffix}"
                            : controller.selectedImagePath.isNotEmpty
                            ? "Image selected"
                            : AppStrings.addMenuItems,
                      ),

                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📝 Text Menu List
                  ...controller.selectedMenus.map((menu) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.fastfood, color: Colors.red, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              capitalizeEachWord(menu.name ?? ''),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                            onPressed: () => controller.selectedMenus.remove(menu),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 12),

                  // 🖼️ Menu Image if selected
                  if (controller.selectedImagePath.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Selected Menu Image", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(controller.selectedImagePath.value),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () => controller.selectedImagePath.value = '',
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Remove Image',
                          ),
                        ),
                      ],
                    )
                  else if (controller.imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        controller.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            // Image is fully loaded, return the child (the actual image)
                            return child;
                          }
                          // Image is still loading, show a circular progress indicator
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          // Optional: Show an error widget if the image fails to load
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.error, color: Colors.red),
                          );
                        },
                      ),
                    )

                ],
              )),

              const SizedBox(height: 16),
                CustomInputField(
                  label: AppStrings.fieldInstructions,
                  controller: controller.notesController,
                  currentFocus: controller.notesFocus,
                  nextFocus: null,
                  maxLines: 10,
                  inputAction: TextInputAction.done,
                  onDone: controller.editOrder,
                ),
              ],

          );
        }),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 24, left: 12, right: 12),
        child: Obx(() {
          return controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : CustomRedButton(
            text: AppStrings.updateOrder,
            onPressed: controller.editOrder,
          );
        }),
      ),
    );
  }

  void _showMenuTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.chooseMenuTypeTitle),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              _openMenuSelectionDialog(context); // Open text input menu
            },
            child: Text(AppStrings.textButton),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              _openImageMenuDialog(context); // Open image input menu
            },
            child: Text(AppStrings.imageButton),
          ),
        ],
      ),
    );
  }

  void _openImageMenuDialog(BuildContext context) async {
    final RxnString pickedImage = RxnString();
    final RxBool isLoading = false.obs;

    Get.bottomSheet(
      Obx(() => Container(
        height: Get.height * 0.6,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(AppStrings.uploadMenuImageTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Center Content
            Expanded(
              child: Center(
                child: isLoading.value
                    ? const CircularProgressIndicator()
                    : pickedImage.value == null
                    ? ElevatedButton.icon(
                  onPressed: () async {
                    isLoading.value = true;
                    final picked = await controller.pickImage();
                    if (picked != null) {
                      pickedImage.value = picked;
                    }
                    isLoading.value = false;
                  },
                  icon: const Icon(Icons.image),
                  label:  Text(AppStrings.chooseImage),
                )
                    : SingleChildScrollView(
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 250,
                          maxWidth: double.infinity,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(pickedImage.value!),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => pickedImage.value = null,
                        icon: const Icon(Icons.delete),
                        label:Text(AppStrings.removeImage),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Confirm Button
            CustomRedButton(
              text: AppStrings.confirmButton,
              onPressed: () {
                if (pickedImage.value == null) {
                  showToast(AppStrings.pleasePickImage);
                  return;
                }

                controller.selectedImagePath.value = pickedImage.value!;
                controller.selectedMenus.clear(); // Clear previous text menus
                Get.back();
              },
            ),
          ],
        ),
      )),
      isScrollControlled: true,
    );
  }



  void _openMenuSelectionDialog(BuildContext context) {
    final MenusController menusController = Get.find<MenusController>();

    // Make a **temporary copy** of selectedMenus
    List<MenuModel> tempMenus = List<MenuModel>.from(controller.selectedMenus);
    List<FocusNode> tempFocusNodes = List.generate(tempMenus.length, (_) => FocusNode());

    if (tempMenus.isEmpty) {
      // tempMenus.add(MenuModel(name: ""));
      tempFocusNodes.add(FocusNode());
    }

    final TextEditingController searchController = TextEditingController();
    bool showCustomInput = false;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          // filtered list from MenusController using current search text
          final filteredMenus = menusController.menus
              .where((m) => searchController.text.trim().isEmpty
              ? true
              : m.name.toLowerCase().contains(searchController.text.toLowerCase()))
              .toList();

          return Container(
            height: Get.height * 0.9,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.menu, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Search row + Custom toggle
                // Search row + Custom toggle (modified: Add button shows only in custom mode)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: showCustomInput ? AppStrings.hintAddItem : AppStrings.searchHint,
                          filled: true,
                          fillColor: AppColors.primarySwatch.shade50,
                          prefixIcon: Icon(showCustomInput ? Icons.edit : Icons.search),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Toggle between search mode and custom input mode
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showCustomInput = !showCustomInput;
                              searchController.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: showCustomInput ? Colors.orange : AppColors.primary,
                          ),
                          child: Text(showCustomInput ? AppStrings.searchHint : AppStrings.custom),
                        ),

                        // Show the Add button ONLY when in custom mode
                        if (showCustomInput) ...[
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              final text = searchController.text.trim();
                              if (text.isEmpty) {
                                showToast(AppStrings.toastFillAllItems);
                                return;
                              }
                              setState(() {
                                tempMenus.add(MenuModel.createTemp(text));
                                tempFocusNodes.add(FocusNode());
                                searchController.clear();
                              });
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Add"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primarySwatch.shade300,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),


                const SizedBox(height: 12),

                // Available menu list (only show when not typing custom)
                if (!showCustomInput) ...[
                  Expanded(
                    child: menusController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : filteredMenus.isEmpty
                        ? Center(child: Text(AppStrings.noItemsFound))
                        : ListView.separated(
                      itemCount: filteredMenus.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, idx) {
                        final m = filteredMenus[idx];
                        final alreadyAdded = tempMenus.any((t) => t.name.trim().toLowerCase() == m.name.trim().toLowerCase());

                        return ListTile(
                          title: Text(m.name),
                          trailing: alreadyAdded
                              ? const Icon(Icons.check, color: Colors.green)
                              : IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                // Avoid exact duplicates
                                if (!alreadyAdded) {
                                  tempMenus.add(MenuModel.createTemp(m.name));
                                  tempFocusNodes.add(FocusNode());
                                }
                              });
                            },
                          ),
                          onTap: () {
                            // also allow tap to add
                            if (!alreadyAdded) {
                              setState(() {
                                tempMenus.add(MenuModel.createTemp(m.name));
                                tempFocusNodes.add(FocusNode());
                              });
                            }
                          },
                        );
                      },
                    ),
                  ),
                ] ,

                const SizedBox(height: 12),

                // Existing temporary selection preview & Done button
                if (tempMenus.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.selectedItems, style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: tempMenus.map((m) {
                          return Chip(
                            label: Text(m.name ?? ''),
                            deleteIcon: const Icon(Icons.close),
                            onDeleted: () {
                              setState(() {
                                final idx = tempMenus.indexOf(m);
                                if (idx >= 0) {
                                  tempMenus.removeAt(idx);
                                  tempFocusNodes.removeAt(idx);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Validate all not empty
                          for (int i = 0; i < tempMenus.length; i++) {
                            if (tempMenus[i].name == null || tempMenus[i].name!.trim().isEmpty) {
                              showToast(AppStrings.toastFillAllItems);
                              if (i < tempFocusNodes.length) {
                                FocusScope.of(context).requestFocus(tempFocusNodes[i]);
                              }
                              return;
                            }
                          }

                          // Save only on Confirm
                          controller.selectedMenus.value = tempMenus;
                          Get.back();
                        },
                        icon: const Icon(Icons.done),
                        label: const Text("Done"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        child: const Text("Cancel"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }


// Add this helper function outside the build method or in a utils file
  String capitalizeEachWord(String input) {
    return input
        .split(' ')
        .map((word) =>
    word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }

}
