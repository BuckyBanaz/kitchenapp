import 'package:dio/dio.dart';
import 'package:orderapp/services/api_client.dart';
import 'package:orderapp/services/dbservice.dart';
import 'package:orderapp/constants/api_endpoints.dart';

class BookOrderRepository {
  Future<Map<String, dynamic>> bookOrder({
    required int customerId,
    required String address,
    required String date,
    required String time,
    required String location,
    required String additionalNumber,
    required int person,
    String? note, // 👈 optional banaya
    List<String>? menuItems,
    String? imagePath,
  }) async {
    final bool hasMenu = menuItems != null && menuItems.isNotEmpty;
    final bool hasImage = imagePath != null && imagePath.isNotEmpty;

    // ❌ Reject if both are missing
    if (!hasMenu && !hasImage) {
      throw Exception("At least menu or image must be provided.");
    }

    final formData = FormData.fromMap({
      "customer_id": customerId,
      "address": address,
      "date": date,
      "time": time,
      "location": location,
      "additional_number": additionalNumber,
      "person": person,
      "price": 0,
      if (note != null && note.isNotEmpty) "note": note, // 👈 optional field
      if (hasMenu)
        "menu": menuItems!.map((e) => {"item": e}).toList(),
      if (hasImage)
        "image": await MultipartFile.fromFile(
          imagePath!,
          filename: imagePath.split("/").last,
        ),
    });

    final response = await ApiClient.dio.post(
      ApiEndpoints.bookorder,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception("Failed to place order: ${response.statusMessage}");
    }
  }
}

