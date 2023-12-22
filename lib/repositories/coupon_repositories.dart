import 'dart:convert';

import '../helpers/api_helpers.dart';
import '../helpers/main_helpers.dart';
import '../helpers/middleware/banned_user.dart';
import '../models/coupon_apply_response.dart';
import '../models/coupon_list_response.dart';
import '../models/coupon_remove_response.dart';
import '../models/product_response_model.dart';
import '../utils/app_config.dart';
import '../utils/shared_value.dart';

class CouponRepository {
  Future<dynamic> getCouponApplyResponse(String coupon_code) async {
    var post_body =
    jsonEncode({"user_id": "${user_id.$}", "coupon_code": "$coupon_code"});

    String url = ("${AppConfig.BASE_URL}/coupon-apply");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body,
        middleware: BannedUser());
    return couponApplyResponseFromJson(response.body);
  }

  Future<dynamic> getCouponRemoveResponse() async {
    var post_body = jsonEncode({"user_id": "${user_id.$}"});

    String url = ("${AppConfig.BASE_URL}/coupon-remove");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body,
        middleware: BannedUser());
    return couponRemoveResponseFromJson(response.body);
  }

  // get
  // all
  // coupons

  Future<CouponListResponse> getCouponResponseList({page = 1}) async {
    Map<String, String> header = commonHeader;
    header.addAll(currencyHeader);
    String url = ("${AppConfig.BASE_URL}/coupon-list?page=$page");
    final response = await ApiRequest.get(url: url, headers: header);
    print("response body");
    print("${response.body}");

    return couponListResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getCouponProductList({id}) async {
    Map<String, String> header = commonHeader;
    header.addAll(currencyHeader);

    String url = ("${AppConfig.BASE_URL}/coupon-products/$id");
    final response = await ApiRequest.get(url: url, headers: header);
    print("response body");
    print("${response.body}");

    return productMiniResponseFromJson(response.body);
  }
}