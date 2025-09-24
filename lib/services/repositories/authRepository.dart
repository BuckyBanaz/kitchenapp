import '../../constants/api_endpoints.dart';
import '../../models/customer_model.dart';
import '../api_client.dart';

class AuthResult {
  final String token;
  final CustomerModel customer;

  AuthResult({required this.token, required this.customer});
}

class AuthRepository {
  Future<AuthResult?> login(String name, String phone) async {
    final response = await ApiClient.dio.post(
      ApiEndpoints.userLogin,
      data: {
        'name': name,
        'phone': phone,
      },
    );

    if (response.statusCode == 200 && response.data['token'] != null) {
      final token = response.data['token'];
      final customer = CustomerModel.fromJson(response.data['data']);
      return AuthResult(token: token, customer: customer);
    }
    return null;
  }
}