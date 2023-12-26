import 'dart:convert';

import '../helpers/api_helpers.dart';
import '../models/product_details_model.dart';
import '../models/product_response_model.dart';
import '../models/variant_model.dart';
import '../models/variant_price_model.dart';
import '../utils/app_config.dart';
import '../utils/shared_value.dart';
import '../utils/system_config.dart';

class ProductRepository{
  Future<ProductMiniResponse> getBestSellingProducts() async {
    String url = ("${AppConfig.BASE_URL}/products/best-seller");
      final response = await ApiRequest.get(url: url, headers: {
        "App-Language": app_language.$!,
        // "Currency-Code": SystemConfig.systemCurrency!.code!,
        // "Currency-Exchange-Rate":
        // SystemConfig.systemCurrency!.exchangeRate.toString(),
      });
      // print("Best Selling Product=========> ${response.body}");
      return productMiniResponseFromJson(response.body);

  }
  Future<ProductMiniResponse> getTodaysDealProducts() async {
    String url = ("${AppConfig.BASE_URL}/products/todays-deal");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    // print("Todays Deal=============>${response.body}");
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFeaturedProducts() async {
    String url = ("${AppConfig.BASE_URL}/products/featured");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    print("Featured Products ========> ${response.body}");
    return productMiniResponseFromJson(response.body);
  }

  Future<VariantResponse> getVariantWiseInfo(
      {int? id = 0, color = '', variants = '', qty = 1}) async {
    String url = ("${AppConfig.BASE_URL}/products/variant/price");

    var postBody = jsonEncode({
      'id': id.toString(),
      "color": color,
      "variants": variants,
      "quantity": qty
    });

    final response = await ApiRequest.post(
        url: url,
        headers: {
          "App-Language": app_language.$!,
          "Content-Type": "application/json",
        },
        body: postBody);
    // print("Variant Response1 ${response.body}");
    // Find the index of the first '{' character in the response
    int startIndex = response.body.indexOf('{');
// Extract the substring from the first '{' to the end
    String jsonSubstring = response.body.substring(startIndex);
    print("Variant Response ${jsonSubstring}");
    return variantResponseFromJson(jsonSubstring);
  }

  Future<VariantPriceResponse> getVariantPrice({id, quantity}) async {
    String url = ("${AppConfig.BASE_URL}/varient-price");
    var post_body = jsonEncode({"id": id, "quantity": quantity});
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "App-Language": app_language.$!,
          "Content-Type": "application/json",
        },
        body: post_body);
    
    print("Variant Price Update ${response.body}");

    return variantPriceResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getCategoryProducts(
      {int? id = 0, name = "", page = 1}) async {
    String url = ("${AppConfig.BASE_URL}/products/category/$id?page=$page&name=$name");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    print("Category Products Api======>${response.body}");
    return productMiniResponseFromJson(response.body);
  }
  Future<ProductDetailsResponse> getProductDetails({int? id = 0}) async {
    String url = ("${AppConfig.BASE_URL}/products/$id");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    print("Get Product Response========>${response.body}");

    return productDetailsResponseFromJson(response.body);
  }
  Future<ProductMiniResponse> getRelatedProducts({int? id = 0}) async {
    String url = ("${AppConfig.BASE_URL}/products/related/$id");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTopFromThisSellerProducts(
      {int? id = 0}) async {
    String url =
    ("${AppConfig.BASE_URL}/products/top-from-seller/$id");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFlashDealProducts({int? id = 0}) async {
    String url = ("${AppConfig.BASE_URL}/flash-deal-products/$id");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBrandProducts(
      {int? id = 0, name = "", page = 1}) async {
    String url = ("${AppConfig.BASE_URL}/products/brand/$id?page=${page}&name=${name}");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,

    });
    return productMiniResponseFromJson(response.body);
  }

}