import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import '../routes/appRoutes.dart';
import '../routes/navigator_service.dart';
import '../services/controllers/locale_controller.dart';
import '../constants/app_strings.dart';
import '../translation/AppTranslations.dart';
import 'appTheme.dart';

class GherKaKhanaApp extends StatelessWidget {
  const GherKaKhanaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.put(LocaleController(), permanent: true);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      translations: AppTranslations(),
      locale: const Locale('gu', 'IN'),
      fallbackLocale: const Locale('en', 'US'),

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: localeController.supported,

      navigatorKey: NavigatorService.navigatorKey,
      initialRoute: Routes.splash,
      getPages: Routes.routes,
      theme: AppTheme.lightTheme,
    );
  }
}
