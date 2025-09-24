import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:orderapp/constants/app_images.dart';
import '../../constants/app_strings.dart';
import '../../routes/appRoutes.dart';
import '../../services/DbService.dart';

import '../../services/controllers/adsController.dart'; // <-- import your AdsController

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool hasNavigated = false;

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  // Future<void> checkAuth() async {
  //   await Future.delayed(const Duration(seconds: 1)); // Splash delay
  //   DbService.clearDb();
  //
  //   print("Ad status: ${adsController.interstitialAd != null ? "Loaded" : "Not Loaded"}");
  //   int retry = 0;
  //
  //   while (adsController.interstitialAd == null && retry < 3) {
  //     await Future.delayed(const Duration(seconds: 1));
  //     retry++;
  //   }
  //
  //   if (adsController.interstitialAd != null) {
  //     adsController.interstitialAd!.fullScreenContentCallback =
  //         FullScreenContentCallback(
  //           onAdDismissedFullScreenContent: (ad) {
  //             ad.dispose();
  //             adsController.loadInterstitialAd();
  //             if (!hasNavigated) {
  //               hasNavigated = true;
  //               Get.offAllNamed(Routes.home);
  //             }
  //           },
  //           onAdFailedToShowFullScreenContent: (ad, error) {
  //             ad.dispose();
  //             adsController.loadInterstitialAd();
  //             if (!hasNavigated) {
  //               hasNavigated = true;
  //               Get.offAllNamed(Routes.home);
  //             }
  //           },
  //         );
  //
  //     adsController.interstitialAd!.show();
  //   } else {
  //     if (!hasNavigated) {
  //       hasNavigated = true;
  //       Get.offAllNamed(Routes.home);
  //     }
  //   }
  // }
  Future<void> checkAuth() async {
    await Future.delayed(const Duration(seconds: 3)); // Splash delay
    // DbService.clearDb();

    Get.offAllNamed(Routes.home);
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Just static content to avoid rebuild issues
              Image(
                image: AssetImage(AppImages.logo),
                height: 200,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 24),
              Text(
                AppStrings.splashTagline,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
