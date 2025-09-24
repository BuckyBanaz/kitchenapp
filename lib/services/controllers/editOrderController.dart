import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../models/customer_model.dart';
import '../../models/menu_model.dart';
import '../../models/orderInquiryModel.dart';
import '../../services/repositories/editOrderRepository.dart';
import '../../utils/toast_utils.dart';
import '../DbService.dart';
import '../../routes/appRoutes.dart';

class EditOrderController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final personController = TextEditingController();
  final addressController = TextEditingController();
  final notesController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  final nameFocus = FocusNode();
  final phoneFocus = FocusNode();
  final personFocus = FocusNode();
  final addressFocus = FocusNode();
  final notesFocus = FocusNode();
  final dateFocus = FocusNode();
  final timeFocus = FocusNode();
  RxBool isLoading = false.obs;
  RxList<MenuModel> selectedMenus = <MenuModel>[].obs;
  RxList<FocusNode> menuFocusNodes = <FocusNode>[].obs;
  RxBool isMenuLoading = false.obs;
  OrderInquiryModel? order;
  final _repo = EditOrderRepository();
  RxString selectedImagePath = ''.obs;
  String imageUrl = '';
  String _backendDateValue = ''; // yyyy-MM-dd format for backend
  String? finalImageUrl;
  @override
  void onInit() {
    super.onInit();

    order = Get.arguments as OrderInquiryModel?;
    log("message${order!.id}");
    log("message${order!.id}");
    log("message${order!.id}");
    log("message${order!.menu}");

    if (order != null) {
      nameController.text = DbService.getCustomer()?.name ?? '';
      phoneController.text = DbService.getCustomer()?.phone ?? '';
      personController.text = order!.person;
      addressController.text = order!.address;

      if (order!.note != null) {
        notesController.text = order!.note!;
      }

      // Convert and set date
      final parsedDate = DateTime.tryParse(order!.date);
      if (parsedDate != null) {
        _backendDateValue = DateFormat('yyyy-MM-dd').format(parsedDate);
        dateController.text = DateFormat('dd-MM-yyyy').format(parsedDate);
      } else {
        dateController.text = order!.date;
      }

      timeController.text = order!.time;
      if (order!.image != null) {
        imageUrl = order!.image ?? "";
      }



      selectedMenus.assignAll(
        order!.menu.map((m) => MenuModel(name: m.item)).toList(),
      );
    }
  }

  void pickDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (selectedDate != null) {
      dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      _backendDateValue = DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }



  void pickTime(BuildContext context) {
    DateTime selectedDateTime = DateTime.now();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              // Action bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: const Text("Done"),
                    onPressed: () {
                      // Format for backend (24-hour format: HH:mm)
                      final formattedTime =
                          "${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}";

                      timeController.text = formattedTime;
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: false, // iOS-style 12-hour UI (AM/PM)
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (DateTime newTime) {
                    selectedDateTime = newTime;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return pickedFile.path;
    } else {
      return null;
    }
  }

  void editOrder() async {
    if (isLoading.value) return; // Prevent multiple submissions
    isLoading.value = true;

    final orderId = order!.id;
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final person = int.tryParse(personController.text.trim()) ?? 0;
    final address = addressController.text.trim();
    final notes = notesController.text.trim();
    final date = _backendDateValue.trim(); // for backend
    final time = timeController.text.trim();
    final menuItems = selectedMenus.map((e) => e.name).toList();
    final String imagePath = selectedImagePath.isNotEmpty
        ? selectedImagePath.value
        : imageUrl.isNotEmpty
        ? imageUrl
        : '';

    if (name.isEmpty) {
      showToast("👤 Name is required");
      nameFocus.requestFocus();
      isLoading.value = false;
      return;
    }

    if (phone.isEmpty) {
      showToast("📞 Phone number is required");
      phoneFocus.requestFocus();
      isLoading.value = false;
      return;
    }

    if (person <= 0) {
      showToast("👥 Persons must be greater than 0");
      personFocus.requestFocus();
      isLoading.value = false;
      return;
    }

    if (address.isEmpty) {
      showToast("🏠 Address is required");
      addressFocus.requestFocus();
      isLoading.value = false;
      return;
    }

    if (_backendDateValue.isEmpty) {
      showToast("📅 Date is required");
      dateFocus.requestFocus();
      isLoading.value = false;
      return;
    }

    if (time.isEmpty) {
      showToast("⏰ Time is required");
      timeFocus.requestFocus();
      isLoading.value = false;
      return;
    }

    if (menuItems.isEmpty && imagePath.isEmpty) {
      showToast("🍽️ Please provide at least menu or image");
      isLoading.value = false;
      return;
    }

    final customer = DbService.getCustomer();
    if (customer == null) {
      showToast("⚠️ User not logged in.");
      isLoading.value = false;
      return;
    }

    try {
      await _repo.bookOrder(
        orderId: orderId,
        customerId: customer.id,
        address: address,
        date: date,
        time: time,
        note: notes,
        location: address,
        additionalNumber: phone,
        person: person,
        menuItems: menuItems,
        imagePath: imagePath.isNotEmpty ? imagePath : null,
      );

      showToast("✅ Order updated");
      Get.back(result: true);
    } catch (e) {
      showToast("❌ Failed to update order");
      print("❌ Error updating order: $e");
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onClose() {
    phoneController.dispose();
    personController.dispose();
    addressController.dispose();
    notesController.dispose();
    dateController.dispose();
    timeController.dispose();
    phoneFocus.dispose();
    personFocus.dispose();
    addressFocus.dispose();
    notesFocus.dispose();
    dateFocus.dispose();
    timeFocus.dispose();
    super.onClose();
  }
}
