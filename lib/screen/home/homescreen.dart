
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconly/iconly.dart';
import 'package:orderapp/constants/app_colors.dart';
import 'package:orderapp/routes/appRoutes.dart';
import 'package:orderapp/services/DbService.dart';
import '../../constants/app_strings.dart';
import '../../services/controllers/adsController.dart';
import '../widgets/custom_button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:orderapp/services/controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final adsController = Get.find<AdsController>(); // <-- Find Ad Controller
    final screenHeight = MediaQuery.of(context).size.height;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchPopupImage(context);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppStrings.appName),
        centerTitle: true,
        actions: [
          IconButton(onPressed: ()=> Get.toNamed(Routes.settings), icon: Icon(IconlyLight.setting))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                     Text(
                      AppStrings.homeTitle,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    CustomRedButton(
                      text: AppStrings.exploreMenu,
                      icon: Icons.restaurant_menu_rounded,
                      onPressed: () {
                        Get.toNamed(Routes.menu);
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomRedButton(
                      text: AppStrings.bookOrder,
                      icon: Icons.shopping_cart,
                      onPressed: () {
                        Get.toNamed(Routes.order);
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomRedButton(
                      text: AppStrings.myOrders,
                      icon: Icons.bookmark,
                      onPressed: () {
                        final navigateAction = () {
                          if (DbService.getCustomer() == null) {
                            Get.toNamed(Routes.auth, arguments: "myorders");
                          } else {
                            Get.toNamed(Routes.myOrders);
                          }
                        };

                        // Use the new helper to show priority ad then navigate
                        adsController.showPriorityAd(onComplete: navigateAction);
                      },
                    ),

                    const SizedBox(height: 20),
                    CustomRedButton(
                      text: AppStrings.callUs,
                      icon: Icons.call,
                      onPressed: controller.launchCaller,
                    ),
                    const SizedBox(height: 20),

                    // 🗺 MAP CONTAINER
                    Container(
                      height: screenHeight * 0.35,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Stack(
                        children: [
                          WebViewWidget(controller: controller.webViewController),
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: controller.openMapIntent,
                              child: Container(color: Colors.transparent),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 👇 BANNER AD AT BOTTOM
            Obx(() {
              if (adsController.isBannerAdLoaded.value) {
                return SizedBox(
                  height: adsController.bannerAd.size.height.toDouble(),
                  width: adsController.bannerAd.size.width.toDouble(),
                  child: AdWidget(ad: adsController.bannerAd),
                );
              } else {
                return const SizedBox(); // Placeholder if not loaded
              }
            }),
          ],
        ),
      ),
    );
  }



}
