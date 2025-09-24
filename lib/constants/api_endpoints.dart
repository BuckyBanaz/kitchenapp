// lib/api/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl = 'https://unikdentalcare.com/hotel/public/api';


  // Auth
  static const String auth = '/customer/auth';
  // Menu
  static const String getMenus = '/menus';

  // Categories
  static const String getCategories = '/categories';

  // Types
  static const String getTypes = '/types';

  // Customer
  static const String customerAuth = '/customer/auth';
  static const String inquiry = '/inquiry';
  static const String bookorder = '/customer/book-order';
  static const String getOrder = '/customer/get-order';
  static const String getOrderById = '/customer/get-order-by-id';
  static const String editOrder = '/edit-order';
  static const cancelOrder = "/customer/cancel-order";
  static const image = "/startimage";
  // Admin
  static const String userLogin = '/customer/auth';
  static const String userProfile = '/user/profile';
}
