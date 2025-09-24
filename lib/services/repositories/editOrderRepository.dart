import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:orderapp/services/api_client.dart';
import 'package:orderapp/constants/api_endpoints.dart';

class EditOrderRepository {
  Future<Map<String, dynamic>> bookOrder({
    required int orderId,
    required int customerId,
    required String address,
    required String date,
    required String time,
    required String location,
    required String additionalNumber,
    required int person,
    String? note, // 👈 optional banaya
    List<String>? menuItems,
    String? imagePath, // This can be either local file path or URL
  }) async {
    final bool hasMenu = menuItems != null && menuItems.isNotEmpty;
    final bool hasImage = imagePath != null && imagePath.isNotEmpty;

    if (!hasMenu && !hasImage) {
      throw Exception("At least menu or image must be provided.");
    }

    final formData = FormData.fromMap({
      "customer_id": customerId,
      "order_id": orderId,
      "address": address,
      "date": date,
      "time": time,
      "location": location,
      "additional_number": additionalNumber,
      "person": person,
      "price": 0,
      "status": "booked",
      if (note != null && note.isNotEmpty) "note": note, // 👈 optional field
      if (hasMenu)
        "menu": menuItems!.map((e) => {"item": e}).toList(),
    });

    // Handle image - check if it's a URL or local file
    if (hasImage) {
      if (imagePath!.startsWith('http')) {
        // For remote URL, download the file first
        final response = await Dio().get(
          imagePath,
          options: Options(responseType: ResponseType.bytes),
        );

        formData.files.add(MapEntry(
          "image",
          MultipartFile.fromBytes(
            response.data,
            filename: imagePath.split("/").last,
          ),
        ));
      } else {
        // For local file
        formData.files.add(MapEntry(
          "image",
          await MultipartFile.fromFile(
            imagePath,
            filename: imagePath.split("/").last,
          ),
        ));
      }
    }

    final response = await ApiClient.dio.post(
      ApiEndpoints.editOrder,
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