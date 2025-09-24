import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconly/iconly.dart';
import 'package:orderapp/constants/app_strings.dart';
import 'package:orderapp/constants/app_colors.dart';
import 'package:orderapp/routes/appRoutes.dart';
import 'package:shimmer/shimmer.dart';

import '../../services/controllers/adsController.dart';
import '../../services/controllers/menuController.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input_field.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final adsController = Get.find<AdsController>();
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
    final MenusController controller = Get.put(MenusController());

    return Obx(() {
      return DefaultTabController(
        length: controller.categoriesList.length,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(96),
            child: Obx(() {
              return AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: controller.isSearching.value
                    ? CustomInputField(
                  autofocus: true,
                  decoration:  InputDecoration(
                    hintText: AppStrings.searchHint,
                  ),
                  style: Theme.of(context).textTheme.titleMedium,
                  onChanged: (query) {
                    controller.searchQuery.value = query;
                  },
                )
                    : Text(AppStrings.menu),
                leading: controller.isSearching.value
                    ? null
                    : IconButton(
                  icon: const Icon(IconlyLight.arrow_left_2),
                  onPressed: () {
                    // if (adsController.interstitialAd != null) {
                    //   adsController.interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
                    //     onAdDismissedFullScreenContent: (ad) {
                    //       ad.dispose();
                    //       adsController.loadInterstitialAd();
                    //       Get.back();
                    //     },
                    //     onAdFailedToShowFullScreenContent: (ad, error) {
                    //       ad.dispose();
                    //       adsController.loadInterstitialAd();
                    //       Get.back();
                    //     },
                    //   );
                    //   adsController.interstitialAd!.show();
                    // } else {
                    //   Get.back();
                    // }

                    Get.back();
                  },
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      controller.isSearching.value
                          ? Icons.close
                          : IconlyLight.search,
                    ),
                    onPressed: () {
                      if (controller.isSearching.value) {
                        controller.searchQuery.value = '';
                      }
                      controller.isSearching.toggle();
                    },
                  ),
                ],
                bottom: controller.isLoading.value || controller.isSearching.value
                    ? null
                    : PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: TabBar(
                    isScrollable: true,
                    tabs: controller.categoriesList
                        .map((type) => Tab(text: type.name))
                        .toList(),
                  ),
                ),
              );
            }),
          ),
          body: controller.isLoading.value
              ? buildShimmerList()
              : TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: controller.categoriesList.map((category) {
              return Obx(() {
                final filteredMenus = controller.getMenusByTypeId(category.id);
                if (filteredMenus.isEmpty) {
                  return Center(
                    child: Text(AppStrings.noItemsFound),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredMenus.length,
                  itemBuilder: (context, index) {
                    final item = filteredMenus[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Icon(
                            Icons.fastfood,
                            size: 40,
                            color: AppColors.primary,
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                );
              });
            }).toList(),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 24, left: 12, right: 12),
            child: CustomRedButton(
              text: AppStrings.bookOrder,
              onPressed: () {
                Get.toNamed(Routes.order);
              },
            ),
          ),
        ),
      );
    });
  }

  Widget buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: double.infinity,
                        height: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 80,
                        height: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}