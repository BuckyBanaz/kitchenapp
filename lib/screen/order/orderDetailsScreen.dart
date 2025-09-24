import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:orderapp/routes/appRoutes.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/orderInquiryModel.dart';
import '../../services/controllers/getOrdersController.dart';
import '../../services/repositories/getOrdersRepository.dart';
import '../widgets/custom_button.dart';


class OrderDetailsController extends GetxController {
  late final int orderId;

  final Rxn<OrderInquiryModel> order = Rxn<OrderInquiryModel>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    orderId = Get.arguments as int; // ✅ assign first
    log("Received orderId: $orderId");
    fetchOrderDetails(); // ✅ then fetch
  }

  Future<void> fetchOrderDetails() async {
    try {
      isLoading.value = true;
      log("Fetching order with ID: $orderId");
      final result = await GetOrdersRepository().getOrderById(orderId);
      if (result != null) {
        order.value = result;
      } else {
        errorMessage.value = "Failed to fetch order.";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
    } finally {
      isLoading.value = false;
    }
  }

  bool canCancelOrder(String date, String time) {
    try {
      final orderDateTime = DateTime.parse("$date $time");
      return DateTime.now().isBefore(orderDateTime);
    } catch (e) {
      return false;
    }
  }
}



class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final OrderDetailsController controller = Get.put(OrderDetailsController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchOrderDetails();
    });
    final GetOrdersController C = Get.put(GetOrdersController());

    return GetBuilder<OrderDetailsController>(
      init: OrderDetailsController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title:  Text(AppStrings.orderDetails),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(IconlyLight.arrow_left_2),
              onPressed: () => Get.back(),
            ),
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.order.value == null) {
              return Center(child: Text(controller.errorMessage.value));
            }

            final order = controller.order.value!;
            final menuItems = order.menu;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long_rounded, size: 80, color: AppColors.primary),
                  const SizedBox(height: 12),
                  Text("Order #${order.id}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("${AppStrings.addressPrefix}${order.address ?? AppStrings.na}", textAlign: TextAlign.center),
                  const Divider(height: 32),
                  _InfoTile(label: AppStrings.addphonePrefix, value: order.additionalNumber ?? AppStrings.na),
                  _InfoTile(label: AppStrings.personPrefix, value: order.person ?? AppStrings.na),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(AppStrings.orderedItems, style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  if (double.tryParse(order?.price ?? '0') != 0) ...[
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${AppStrings.price} ${order?.price ?? ''}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),
                  ...menuItems.map((item) => _OrderItem(name: item.item)),
                  SizedBox(height: 8,),
                  if(order.image != null)
                    GestureDetector(
                      onTap: () {
                        Get.dialog(
                          Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: EdgeInsets.all(0),
                            child: Stack(
                              children: [
                                _ZoomableSwipeImageViewer(imageUrl: order!.image ?? ""),
                                // Close button
                                Positioned(
                                  top: 20,
                                  right: 20,
                                  child: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                                    onPressed: () => Get.back(),
                                  ),
                                ),
                                // Download button

                              ],
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          order!.image ?? "",
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),
                 Align(
                    alignment: Alignment.centerLeft,
                    child: Text(AppStrings.orderTimeStatus, style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "${AppStrings.instructions}${order.note ?? AppStrings.na}"
                      "${AppStrings.datePrefix}${order.date ?? AppStrings.na}\n"
                          "${AppStrings.timePrefix}${_formatTime(order.time)}\n"
                          "${AppStrings.statusPrefix}${order.status ?? AppStrings.na}"

                    ),
                  ),




                  if (order.status == 'Booked') ...[
                    const SizedBox(height: 24),
                    if (controller.canCancelOrder(order.date!, order.time!))
                      CustomRedButton(
                        text: AppStrings.editOrder,
                        color: AppColors.lightGrey,
                        textColor: AppColors.black,
                        onPressed: () async {
                          final result = await Get.toNamed(Routes.editOrder, arguments: order);
                          if (result == true) {
                            await controller.fetchOrderDetails();
                            final listController = Get.isRegistered<GetOrdersController>() ? Get.find<GetOrdersController>() : null;
                            listController?.fetchOrders();
                          }
                        },
                      ),


                    const SizedBox(height: 24),
                    controller.canCancelOrder(order.date!, order.time!)
                        ? CustomRedButton(
                      text: AppStrings.cancel,
                      onPressed: () {
                        controller.isLoading.value = true;
                        C.cancelOrder(order.id);
                        controller.isLoading.value = false;
                      },
                    )
                        : Text("Cancellation window has expired.", style: TextStyle(color: Colors.red.shade400)),
                  ],
                  if(order.status == 'Canceled') ...[
                    const SizedBox(height: 24),
                    Text("${AppStrings.orderCancel}")
                  ]
                ],
              ),
            );
          }),
        );
      },
    );
  }

  String _formatTime(String? time) {
    if (time == null) return AppStrings.na;
    try {
      final t = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("hh:mm a").format(t);
    } catch (e) {
      return time;
    }
  }
}


class _OrderItem extends StatelessWidget {
  final String name;

  const _OrderItem({required this.name});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.fastfood, size: 20, color: AppColors.primary),
      title: Text(name),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          "$label$value",
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}


class _ZoomableSwipeImageViewer extends StatefulWidget {
  final String imageUrl;
  const _ZoomableSwipeImageViewer({required this.imageUrl});

  @override
  State<_ZoomableSwipeImageViewer> createState() => _ZoomableSwipeImageViewerState();
}

class _ZoomableSwipeImageViewerState extends State<_ZoomableSwipeImageViewer> {
  final TransformationController _controller = TransformationController();
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTransformChanged);
  }

  void _onTransformChanged() {
    final matrix = _controller.value;
    final zoomLevel = matrix.getMaxScaleOnAxis();
    setState(() {
      _isZoomed = zoomLevel > 1.0;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onTransformChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: _isZoomed
          ? null
          : (details) {
        if (details.primaryVelocity! < 0) {
          print("Swiped Left → Show next image");
        } else if (details.primaryVelocity! > 0) {
          print("Swiped Right → Show previous image");
        }
      },
      child: Center(
        child: InteractiveViewer(
          transformationController: _controller,
          panEnabled: true,
          scaleEnabled: true,
          minScale: 1.0,
          maxScale: 5.0,
          child: Image.network(
            widget.imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
