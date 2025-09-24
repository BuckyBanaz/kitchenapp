
import 'package:get/get.dart';
import 'package:orderapp/constants/app_strings.dart';
import 'package:orderapp/screen/auth/authscreen.dart';
import 'package:orderapp/screen/home/homescreen.dart';
import 'package:orderapp/screen/notification/notificationscreen.dart';
import 'package:orderapp/screen/order/cart_screen.dart';
import 'package:orderapp/screen/order/editOrderScreen.dart';
import 'package:orderapp/screen/splash/splashscreen.dart';

import '../screen/menu/menuscreen.dart';
import '../screen/order/finalize_order_screen.dart';
import '../screen/order/orderDetailsScreen.dart';
import '../screen/order/order_confirmation_view.dart';
import '../screen/order/ordersScreen.dart';
import '../screen/settings/settingsScreen.dart';


class Routes{

  static const splash = '/splash';
  static const auth = '/auth';
  static const home = '/home';
  static const menu = '/menu';
  static const cart = '/cart';
  static const order = '/order';
  static const notification = '/notification';
  static const orderConfirmationView = '/orderConfirmationView';
  static const profile = '/profile';
  static const myOrders = "/myOrders";
  static const orderDetailsScreen = "/orderDetailsScreen";
  static const editOrder = "/editOrderScreen";
  static const settings = "/settings";

  static  get routes => [
    GetPage(name: splash, page: () =>  SplashScreen()),
    GetPage(name: auth, page: () =>  AuthScreen()),
    GetPage(name: home, page: () =>  HomeScreen(),transition: Transition.rightToLeft),
    GetPage(name: menu, page: () =>  MenuScreen(),transition: Transition.rightToLeft),
    // GetPage(name: cart, page: () =>  CartScreen(),transition: Transition.rightToLeft),
    GetPage(name: order, page: () =>  FinalizeOrderScreen(),transition: Transition.rightToLeft),
    GetPage(name: notification, page: () =>   NotificationScreen(),transition: Transition.rightToLeft),
    GetPage(name: orderConfirmationView, page: () =>   OrderConfirmationView(),transition: Transition.rightToLeft),
    GetPage(name: myOrders, page: () =>   OrdersScreen(),transition: Transition.rightToLeft),
    GetPage(name: orderDetailsScreen, page: () =>   OrderDetailsScreen(),transition: Transition.rightToLeft),
    GetPage(name: editOrder, page: () =>   EditOrderScreen(),transition: Transition.rightToLeft),
    GetPage(name: settings, page: () =>   SettingsScreen(),transition: Transition.rightToLeft),
  ];
}
