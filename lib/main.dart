import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'services/DbService.dart';
import 'services/api_client.dart';
import 'services/controllers/adsController.dart';
import 'services/controllers/home_controller.dart';
import 'services/controllers/network_controller.dart';
import 'core/app.dart';


const _buildToken = String.fromEnvironment('BUILD_TOKEN', defaultValue: '');

bool _tokenLooksValid(String t) {
  return t.startsWith('KITCHEN-ACCESS-') && t.length >= 24;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  if (!_tokenLooksValid(_buildToken)) {

    SystemNavigator.pop();
    exit(0);
  }

  MobileAds.instance.initialize();
  await DbService.init();
  ApiClient.loadTokenFromDb();

  Get.put(AdsController());
  Get.put(HomeController(), permanent: true);
  await Get.putAsync<NetworkController>(
        () async => NetworkController().init(),
    permanent: true,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const GherKaKhanaApp());
}
