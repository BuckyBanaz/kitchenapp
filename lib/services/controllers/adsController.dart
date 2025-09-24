import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsController extends GetxController {
  // Ad unit IDs from client
  final String bannerAdUnit = 'ca-app-pub-1552915451565536/5128063317';
  final String interstitialAdUnit = 'ca-app-pub-1552915451565536/3431020020';
  final String inAppAds = 'ca-app-pub-1552915451565536/5152114041';

  late BannerAd bannerAd;
  InterstitialAd? interstitialAd;
  var isBannerAdLoaded = false.obs;
  BannerAd? inAppBannerAd;
  var isinAppBannerLoaded = false.obs;
  @override
  void onInit() {
    super.onInit();
    _initBannerAd();
    loadInterstitialAd();
    loadinAppBannerAd();
  }

  void _initBannerAd() {
    bannerAd = BannerAd(
      adUnitId: bannerAdUnit,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isBannerAdLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  void loadInterstitialAd() {

    InterstitialAd.load(
      adUnitId: interstitialAdUnit,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          interstitialAd = null;
        },
      ),
    );
  }


  void showInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd!.show();
      loadInterstitialAd(); // Reload for next use
    }
  }

// inside AdsController class, add this method:
  Future<void> showPriorityAd({required VoidCallback onComplete}) async {
    try {
      // 1) Try to show in-app banner (as priority)
      if (inAppBannerAd != null && isinAppBannerLoaded.value) {
        // Show banner inside a non-dismissible dialog for a short time
        Get.dialog(
          Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26)],
                ),
                child: SizedBox(
                  height: inAppBannerAd!.size.height.toDouble(),
                  width: inAppBannerAd!.size.width.toDouble(),
                  child: AdWidget(ad: inAppBannerAd!),
                ),
              ),
            ),
          ),
          barrierDismissible: false,
        );

        // show for short time (2 seconds) then close and complete
        await Future.delayed(const Duration(seconds: 2));
        if (Get.isDialogOpen ?? false) Get.back();

        // Optionally reload the in-app banner for next time
        // dispose old then load new
        inAppBannerAd?.dispose();
        isinAppBannerLoaded.value = false;
        loadinAppBannerAd();

        onComplete();
        return;
      }

      // 2) If in-app not available, try interstitial
      if (interstitialAd != null) {
        interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            try { ad.dispose(); } catch (_) {}
            loadInterstitialAd(); // reload for next time
            onComplete();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            try { ad.dispose(); } catch (_) {}
            loadInterstitialAd();
            onComplete();
          },
        );

        interstitialAd!.show();
        // set to null so we don't reuse same instance
        interstitialAd = null;
        return;
      }

      // 3) Neither ad available -> just continue
      onComplete();
    } catch (e) {
      // if anything fails, ensure we still continue
      onComplete();
    }
  }
  BannerAd createNewBannerAd(Function onAdLoaded) {
    return BannerAd(
      adUnitId: bannerAdUnit,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onAdLoaded(),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }
  void loadinAppBannerAd() {
    inAppBannerAd = BannerAd(
      adUnitId: inAppAds,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isinAppBannerLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          isinAppBannerLoaded.value = false;
        },
      ),
    )..load();
  }

  @override
  void onClose() {
    bannerAd.dispose();
    interstitialAd?.dispose();
    inAppBannerAd!.dispose();
    super.onClose();
  }
}
