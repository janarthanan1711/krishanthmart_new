import 'dart:ffi';

import 'package:get/get.dart';
import 'package:krishanthmart_new/models/category_model.dart';
import 'package:krishanthmart_new/models/product_response_model.dart';
import '../repositories/category_repositories.dart';
import '../repositories/product_repository.dart';

class CategoryController extends GetxController{

  List<Category>? categoryList = [];
  var mainCategoryList = [];
  var childSubId = 0.obs;
  var isLoading = true.obs;
  // var selectedMainCategoryTitle = "".obs;
  // var mainNameChanged = false.obs;
  var subChildCategories = [].obs;
  var subCategoryList = [].obs;
  var subCategoryChild = [].obs;
  var mainCategoryNames = "".obs;
  var mainCategoryId = 0.obs;

  @override
  void onInit() {
    // getTopCategories();
    super.onInit();
  }
  @override
  void onClose(){
    clearAll();
    super.onClose();
  }

  getSubCategory(int? categoryId) async {
    var res =
    await CategoryRepository().getCategories(parent_id: categoryId);
    subCategoryList.addAll(res.categories!);
    update();
  }


  getChildSubCategories(int subChildCategory) async {
    subChildCategories.clear();
    var subChildCategoriesRes = await CategoryRepository().getSubChildCategories(categoryId: subChildCategory);
    subChildCategories.addAll(subChildCategoriesRes.subChildCategory);
    update();
  }

  assignCategoryNames(int index){
    mainCategoryNames.value = categoryList![index].name!;
    mainCategoryId.value = categoryList![index].id!;
    // print("mainCategoryID=========>${mainCategoryId.value}");
  }
  getCategories(int? id) async {
    var categoriesAll = await CategoryRepository().getCategories(parent_id: id);
    categoryList!.addAll(categoriesAll.categories! ?? []);
    update();
  }

  // getMainCategories() async {
  //   try{
  //     isLoading(true);
  //     var mainCategories = await CategoryRepository().getCategories();
  //     mainCategoryList.addAll(mainCategories.categories! ?? []);
  //   }finally{
  //     isLoading(false);
  //   }
  // }

  getTopCategories()async {
    var categories = await CategoryRepository().getTopCategories();
    // categoryList.add(categories.categories as Category);
    update();
  }

  clearAll(){
    // mainNameChanged.value = false;
    subCategoryList.clear();
    mainCategoryList.clear();
    categoryList!.clear();
    subChildCategories.clear();
    update();
  }
}

