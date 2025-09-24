import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/customer_model.dart';

class DbService {
  static late SharedPreferences _prefs;

  static const String _authTokenKey = 'auth_token';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _customerKey = 'customer_data';

  /// Initialize shared preferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    log('🗃️ DbService initialized');
  }

  // 🔐 Token
  static Future<void> saveToken(String token) async {
    await _prefs.setString(_authTokenKey, token);
  }

  static String? getToken() {
    return _prefs.getString(_authTokenKey);
  }

  static Future<void> clearToken() async {
    await _prefs.remove(_authTokenKey);
  }

  // ✅ Login Flag
  static Future<void> setLogin(bool value) async {
    await _prefs.setBool(_isLoggedInKey, value);
  }

  static bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> saveCustomer(CustomerModel customer) async {
    String customerJson = jsonEncode(customer.toJson());
    await _prefs.setString(_customerKey, customerJson);
    log('👤 Customer saved: $customerJson');
  }

  // 📦 Get customer model
  static CustomerModel? getCustomer() {
    String? customerJson = _prefs.getString(_customerKey);
    if (customerJson == null) return null;

    try {
      Map<String, dynamic> jsonMap = jsonDecode(customerJson);
      log('👤 Customer saved: $jsonMap');
      return CustomerModel.fromJson(jsonMap);

    } catch (e) {
      log('❌ Failed to decode customer: $e');
      return null;
    }
  }


  // 🧹 Clear all login info
  static Future<void> clearDb() async {
    await _prefs.remove(_authTokenKey);
    await _prefs.remove(_isLoggedInKey);
    await _prefs.remove(_customerKey);
    log('🧼 Cleared all stored login data');
  }
}
