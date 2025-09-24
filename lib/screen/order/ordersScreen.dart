import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

import 'package:orderapp/constants/app_strings.dart';
import 'package:orderapp/routes/appRoutes.dart';
import 'package:orderapp/services/controllers/getOrdersController.dart';

import '../../constants/app_colors.dart';
import '../../models/orderInquiryModel.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final GetOrdersController controller = Get.put(GetOrdersController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100 &&
          !controller.isFetchingMore.value &&
          controller.hasMoreData) {
        controller.fetchOrders(isNextPage: true);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: Obx(() {
          return AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: controller.isSearching.value
                ? TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint, // e.g. “Search by Order ID…”
                border: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.titleMedium,
              onChanged: controller.searchOrders,
            )
                : Text(AppStrings.myOrders),
            leading: controller.isSearching.value
                ? null
                : IconButton(
              icon: const Icon(IconlyLight.arrow_left_2),
              onPressed: () => Get.offAllNamed(Routes.home),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  controller.isSearching.value
                      ? Icons.close
                      : IconlyLight.search,
                ),
                onPressed: () {
                  if (controller.isSearching.value) {
                    controller.searchQuery.value = '';
                  }
                  controller.isSearching.toggle();
                },
              ),
            ],
          );
        }),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Obx(() {
            if (controller.isLoading.value && controller.orders.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final grouped = controller.groupedOrders; // <- uses filtered list

            if (grouped.isEmpty) {
              // If searching, show “no results”; otherwise “no orders”
              final isSearching = controller.isSearching.value &&
                  controller.searchQuery.value.trim().isNotEmpty;
              return Center(
                child: Text(
                  isSearching ? "No matching orders" : "No orders found",
                ),
              );
            }

            return ListView(
              controller: scrollController,
              children: [
                ...grouped.entries.map((entry) {
                  return _GroupedSection(
                    title: entry.key,
                    orders: entry.value,
                    controller: controller,
                  );
                }).toList(),
                if (controller.isFetchingMore.value)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _GroupedSection extends StatelessWidget {
  final String title;
  final List<OrderInquiryModel> orders;
  final GetOrdersController controller;

  const _GroupedSection({
    required this.title,
    required this.orders,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...orders
            .map((inquiry) => _InquiryTile(
          inquiry: inquiry,
          controller: controller,
        ))
            .toList(),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _InquiryTile extends StatelessWidget {
  final OrderInquiryModel inquiry;
  final GetOrdersController controller;

  const _InquiryTile({required this.inquiry, required this.controller});

  @override
  Widget build(BuildContext context) {
    final menuItems = inquiry.menu.map((e) => e.item).join(', ');
    final status = inquiry.status?.capitalize ?? 'Unknown';

    DateTime? parsed;
    try {
      parsed = DateTime.parse("${inquiry.date} ${inquiry.time}");
    } catch (_) {}

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          title: Text(menuItems),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order #${inquiry.id}",
                  style:
                  const TextStyle(color: AppColors.primary, fontSize: 13)),
              const SizedBox(height: 4),
              Text("Status: $status"),
              if (status == 'Booked') ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (controller.canCancelOrder(
                        inquiry.date!, inquiry.time!))
                      ElevatedButton(
                        onPressed: () => controller.cancelOrder(inquiry.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                        ),
                        child: Text(
                          AppStrings.cancelOrder,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    if (controller.canCancelOrder(
                        inquiry.date!, inquiry.time!))
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Get.toNamed(
                              Routes.editOrder,
                              arguments: inquiry);
                          if (result == true) {
                            final listController =
                            Get.isRegistered<GetOrdersController>()
                                ? Get.find<GetOrdersController>()
                                : null;
                            listController?.fetchOrders();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightGrey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                        ),
                        child: Text(
                          AppStrings.editOrder,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
          trailing: parsed == null
              ? const SizedBox.shrink()
              : Text(
            DateFormat('hh:mm a').format(parsed),
            style: const TextStyle(color: AppColors.grey, fontSize: 18),
          ),
          onTap: () {
            Get.toNamed(Routes.orderDetailsScreen, arguments: inquiry.id);
            log("=========================${inquiry.id}");
          },
        ),
        const Divider()
      ],
    );
  }
}
