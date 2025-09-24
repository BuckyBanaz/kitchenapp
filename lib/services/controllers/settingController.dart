import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/customer_model.dart';
import '../../routes/appRoutes.dart';
import '../../screen/settings/settingsScreen.dart';
import '../DbService.dart';
import 'locale_controller.dart';


/// ============================================================
/// Settings Controller (GetX) — pro version
/// ============================================================
class SettingsController extends GetxController {
  final Rx<CustomerModel?> customer = Rx<CustomerModel?>(null);
  final RxString languageLabel = 'English'.obs; // UI label

  static const String _languageKey = 'app_language';

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    customer.value = DbService.getCustomer();

    // read saved code -> label
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_languageKey) ?? 'en_US';
    final lc = Get.find<LocaleController>();
    languageLabel.value = lc.codeToLabel(code);

    // ensure app locale is applied (in case app default != saved)
    await lc.applySavedLocale();
  }

  Future<void> setLanguageByLabel(String label) async {
    final lc = Get.find<LocaleController>();
    final code = lc.labelToCode(label);
    await lc.saveAndChange(code);

    languageLabel.value = label;

    Get.back();
    Get.snackbar(
      AppStrings.languageUpdated,
      '${AppStrings.appLanguageSetTo} $label',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
    );
  }

  void openLanguageDialog() {
    final current = languageLabel.value;

    Get.defaultDialog(
      title: AppStrings.chooseLanguage,
      titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      radius: 16,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LangTile(
            label: 'English',
            selected: current == 'English',
            onTap: () => setLanguageByLabel('English'),
          ),
          const SizedBox(height: 8),
          LangTile(
            label: 'Hindi',
            selected: current == 'Hindi',
            onTap: () => setLanguageByLabel('Hindi'),
          ),
          const SizedBox(height: 8),
          LangTile(
            label: 'Gujarati',
            selected: current == 'Gujarati',
            onTap: () => setLanguageByLabel('Gujarati'),
          ),
        ],
      ),
      textCancel: AppStrings.cancel,
      cancelTextColor: Get.theme.colorScheme.primary,
    );
  }

  Future<void> confirmLogout() async {
    Get.defaultDialog(
      title: AppStrings.confirmLogoutTitle,
      buttonColor: AppColors.primary,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Text(AppStrings.confirmLogoutBody, textAlign: TextAlign.center),
        ],
      ),
      radius: 16,
      textCancel: AppStrings.noText,         // ✅ translated "No"
      textConfirm: AppStrings.yesLogout,     // ✅ translated "Yes, Logout"
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await DbService.clearDb();
        Get.back();
        Get.offAllNamed(Routes.auth);
      },
    );
  }
}