// lib/services/controllers/locale_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends GetxController {
  static const _languageKey = 'app_language'; // en_US / hi_IN / gu_IN

  final supported = const [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
    Locale('gu', 'IN'),
  ];

  /// App start पर saved locale apply करो (GherKaKhanaApp को बदले बिना)
  @override
  void onInit() {
    super.onInit();
    applySavedLocale(); // fire & forget
  }

  Future<void> applySavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_languageKey);
    if (code != null) {
      final loc = _fromCode(code);
      if (loc != null) Get.updateLocale(loc);
    }
  }

  /// Public: save + change
  Future<void> saveAndChange(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, code);
    final loc = _fromCode(code) ?? const Locale('en', 'US');
    Get.updateLocale(loc);
  }

  // helpers
  Locale? _fromCode(String code) {
    switch (code) {
      case 'en_US': return const Locale('en', 'US');
      case 'hi_IN': return const Locale('hi', 'IN');
      case 'gu_IN': return const Locale('gu', 'IN');
    }
    return null;
  }

  String codeToLabel(String code) {
    switch (code) {
      case 'en_US': return 'English';
      case 'hi_IN': return 'Hindi';
      case 'gu_IN': return 'Gujarati';
      default: return 'English';
    }
  }

  String labelToCode(String label) {
    switch (label) {
      case 'English': return 'en_US';
      case 'Hindi': return 'hi_IN';
      case 'Gujarati': return 'gu_IN';
      default: return 'en_US';
    }
  }
}
