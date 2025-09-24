import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../routes/appRoutes.dart';
import '../DbService.dart';
import '../api_client.dart';
import '../repositories/authRepository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final nameFocus = FocusNode();
  final phoneFocus = FocusNode();

  var isLoading = false.obs;
  String lastPath = "";
  
  @override
  void onInit() {
    Get.arguments != null ? lastPath = Get.arguments.toString() : lastPath = "";
    print("==========================last $lastPath");
    super.onInit();
  }



  void login() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      log('❗ Please enter both name and phone');
      return;
    }

    try {
      isLoading.value = true;
      final result = await _authRepository.login(name, phone);

      if (result != null) {
        await ApiClient.setAuthToken(result.token);
        await DbService.saveCustomer(result.customer); // ✅ Save customer
        await DbService.setLogin(true);

        log('✅ Login successful, token & customer saved');
        Get.offNamed(Routes.myOrders);
      } else {
        log('⚠️ Login failed: No result');
      }
    } catch (e) {
      log('❌ Login error: $e');
    } finally {
      isLoading.value = false;
    }
  }

}
