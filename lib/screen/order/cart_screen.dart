// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconly/iconly.dart';
// import 'package:orderapp/constants/app_colors.dart';
// import 'package:orderapp/constants/app_strings.dart';
// import 'package:orderapp/routes/appRoutes.dart';
// import 'package:orderapp/screen/widgets/custom_button.dart';
// import '../../models/menu_model.dart';
//
// class CartController extends GetxController {
//   var cartItems = <MenuModel>[].obs;
//
//   void addToCart(MenuModel item) {
//     cartItems.add(item);
//   }
//
//   int get itemCount => cartItems.length;
//
//   double get totalPrice =>
//       cartItems.fold(0, (sum, item) => sum + (item.price ?? 0));
// }
//
// class CartScreen extends StatelessWidget {
//   const CartScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final CartController cartController = Get.find();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(AppStrings.yourCart),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: Icon(IconlyLight.arrow_left_2),
//         ),
//       ),
//       body: Obx(() {
//         if (cartController.cartItems.isEmpty) {
//           return const Center(child: Text(AppStrings.cartEmpty));
//         }
//
//         return Column(
//           children: [
//             Expanded(
//               child: ListView.separated(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: cartController.cartItems.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 12),
//                 itemBuilder: (context, index) {
//                   final item = cartController.cartItems[index];
//                   return Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           blurRadius: 6,
//                           offset: const Offset(0, 2),
//                           color: Colors.grey.withOpacity(0.15),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         const Icon(Icons.fastfood, size: 28),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 item.name,
//                                 style: Theme.of(context).textTheme.bodyLarge
//                                     ?.copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 '₹ ${item.price}',
//                                 style: Theme.of(context).textTheme.bodyMedium
//                                     ?.copyWith(color: Colors.grey[600]),
//                               ),
//                             ],
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(
//                             IconlyLight.delete,
//                             color: AppColors.primary,
//                           ),
//                           onPressed: () {
//                             cartController.cartItems.removeAt(index);
//                           },
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             // Bottom section
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 border: const Border(
//                   top: BorderSide(color: Colors.grey, width: 0.2),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Obx(
//                     () => Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           AppStrings.totalLabel,
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           "₹ ${cartController.totalPrice.toStringAsFixed(2)}",
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   CustomRedButton(
//                     onPressed: () {
//                       // Get.snackbar("Order Placed", "Your order has been placed successfully!",
//                       //     snackPosition: SnackPosition.BOTTOM);
//                       // cartController.cartItems.clear();
//                       Get.toNamed(Routes.order);
//                     },
//                     text: AppStrings.placeOrder,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }
