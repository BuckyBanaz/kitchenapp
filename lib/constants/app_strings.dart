import 'package:get/get.dart';

/// Keep these 4 as constants (no translation)
class AppStrings {
  // App Info (NO TRANSLATION)
  static const String appName = 'Ghar Ka Khana'; // Keep as is
  static const String number = '+918200328990'; // Keep as is
  static const String mapFrame =
      'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d7754366.476849691!2d68.01968344999997!3d18.378657138315717!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3be04db1c12da7bb%3A0x64f5c7f39a833498!2sV%20Square!5e0!3m2!1sen!2sin!4v1752684615500!5m2!1sen!2sin';
  static const String mapUrl =
      'https://www.google.com/maps/search/?api=1&query=21.2108866,72.7827166';

  /// NOTE: नीचे सारे getter हैं ताकि `.tr` हमेशा current locale के हिसाब से resolve हो।
  /// const के साथ .tr नहीं चलेगा, इसलिए getters use कर रहे हैं.

  // Home Screen
  static String get homeTitle => 'homeTitle'.tr;
  static String get exploreMenu => 'exploreMenu'.tr;
  static String get menu => 'Menu'; // Keep as is
  static String get bookOrder => 'bookOrder'.tr;
  static String get myOrders => 'myOrders'.tr;

  // Login
  static String get name => 'name'.tr;
  static String get phone => 'phone'.tr;
  static String get login => 'login'.tr;
  static String get logout => 'logout'.tr;

  // Splash Screen
  static String get splashTagline => 'splashTagline'.tr;

  // Buttons
  static String get exploreMenuEmoji => 'exploreMenuEmoji'.tr;
  static String get placeOrder => 'placeOrder'.tr;

  // Menu & Search
  static String get searchHint => 'searchHint'.tr;
  static String get custom => 'custom'.tr;
  static String get noItemsFound => 'noItemsFound'.tr;
  static String get cantFind => 'cantFind'.tr;
  static String get startType => 'startType'.tr;
  static String get allLabel => 'allLabel'.tr;

  // Errors / Messages
  static String get errorOccurred => 'errorOccurred'.tr;

  // Cart Screen
  static String get yourCart => 'yourCart'.tr;
  static String get cartEmpty => 'cartEmpty'.tr;
  static String get totalLabel => 'totalLabel'.tr;
  static String get addedToCart => 'addedToCart'.tr;
  static String get orderPlacedSuccess => 'orderPlacedSuccess'.tr;
  static String get enterYour => 'enterYour'.tr;

  // Finalize Order Screen
  static String get finalizeOrderTitle => 'finalizeOrderTitle'.tr;
  static String get editYourOrder => 'editYourOrder'.tr;
  static String get fieldName => 'fieldName'.tr;
  static String get fieldPhone => 'fieldPhone'.tr;
  static String get fieldAddress => 'fieldAddress'.tr;
  static String get enter_address => 'enter_address'.tr;
  static String get fieldPersons => 'fieldPersons'.tr;
  static String get hintextPerson => 'hintextPerson'.tr;
  static String get fieldInstructions => 'fieldInstructions'.tr;
  static String get hintName => 'hintName'.tr;
  static String get hintPhone => 'hintPhone'.tr;
  static String get hintAddress => 'hintAddress'.tr;
  static String get hintInstructions => 'hintInstructions'.tr;
  static String get instructions => 'instructions'.tr;
  static String get selectDate => 'selectDate'.tr;
  static String get selectTime => 'selectTime'.tr;
  static String get addMenuItems => 'addMenuItems'.tr;
  static String get menuSuffix => 'menuSuffix'.tr;
  static String get searchMenu => 'searchMenu'.tr;
  static String get orderSuccessLog => 'orderSuccessLog'.tr;
  static String get fillRequiredFields => 'fillRequiredFields'.tr;
  static String get addFoodItems => 'addFoodItems'.tr;
  static String get addAndSelect => 'addAndSelect'.tr;
  static String get addedSuffix => 'addedSuffix'.tr;
  static String get alreadySelected => 'alreadySelected'.tr;
  static String get selectedItems => 'selectedItems'.tr;
  static String get cancelOrder => 'cancelOrder'.tr;
  static String get updateOrder => 'updateOrder'.tr;
  static String get orderUpdated => 'orderUpdated'.tr;
  static String get hintAddItem => 'hintAddItem'.tr;
  static String get buttonAddMoreItems => 'buttonAddMoreItems'.tr;
  static String get confirm => 'confirm'.tr;
  static String get toastFillAllItems => 'toastFillAllItems'.tr;
  static String get callUs => 'callUs'.tr;

  // Logout dialog
  static String get confirmLogoutTitle => 'confirmLogoutTitle'.tr;
  static String get confirmLogoutBody => 'confirmLogoutBody'.tr;
  static String get cancel => 'cancel'.tr;
  static String get pleaseWait => 'pleaseWait'.tr;

  // Order details
  static String get orderDetails => 'orderDetails'.tr;
  static String get editOrder => 'editOrder'.tr;
  static String get backToOrders => 'backToOrders'.tr;
  static String get addressPrefix => 'addressPrefix'.tr;
  static String get addphonePrefix => 'addphonePrefix'.tr;
  static String get personPrefix => 'personPrefix'.tr;
  static String get orderedItems => 'orderedItems'.tr;
  static String get price => 'price'.tr;
  static String get orderTimeStatus => 'orderTimeStatus'.tr;
  static String get datePrefix => 'datePrefix'.tr;
  static String get timePrefix => 'timePrefix'.tr;
  static String get orderCancel => 'orderCancel'.tr;
  static String get statusPrefix => 'statusPrefix'.tr;
  static String get na => 'na'.tr;

  // Menu upload
  static String get chooseMenuTypeTitle => 'chooseMenuTypeTitle'.tr;
  static String get textButton => 'textButton'.tr;
  static String get imageButton => 'imageButton'.tr;
  static String get uploadMenuImageTitle => 'uploadMenuImageTitle'.tr;
  static String get chooseImage => 'chooseImage'.tr;
  static String get removeImage => 'removeImage'.tr;
  static String get confirmButton => 'confirmButton'.tr;
  static String get pleasePickImage => 'pleasePickImage'.tr;

  static String get chooseLanguage => 'chooseLanguage'.tr;
  static String get languageUpdated => 'languageUpdated'.tr;
  static String get appLanguageSetTo => 'appLanguageSetTo'.tr;
  static String get languageTitle => 'languageTitle'.tr;

  static String get yesLogout => 'yesLogout'.tr;
  static String get noText => 'noText'.tr;
  static String get confirm_order => 'confirm_order'.tr;
  static String get confirm_msg => 'confirm_msg'.tr;
  static String get no => 'no'.tr;
  static String get yes => 'yes'.tr;
  static String get order_confirmed_edit_hint => 'order_confirmed_edit_hint'.tr;
  static String get no_internet_title => 'no_internet_title'.tr;
  static String get no_internet_desc => 'no_internet_desc'.tr;
  static String get retry => 'retry'.tr;
  static String get no_internet_short => 'no_internet_short'.tr;
  static String get still_offline => 'still_offline'.tr;
}


