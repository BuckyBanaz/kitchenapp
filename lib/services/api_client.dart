import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import 'package:get/get_core/src/get_main.dart';

import '../constants/api_endpoints.dart';
import '../routes/appRoutes.dart';
import 'DbService.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
      },
    ),
  )..interceptors.addAll([
    _AuthInterceptor(),
    _CustomLogInterceptor(),
  ]);

  /// Load token from SharedPreferences (call at app start)
  static void loadTokenFromDb() {
    final token = DbService.getToken();
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
      log('🔐 Token loaded from DbService');
    } else {
      log('ℹ️ No token found in DbService');
    }
  }

  /// Set token in headers and save to SharedPreferences
  static Future<void> setAuthToken(String token) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    await DbService.saveToken(token);
    await DbService.setLogin(true); // ✅ Also set login flag
    log('💾 Token saved & login flag set');
  }

  /// Clear token from headers & SharedPreferences
  static Future<void> clearAuthToken() async {
    dio.options.headers.remove('Authorization');
    await DbService.clearToken();
    log('🚫 Token header removed & token cleared');
  }
}

class _CustomLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('📤 REQUEST ➜ [${options.method}] ${options.uri}');
    log('🧾 Headers: ${options.headers}');
    if (options.data != null) {
      log('📦 Body: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('✅ RESPONSE [${response.statusCode}] ➜ ${response.requestOptions.uri}');
    log('📄 Response Body: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log('❌ ERROR [${err.response?.statusCode}] ➜ ${err.requestOptions.uri}');
    log('🪵 Message: ${err.message}');
    if (err.response?.data != null) {
      log('📄 Error Body: ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}

class _AuthInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    if (status == 401 || status == 403) {
      await ApiClient.clearAuthToken();
      await DbService.clearDb();
      log('🔒 Session expired. Redirecting to AuthScreen...');

      Get.offAllNamed(Routes.splash);
    }
    super.onError(err, handler);
  }
}

