import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class NotificationModel {
  final String title;
  final String body;
  final String timestamp;
  bool isRead; // 👈 mutable so we can mark it read

  NotificationModel({
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });
}

class NotificationScreenController extends GetxController {
  var notifications = <NotificationModel>[].obs;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    loadDummyNotifications();
  }

  void loadDummyNotifications() {
    notifications.value = [
      NotificationModel(title: 'Order Placed', body: 'Your order #12345 has been placed successfully.', timestamp: '2 min ago'),
      NotificationModel(title: 'Delivery Update', body: 'Your order is out for delivery.', timestamp: '30 min ago'),
      NotificationModel(title: 'Offer Unlocked', body: 'Get 10% off on your next order!', timestamp: '1 day ago'),
    ];
  }

  void markAsRead(int index) {
    notifications[index].isRead = true;
    notifications.refresh(); // Notify observers
    update();
  }

  void markAllAsRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
    update();
  }
}
