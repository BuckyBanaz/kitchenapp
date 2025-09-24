import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/customer_model.dart';
import '../../models/menu_model.dart';
import '../../routes/appRoutes.dart';
import '../../utils/toast_utils.dart';
import '../DbService.dart';
import '../api_client.dart';
import '../repositories/authRepository.dart';
import '../repositories/book_order_repository.dart';

class BookOrderController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final personController = TextEditingController();
  final addressController = TextEditingController();
  final notesController = TextEditingController();
  final dateController = TextEditingController(); // UI display (dd-MM-yyyy)
  final timeController = TextEditingController();

  final nameFocus = FocusNode();
  final phoneFocus = FocusNode();
  final personFocus = FocusNode();
  final addressFocus = FocusNode();
  final notesFocus = FocusNode();
  final dateFocus = FocusNode();
  final timeFocus = FocusNode();

  RxList<MenuModel> selectedMenus = <MenuModel>[].obs;
  RxList<FocusNode> menuFocusNodes = <FocusNode>[].obs;
  Rx<CustomerModel?> currentCustomer = Rx<CustomerModel?>(null);
  RxBool isLoggingIn = false.obs;
  RxString selectedImagePath = ''.obs;
  final _repo = BookOrderRepository();
  RxBool isLoading = false.obs;
  String _backendDateValue = ''; // Store yyyy-MM-dd for backend

  @override
  void onInit() {
    super.onInit();
    final customer = DbService.getCustomer();
    currentCustomer.value = customer;
    if (customer != null) {
      nameController.text = customer.name;
      phoneController.text = customer.phone;
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
      // Display format: dd-MM-yyyy
      final displayFormat =
          "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}";

      // Backend format: yyyy-MM-dd
      final backendFormat =
          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

      dateController.text = displayFormat;
      _backendDateValue = backendFormat;
    }
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




  Future<void> loginOnlyWithNamePhone() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      showToast("Enter both name & phone to login");
      return;
    }

    try {
      isLoggingIn.value = true;
      final result = await AuthRepository().login(name, phone);
      if (result != null) {
        await ApiClient.setAuthToken(result.token);
        await DbService.saveCustomer(result.customer);
        await DbService.setLogin(true);
        currentCustomer.value = result.customer;
        showToast("Login successful");
      } else {
        showToast("Login failed");
      }
    } catch (e) {
      showToast("Login error: $e");
    } finally {
      isLoggingIn.value = false;
    }
  }

  void submitOrder() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final person = int.tryParse(personController.text.trim()) ?? 0;
    final address = addressController.text.trim();
    final notes = notesController.text.trim();
    final date = _backendDateValue.trim(); // Send backend-formatted date
    final time = timeController.text.trim();
    final menuItems = selectedMenus.map((e) => e.name).whereType<String>().toList();
    final imagePath = selectedImagePath.value;

    if (name.isEmpty) {
      showToast("👤 Name is required");
      nameFocus.requestFocus();
      return;
    }

    if (phone.isEmpty) {
      showToast("📞 Phone number is required");
      phoneFocus.requestFocus();
      return;
    }

    if (person <= 0) {
      showToast("👥 Persons must be greater than 0");
      personFocus.requestFocus();
      return;
    }

    if (address.isEmpty) {
      showToast("🏠 Address is required");
      addressFocus.requestFocus();
      return;
    }

    if (date.isEmpty) {
      showToast("📅 Date is required");
      dateFocus.requestFocus();
      return;
    }

    if (time.isEmpty) {
      showToast("⏰ Time is required");
      timeFocus.requestFocus();
      return;
    }

    // ✅ Validate: at least menu OR image must be provided
    if (menuItems.isEmpty && imagePath.isEmpty) {
      showToast("🍽️ Please provide at least menu or image");
      return;
    }

    final customer = DbService.getCustomer();
    if (customer == null) {
      showToast("⚠️ User not logged in.");
      return;
    }

    try {
      isLoading.value = true;
      final response = await _repo.bookOrder(
        customerId: customer.id,
        address: address,
        date: date,
        time: time,
        location: address,
        additionalNumber: phone,
        note: notes,
        person: person,
        menuItems: menuItems,
        imagePath: imagePath.isNotEmpty ? imagePath : null,
      );

      final orderId = response['order']['id'];
      showToast("✅ Order placed successfully");
      Get.offAllNamed(Routes.orderConfirmationView, arguments: {'orderId': orderId});
      isLoading.value = false;
    } catch (e) {
      showToast("❌ Failed to place order or booking is unavailable.");
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
    for (var node in menuFocusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
