import '../helpers/api_helpers.dart';
import '../models/common_response.dart';
import '../models/product_response_model.dart';
import '../models/shop_response_model.dart';
import '../utils/app_config.dart';
import '../utils/shared_value.dart';
import '../utils/system_config.dart';

class ShopRepository {
  Future<dynamic> getShops({name = "", page = 1}) async {
    String url =
    ("${AppConfig.BASE_URL}/shops" + "?page=${page}&name=${name}");

    print(url.toString());

    final response = await ApiRequest.get(url: url,
      headers: {
        "App-Language": app_language.$!,
      },);

    return shopResponseFromJson(response.body);
  }

  // Future<ShopDetailsResponse> getShopInfo({ id = 0}) async {
  //
  //   String url =  ("${AppConfig.BASE_URL}/shops/details/${id}");
  //   print(url.toString());
  //   final response =
  //   await ApiRequest.get(url: url,
  //     headers: {
  //       "App-Language": app_language.$!,
  //     },);
  //
  //
  //   return shopDetailsResponseFromJson(response.body);
  // }

  Future<ProductMiniResponse> getTopFromThisSellerProducts({int? id = 0}) async {

    String url =  ("${AppConfig.BASE_URL}/shops/products/top/" + id.toString());
    final response = await ApiRequest
        .get(url:url,
      headers: {
        "App-Language": app_language.$!,
        "Currency-Code":SystemConfig.systemCurrency!.code!,

      },);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getNewFromThisSellerProducts({int? id = 0}) async {

    String url =  ("${AppConfig.BASE_URL}/shops/products/new/" + id.toString());
    final response = await ApiRequest
        .get(url:url,
      headers: {
        "App-Language": app_language.$!,
        "Currency-Code":SystemConfig.systemCurrency!.code!,

      },);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getfeaturedFromThisSellerProducts(
      {int? id = 0}) async {

    String url =  ("${AppConfig.BASE_URL}/shops/products/featured/" + id.toString());
    final response = await ApiRequest
        .get(url:url,
      headers: {
        "App-Language": app_language.$!,
        "Currency-Code":SystemConfig.systemCurrency!.code!,

      },);
    return productMiniResponseFromJson(response.body);
  }

  Future<CommonResponse> followedCheck(id) async {

    String url =  ("${AppConfig.BASE_URL}/followed-seller/check/$id");
    final response = await ApiRequest
        .get(url:url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },);
    return commonResponseFromJson(response.body);
  }

  Future<CommonResponse> followedAdd(id) async {

    String url =  ("${AppConfig.BASE_URL}/followed-seller/store/$id");
    final response = await ApiRequest
        .get(url:url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },);
    return commonResponseFromJson(response.body);
  }

  Future<CommonResponse> followedRemove(id) async {

    String url =  ("${AppConfig.BASE_URL}/followed-seller/remove/$id");
    final response = await ApiRequest
        .get(url:url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },);
    return commonResponseFromJson(response.body);
  }

  // Future<FollowedSellersResponse> followedList({page=1}) async {
  //   String url =  ("${AppConfig.BASE_URL}/followed-seller?page=$page");
  //   final response = await ApiRequest
  //       .get(url:url,
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer ${access_token.$}",
  //       "App-Language": app_language.$!,
  //     },);
  //   print(response.body);
  //   return followedSellersResponseFromJson(response.body);
  // }

  Future<ShopResponse> topSellers()async{
    String url =("${AppConfig.BASE_URL}/seller/top");

    final response = await ApiRequest.get(url: url,
      headers: {
        "App-Language": app_language.$!,
      },);
    print(response.body);

    return shopResponseFromJson(response.body);
  }


}