import 'dart:convert';
import '../helpers/api_helpers.dart';
import '../helpers/middleware/banned_user.dart';
import '../helpers/response_check.dart';
import '../models/cart_add_response.dart';
import '../models/cart_count_response.dart';
import '../models/cart_delete_response.dart';
import '../models/cart_model.dart';
import '../models/cart_process_response.dart';
import '../models/cart_summary_response.dart';
import '../models/check_response_model.dart';
import '../utils/app_config.dart';
import '../utils/shared_value.dart';

class CartRepository {
  Future<CartResponse> getCartResponseList(
      int? user_id,
      ) async {
    String url = ("${AppConfig.BASE_URL}/carts");
    var post_body = jsonEncode({
      'user_id':user_id
    });
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        body: post_body,
        middleware: BannedUser());
    print("cartResponse body=========>${response.body}");
    return cartResponseFromJson(response.body);
    // return CartResponse.fromJson(jsonDecode(response.body));
  }

  Future<dynamic> getCartCount() async {
    if (is_logged_in.$) {
      String url = ("${AppConfig.BASE_URL}/cart-count");
      final response = await ApiRequest.get(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
      );
      bool checkResult = ResponseCheck.apply(response.body);

      if (!checkResult) return responseCheckModelFromJson(response.body);

      return cartCountResponseFromJson(response.body);
    } else {
      return CartCountResponse(count: 0, status: false);
    }
  }

  Future<dynamic> getCartDeleteResponse(
      int? cart_id,
      ) async {
    String url = ("${AppConfig.BASE_URL}/carts/$cart_id");
    final response = await ApiRequest.delete(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        middleware: BannedUser());
    return cartDeleteResponseFromJson(response.body);
  }

  Future<dynamic> getCartProcessResponse(
      String cart_ids, String cart_quantities) async {
    var post_body = jsonEncode(
        {"cart_ids": "${cart_ids}", "cart_quantities": "$cart_quantities"});

    String url = ("${AppConfig.BASE_URL}/carts/process");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body,
        middleware: BannedUser());
    print("Cart Response data from cart_items ==================>${response.body}");
    return cartProcessResponseFromJson(response.body);
  }

  Future<dynamic> getCartAddResponse(
      int? id, String? variant, int? user_id, int? quantity) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "variant": variant,
      "user_id": "$user_id",
      "quantity": "$quantity",
      "cost_matrix": AppConfig.purchase_code
    });

    String url = ("${AppConfig.BASE_URL}/carts/add");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body,
        middleware: BannedUser());
    print("cartAdd Response========>${response.body}");
    print("status code ${response.statusCode}");
    print("Access Tokennnnnnn =========>${access_token.$}");

    return cartAddResponseFromJson(response.body);
  }

  Future<dynamic> getCartSummaryResponse() async {
    String url = ("${AppConfig.BASE_URL}/cart-summary");
    final response = await ApiRequest.get(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,


        },
        middleware: BannedUser());

    return cartSummaryResponseFromJson(response.body);
  }
}
