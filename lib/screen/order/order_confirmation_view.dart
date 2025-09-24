import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:orderapp/constants/app_strings.dart';
import 'package:orderapp/routes/appRoutes.dart';
import 'package:orderapp/screen/widgets/custom_button.dart';

import '../../services/controllers/adsController.dart';



class OrderConfirmationController {
  void orderAgain() {
    // Logic for reordering (e.g. navigate back to product page)

    Get.offNamed(Routes.myOrders);
    debugPrint("Order Again button tapped!");
    // Example:
    // Navigator.of(context).pushReplacementNamed('/order');
  }
}

class OrderConfirmationView extends StatefulWidget {
  @override
  State<OrderConfirmationView> createState() => _OrderConfirmationViewState();
}

class _OrderConfirmationViewState extends State<OrderConfirmationView> {
  final OrderConfirmationController controller = OrderConfirmationController();

  final adsController = Get.find<AdsController>();
 // <-- Find Ad Controller
  BannerAd? _myBanner;

  bool _isBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    _myBanner = adsController.createNewBannerAd(() {
      setState(() {
        _isBannerLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderId = Get.arguments?['orderId']; // Get passed order ID

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.offAllNamed(Routes.home),
        ),
        title: const Text(
          'Order Confirmed',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.check_box, color: Colors.green, size: 32),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Order #$orderId confirmed! ${AppStrings.order_confirmed_edit_hint}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
            if (_isBannerLoaded && _myBanner != null)
              SizedBox(
                width: _myBanner!.size.width.toDouble(),
                height: _myBanner!.size.height.toDouble(),
                child: AdWidget(ad: _myBanner!,),
              ),
            const SizedBox(height: 40),
            CustomRedButton(
              onPressed: () {
                if (adsController.interstitialAd != null) {
                  adsController.interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
                    onAdDismissedFullScreenContent: (ad) {
                      ad.dispose();
                      adsController.loadInterstitialAd(); // Reload for next time
                      controller.orderAgain();
                    },
                    onAdFailedToShowFullScreenContent: (ad, error) {
                      ad.dispose();
                      adsController.loadInterstitialAd(); // Reload for next time
                      controller.orderAgain();
                    },
                  );

                  adsController.interstitialAd!.show();
                } else {
                  // If ad not loaded, navigate directly
                  controller.orderAgain();
                }

              },

              // onPressed: controller.orderAgain,
              text: AppStrings.myOrders,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

