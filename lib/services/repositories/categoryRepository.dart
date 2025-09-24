
import '../../constants/api_endpoints.dart';

import '../../models/categories_model.dart';
import '../../services/api_client.dart';

import 'package:dio/dio.dart';

class CategoryRepository {
  Future<Response?> createCategory(String name) async {
    try {
      FormData formData = FormData.fromMap({'name': name});
      final response = await ApiClient.dio.post(
        ApiEndpoints.getCategories,
        data: formData,
      );
      return response;
    } catch (e) {
      if (e is DioException) return e.response;
      return null;
    }
  }

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await ApiClient.dio.get(ApiEndpoints.getCategories);
    if (response.statusCode == 200) {
      List data = response.data['data'];
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    }
    return [];
  }
}
