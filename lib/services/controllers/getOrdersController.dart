import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:orderapp/utils/toast_utils.dart';

import '../../constants/app_strings.dart';
import '../../models/orderInquiryModel.dart';
import '../DbService.dart';
import '../repositories/getOrdersRepository.dart';


import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:orderapp/utils/toast_utils.dart';

import '../../constants/app_strings.dart';
import '../../models/orderInquiryModel.dart';
import '../DbService.dart';
import '../repositories/getOrdersRepository.dart';

class GetOrdersController extends GetxController {
  final isLoading = false.obs;
  final isFetchingMore = false.obs;

  /// Raw list (all fetched so far, paginated)
  final orders = <OrderInquiryModel>[].obs;

  /// Search
  final searchQuery = ''.obs;
  final isSearching = false.obs;

  int currentPage = 1;
  bool hasMoreData = true;

  final GetOrdersRepository _repo = GetOrdersRepository();

  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  Future<void> fetchOrders({bool isNextPage = false}) async {
    if (isNextPage) {
      isFetchingMore.value = true;
    } else {
      isLoading.value = true;
      currentPage = 1;
      hasMoreData = true;
      orders.clear();
    }

    final customer = DbService.getCustomer();
    if (customer != null) {
      final result = await _repo.fetchOrders(customer.id, page: currentPage);
      if (result.isNotEmpty) {
        orders.addAll(result);
        currentPage++;
      } else {
        hasMoreData = false;
      }
    }

    isLoading.value = false;
    isFetchingMore.value = false;
  }

  Future<void> cancelOrder(int orderId) async {
    try {
      isLoading.value = true;
      final result = await _repo.cancelOrder(orderId);
      if (result) {
        showToast(AppStrings.orderCancel);
        await fetchOrders(); // refresh first page
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong",
          backgroundColor: const Color(0xFFD32F2F), colorText: const Color(0xFFFFFFFF));
    } finally {
      isLoading.value = false;
    }
  }

  /// ===== SEARCH / FILTERS =====

  /// If empty: return all orders.
  /// Otherwise: match by Order ID (contains) OR any menu item text (contains).
  List<OrderInquiryModel> get filteredOrders {
    final q = searchQuery.value.trim();
    if (q.isEmpty) return orders;

    final qLower = q.toLowerCase();
    return orders.where((o) {
      final idMatch = o.id.toString().contains(qLower);
      final itemMatch = o.menu.any(
            (m) => (m.item ?? '').toLowerCase().contains(qLower),
      );
      return idMatch || itemMatch;
    }).toList();
  }

  /// Build groups from the **filtered** list (fixes the bug).
  Map<String, List<OrderInquiryModel>> get groupedOrders {
    final src = filteredOrders; // <- key change

    if (src.isEmpty) return {};

    final Map<String, List<OrderInquiryModel>> groups = {};
    final sorted = src.toList()
      ..sort((a, b) {
        final ad = _safeParseDate(a.date);
        final bd = _safeParseDate(b.date);
        return bd.compareTo(ad); // latest first
      });

    for (var order in sorted) {
      if ((order.date ?? '').isEmpty) continue;
      final key = _groupKey(order.date!);
      groups.putIfAbsent(key, () => []).add(order);
    }

    // Sort sections: Today, Yesterday, then dates desc
    final sortedKeys = groups.keys.toList()
      ..sort((a, b) {
        if (a == "Today") return -1;
        if (b == "Today") return 1;
        if (a == "Yesterday") return -1;
        if (b == "Yesterday") return 1;

        // parse like "23 Jul 2025"
        final dateA = DateFormat('dd MMM yyyy').parse(a, true);
        final dateB = DateFormat('dd MMM yyyy').parse(b, true);
        return dateB.compareTo(dateA);
      });

    final Map<String, List<OrderInquiryModel>> out = {};
    for (final k in sortedKeys) {
      out[k] = groups[k]!;
    }
    return out;
  }

  void searchOrders(String query) {
    searchQuery.value = query;
  }

  bool canCancelOrder(String date, String time) {
    try {
      final orderDateTime = DateTime.parse("$date $time");
      return DateTime.now().isBefore(orderDateTime);
    } catch (_) {
      return false;
    }
  }

  // Helpers
  DateTime _safeParseDate(String? rawDate) {
    try {
      return DateTime.parse(rawDate ?? '');
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  String _groupKey(String rawDate) {
    try {
      final orderDate = DateTime.parse(rawDate);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final d = DateTime(orderDate.year, orderDate.month, orderDate.day);

      if (d == today) return "Today";
      if (d == yesterday) return "Yesterday";
      return DateFormat('dd MMM yyyy').format(orderDate);
    } catch (_) {
      return "Unknown Date";
    }
  }
}


