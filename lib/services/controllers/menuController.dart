import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../models/categories_model.dart';
import '../../models/menu_model.dart';
import '../repositories/categoryRepository.dart';
import '../repositories/menuRepository.dart';

class MenusController extends GetxController {
  final MenuRepository _menuRepo = MenuRepository();
  final CategoryRepository _categoryRepo = CategoryRepository();

  var isSearching = false.obs;
  var searchQuery = ''.obs;


  var menus = <MenuModel>[].obs;
  var categoriesList = <CategoryModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchInitialData();
    super.onInit();
  }


  Future<void> fetchInitialData() async {
    try {
      isLoading.value = true;
      final menuData = await _menuRepo.fetchMenus();
      final typeData = await _categoryRepo.fetchCategories();
      menus.assignAll(menuData);
      categoriesList.assignAll(typeData);
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }


  // List<MenuModel> getMenusByTypeId(int? typeId) {
  //   final filtered = (typeId == null)
  //       ? menus
  //       : menus.where((item) => item.categoryId == typeId).toList();
  //
  //   if (searchQuery.value.isEmpty) return filtered;
  //
  //   return filtered
  //       .where((item) =>
  //       item.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
  //       .toList();
  //
  // }


  List<MenuModel> getMenusByTypeId(int? typeId) {
    final filtered = (typeId == null)
        ? menus
        : menus.where((item) => item.categoryId == typeId).toList();

    if (searchQuery.value.isEmpty) return filtered;

    return filtered
        .where((item) =>
        item.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }
}
