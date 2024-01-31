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
  var subChildCategories = [].obs;
  var subCategoryList = [].obs;
  var mainCategoryNames = "".obs;
  var mainCategoryId = 0.obs;

  @override
  void onClose(){
    clearAll();
    super.onClose();
  }



  getChildSubCategories(int subChildCategory) async {
    subChildCategories.clear();
    var subChildCategoriesRes = await CategoryRepository().getSubChildCategories(categoryId: subChildCategory);
    subChildCategories.addAll(subChildCategoriesRes.subChildCategory);
    update();
  }

  assignCategoryNames(int index){
    print(mainCategoryNames.value);
    mainCategoryNames.value = categoryList![index].name!;
    mainCategoryId.value = categoryList![index].id!;
    update();
    // print("mainCategoryID=========>${mainCategoryId.value}");
  }
  getCategories(int? id) async {
    categoryList!.clear();
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
    mainCategoryNames.value = "";
    mainCategoryId.value = 0;
    update();
  }
}

