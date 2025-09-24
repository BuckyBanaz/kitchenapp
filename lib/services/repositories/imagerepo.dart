import 'package:orderapp/constants/api_endpoints.dart';
import '../../models/orderInquiryModel.dart';
import '../api_client.dart'; // 👈 important
import 'package:dio/dio.dart';
class Imagerepo {
  static Future<String?> fetchStartImage() async {
    try {
      final response = await ApiClient.dio.get(
        ApiEndpoints.image,
      );

      if (response.statusCode == 200 && response.data['status'] == 0) {
        return response.data['image'];
      } else {
        print('Image fetch failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print("Error fetching image: $e");
      return null;
    }
  }
}