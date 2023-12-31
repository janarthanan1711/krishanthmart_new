import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/category_model.dart';
import '../models/product_response_model.dart';
import '../models/sub_child_model.dart';
import '../repositories/category_repositories.dart';
import '../repositories/product_repository.dart';

class SubCategoryController extends GetxController {
  var subChildCategories = <SubChildCategories>[].obs;
  var categoryProductList = <Product>[].obs;
  var allCategoryProductList = <Product>[].obs;
  var subCategoryList = [].obs;
  var mainCategoryList = [].obs;
  var mainCategoryListSheet = [].obs;
  int? totalData = 0;
  var subCategoryIndex = 0.obs;
  bool showLoadingContainer = false;
  RxBool isInitial = true.obs;
  RxBool showAllProducts = true.obs;
  RxBool isLoading = false.obs;
  var selectedIndex = 0.obs;
  var subSelectedIndex = 0.obs;
  var selectedMainCategoryTitle = "".obs;
  var mainNameChanged = false.obs;

  getSubChildCategories(int subChildCategory) async {
    subChildCategories.clear();
    var subChildCategoriesRes = await CategoryRepository()
        .getSubChildCategories(categoryId: subChildCategory);
    subChildCategories.addAll(subChildCategoriesRes.subChildCategory);
    update();
  }

  getSubCategory(int? categoryId) async {
    var res = await CategoryRepository().getCategories(parent_id: categoryId);
    subCategoryList.addAll(res.categories!);
    update();
  }

  getCategoryProducts(
      {int? categoryId, int page = 1, String? searchKey}) async {
    categoryProductList.clear();
    isLoading(true);
    // print("called");
    var productResponse = await ProductRepository()
        .getCategoryProducts(id: categoryId, page: page, name: searchKey);
    categoryProductList.addAll(productResponse.products!);
    // print("Check is Empty ${categoryProductList.isEmpty}");
    // print("closed $page");
    totalData = productResponse.meta!.total;
    isLoading(false);
    isInitial.value = false;
    showLoadingContainer = false;
    update();
  }

  getAllCategoryProducts({int? categoryId, int page = 1, String? searchKey}) async {
    allCategoryProductList.clear();
    isLoading(true);
    var allProductResponse = await ProductRepository()
        .getCategoryProducts(id: categoryId, page: page, name: searchKey);
    allCategoryProductList.addAll(allProductResponse.products!);
    totalData = allProductResponse.meta!.total;
    isLoading(false);
  }

  getMainCategories(int? id) async {
    var categoriesAll = await CategoryRepository().getCategories(parent_id: id);
    mainCategoryList.addAll(categoriesAll.categories! ?? []);
    update();
  }

  clearAll() {
    subChildCategories.clear();
    categoryProductList.clear();
    subCategoryList.clear();
    mainCategoryList.clear();
    allCategoryProductList.clear();
    // page = 1;
    // searchKey = "";
    totalData = 0;
    subCategoryIndex.value = 0;
    showLoadingContainer = false;
    isInitial.value = true;
    showAllProducts.value = false;
    mainNameChanged.value = false;
    selectedIndex.value = 0;
    update();
  }
}
