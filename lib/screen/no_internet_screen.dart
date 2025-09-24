import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NoInternetScreen extends StatelessWidget {
  static const route = '/no-internet';
  const NoInternetScreen({super.key});

  Future<void> _retry(BuildContext context) async {
    final ok = await InternetConnection().hasInternetAccess;
    if (ok) {
      if (Navigator.of(context).canPop()) {
        Get.back();
      }
    } else {
      Get.snackbar(
        'no_internet_short'.tr, // "No Internet"
        'still_offline'.tr,     // "Still offline"
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async => false, // disable back
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.wifi_exclamationmark, size: 84, color: Colors.black),
                  const SizedBox(height: 16),
                  Text(
                    'no_internet_title'.tr, // "No Internet Connection"
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'no_internet_desc'.tr, // description
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 44,
                    child: FilledButton(
                      onPressed: () => _retry(context),
                      child: Text('retry'.tr), // "Retry"
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
