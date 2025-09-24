import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:iconly/iconly.dart';
import '../../constants/app_colors.dart';


import 'notificationcontroller.dart';





class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationScreenController controller = Get.put(NotificationScreenController());

    return Scaffold(

      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(IconlyLight.arrow_left_2),
        ),
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return const Center(child: Text('No notifications available.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.notifications.length,
          separatorBuilder: (_, __) => const Divider(height: 24),
          itemBuilder: (context, index) {
            final notif = controller.notifications[index];
            return ListTile(
              onTap: () => controller.markAsRead(index),
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: notif.isRead
                    ? Colors.grey[300]
                    : AppColors.primary.withOpacity(0.2),
                child: Icon(
                  notif.isRead ? IconlyLight.notification : IconlyBold.notification,
                  color: AppColors.primary,
                ),
              ),
              title: Text(
                notif.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: notif.isRead ? Colors.grey : Colors.black,
                ),
              ),
              subtitle: Text(
                notif.body,
                style: TextStyle(color: notif.isRead ? Colors.grey : null),
              ),
              trailing: Text(
                notif.timestamp,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
