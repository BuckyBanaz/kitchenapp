import 'package:dio/src/response.dart';
import '../../constants/api_endpoints.dart';

import '../../models/menu_model.dart';
import '../api_client.dart';

class MenuRepository {
  Future<Response?> createMenu({
    required int categoryId,
    required String name,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        ApiEndpoints.getMenus,
        data: {'category_id': categoryId, 'name': name},
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  Future<List<MenuModel>> fetchMenus() async {
    final response = await ApiClient.dio.get(ApiEndpoints.getMenus);
    if (response.statusCode == 200) {
      List data = response.data['data'];
      return data.map((e) => MenuModel.fromJson(e)).toList();
    }
    return [];
  }
}
