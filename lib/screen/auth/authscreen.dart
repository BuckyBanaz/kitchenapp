
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../constants/app_strings.dart';

import '../../services/controllers/adsController.dart';
import '../../services/controllers/authController.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthController controller = Get.put(AuthController());

  final adsController = Get.find<AdsController>(); // <-- Find Ad Controller


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
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(AppStrings.login)),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Name Input
                  CustomInputField(
                    label: AppStrings.name,
                    controller: controller.nameController,
                    currentFocus: controller.nameFocus,
                    nextFocus: controller.phoneFocus,
                  ),
                  const SizedBox(height: 16),

                  // Phone Input
                  CustomInputField(
                    label: AppStrings.phone,
                    controller: controller.phoneController,
                    currentFocus: controller.phoneFocus,
                    inputAction: TextInputAction.done,
                    keyboardType: TextInputType.phone,
                    onDone: controller.login,
                  ),
                  const SizedBox(height: 30),

                  // Login Button
                  CustomRedButton(text: 'Login', onPressed: controller.login),
                  Spacer(),

                  const SizedBox(height: 30),

                  if (_isBannerLoaded && _myBanner != null)
                    SizedBox(
                      width: _myBanner!.size.width.toDouble(),
                      height: _myBanner!.size.height.toDouble(),
                      child: AdWidget(ad: _myBanner!),
                    ),

                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
