import 'package:get/get.dart';

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
  var totalData = 0.obs;
  var subCategoryIndex = 0.obs;
  bool showLoadingContainer = false;
  RxBool isInitial = true.obs;
  RxBool showAllProducts = true.obs;
  RxBool isLoading = false.obs;
  var selectedIndex = 0.obs;
  var subSelectedIndex = 0.obs;
  var selectedMainCategoryTitle = "".obs;
  var mainNameChanged = false.obs;
  var categoryProductId = 0.obs;
  var allCategoryProductId = 0.obs;
  var subChildCategoryId = 0.obs;


  @override
  void onClose() {
    clearAll();
    super.onClose();
  }

  subCategoryIndexSelection(subCategoryId) {
    int selectedIndexes = subCategoryList
        .indexWhere((subcategory) => subcategory.id == subCategoryId);
    selectedIndex.value = selectedIndexes;
    update();
  }

  getSubChildCategories(int subChildCategory) async {
    subChildCategories.clear();
    var subChildCategoriesRes = await CategoryRepository()
        .getSubChildCategories(categoryId: subChildCategory);
    subChildCategories.addAll(subChildCategoriesRes.subChildCategory);
    // subCategoryIndexSelection(subChildCategory);
    update();
  }

  getSubCategory(int? categoryId) async {
    print("subCategoryCalled");
    // var res = await CategoryRepository().getCategories(parent_id: categoryId);
    // subCategoryList.addAll(res.categories!);
    //if any problems change above code
    subCategoryList.clear();
    var res = await CategoryRepository()
        .getSubChildCategories(categoryId: categoryId);
    subCategoryList.addAll(res.subChildCategory);
    subCategoryIndexSelection(categoryId);
    update();
  }

  getCategoryProducts(
      {int? categoryId, int page = 1, String? searchKey, int? index}) async {
    categoryProductList.clear();
    isLoading(true);
    // print("called");
    var productResponse = await ProductRepository()
        .getCategoryProducts(id: categoryId, page: page, name: searchKey);
    categoryProductList.addAll(productResponse.products!);
    // print("Check is Empty ${categoryProductList.isEmpty}");
    // print("closed $page");
    print("Total Page of product======>${page}");
    categoryProductId.value = categoryId!;
    totalData.value = productResponse.meta!.total!;
    isLoading(false);
    isInitial.value = false;
    showLoadingContainer = false;
    update();
  }

  getAllCategoryProducts(
      {int? categoryId, int page = 1, String? searchKey, int? index}) async {
    allCategoryProductList.clear();
    isLoading(true);
    var allProductResponse = await ProductRepository()
        .getCategoryProducts(id: categoryId, page: page, name: searchKey);
    allCategoryProductList.addAll(allProductResponse.products!);
    allCategoryProductId.value = categoryId!;
    totalData.value = allProductResponse.meta!.total!;
    isLoading(false);
    isInitial.value = false;
    update();
  }

  getMainCategories(int? id) async {
    var categoriesAll = await CategoryRepository().getCategories(parent_id: id);
    mainCategoryList.addAll(categoriesAll.categories! ?? []);
    update();
  }

  // assignSelectedIndexes(index,id) {
  //   print("before==========>${subCategoryList[index].id} ${id}");
  //   // subCategoryList[index].id = id;
  //   id = subCategoryList[index].id;
  //   print("after==========>${subCategoryList[index].id} ${id}");
  // }

  // assignCategoryIds(index) {
  //   allCategoryProductId.value = subCategoryList[index].id!;
  //   categoryProductId.value = subCategoryList[index].id;
  // }

  pageScrollingFetchingDatas({page, searchKey}) {
    if (showAllProducts.value == true) {
      getAllCategoryProducts(
          categoryId: allCategoryProductId.value,
          page: page,
          searchKey: searchKey);
    } else {
      getCategoryProducts(
          categoryId: categoryProductId.value,
          page: page,
          searchKey: searchKey);
    }
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
    totalData.value = 0;
    subCategoryIndex.value = 0;
    showLoadingContainer = false;
    isInitial.value = true;
    showAllProducts.value = false;
    mainNameChanged.value = false;
    selectedIndex.value = 0;
    allCategoryProductId.value = 0;
    categoryProductId.value = 0;
    update();
  }
}
