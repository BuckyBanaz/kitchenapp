import 'package:orderapp/constants/api_endpoints.dart';
import '../../models/orderInquiryModel.dart';
import '../api_client.dart'; // 👈 important
import 'package:dio/dio.dart';
class GetOrdersRepository {
  Future<List<OrderInquiryModel>> fetchOrders(int customerId, {int page = 1}) async {
    try {
      final response = await ApiClient.dio.get(
        ApiEndpoints.getOrder,
        queryParameters: {
          'customer_id': customerId,
          'page': page,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['orders']['data'];
        return data.map((e) => OrderInquiryModel.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      print("❌ Fetch order error: $e");
      return [];
    }
  }



  Future<OrderInquiryModel?> getOrderById(int orderId) async {
    try {
      final response = await ApiClient.dio.get(
        '${ApiEndpoints.getOrderById}',
        queryParameters: {'order_id': orderId},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return OrderInquiryModel.fromJson(response.data['order']);
      } else {
        print("⚠️ API responded with: ${response.data}");
        return null;
      }
    } catch (e) {
      print("❌ Error fetching order by ID: $e");
      return null;
    }
  }

  /// Cancel order by ID
  Future<bool> cancelOrder(int orderId) async {
    try {
      final response = await ApiClient.dio.post(
        ApiEndpoints.cancelOrder,
        data: FormData.fromMap({
          'order_id': orderId.toString(),
        }),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        print("✅ Order cancelled successfully");
        return true;
      } else {
        print("⚠️ Failed to cancel order: ${response.data}");
        return false;
      }
    } catch (e) {
      print("❌ Cancel order error: $e");
      return false;
    }
  }
}
