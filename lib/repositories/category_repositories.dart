import '../helpers/api_helpers.dart';
import '../models/category_model.dart';
import '../models/sub_child_model.dart';
import '../utils/app_config.dart';
import '../utils/shared_value.dart';

class CategoryRepository {

  Future<CategoryResponse> getCategories({parent_id = 0}) async {
    String url=("${AppConfig.BASE_URL}/categories?parent_id=$parent_id");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print("Get Categories ${response.body.toString()}");
    return categoryResponseFromJson(response.body);
  }

  Future<SubChildResponse> getSubChildCategories({categoryId = 0}) async {
    String url = ("${AppConfig.BASE_URL}/sub-categories/$categoryId");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    // print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    // print("Get Sub Categories========>>>>>>>>> ${response.body.toString()}");
    return subChildResponseFromJson(response.body);

  }

  Future<CategoryResponse> getFeaturedCategories() async {
    String url=("${AppConfig.BASE_URL}/categories/featured");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    //print(response.body.toString());
    //print("--featured cat--");
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getTopCategories() async {
    String url=("${AppConfig.BASE_URL}/categories/top");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    // print("top Category=========>${response.body.toString()}");
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getFilterPageCategories() async {
    String url=("${AppConfig.BASE_URL}/filter/categories");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return categoryResponseFromJson(response.body);
  }


}