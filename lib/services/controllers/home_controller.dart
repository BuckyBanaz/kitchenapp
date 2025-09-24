import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderapp/constants/app_strings.dart';
import 'package:orderapp/utils/toast_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../repositories/imagerepo.dart';

class HomeController extends GetxController {
  late final WebViewController webViewController;
  bool _hasShownImage = false;
  // /// Single map URL
  // final String mapUrl =
  //     'https://www.google.com/maps/search/?api=1&query=V+Square';
  RxString imageUrl = ''.obs;
  @override
  void onInit() {
    super.onInit();
    print("HomeController initialized");
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString('''
        <html>
          <body style="margin:0;padding:0;">
            <iframe 
              src="${AppStrings.mapFrame}"
              width="100%" height="100%" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
          </body>
        </html>
      ''');
     // 🖼️ Call when controller initializes
  }
  Future<void> fetchPopupImage(BuildContext context) async {
    if (_hasShownImage) return;

    final image = await Imagerepo.fetchStartImage();
    if (image != null) {
      imageUrl.value = image;
      _hasShownImage = true;

      // Show the dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _buildImagePopup(context, image),
      );

      // ⏳ Auto-dismiss after 5 seconds
      Future.delayed(Duration(seconds: 5), () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  /// External map opener using the same URL
  Future<void> openMapIntent() async {
    final Uri uri = Uri.parse(AppStrings.mapUrl);

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      showToast("Could not launch Google Maps");
      print('launch error: $e');
    }
  }
  void launchCaller() async {
    final Uri uri = Uri(scheme: 'tel', path:  AppStrings.number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Emulator fallback
      if (GetPlatform.isAndroid && !await launchUrl(uri)) {
        showToast("📞 Call UI not supported on this device/emulator");
      }
    }
  }

  Widget _buildImagePopup(BuildContext context, String imageUrl) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Center(
            child: InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (ctx, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (ctx, url, err) => Center(
                      child: Icon(Icons.broken_image, size: 48, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.cancel_rounded, size: 36, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }


}
