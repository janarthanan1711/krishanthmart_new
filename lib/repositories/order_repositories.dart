import '../helpers/api_helpers.dart';
import '../helpers/main_helpers.dart';
import '../helpers/middleware/banned_user.dart';
import '../models/common_response.dart';
import '../models/order_detail_model.dart';
import '../models/order_item_response.dart';
import '../models/order_mini_models.dart';
import '../models/purchase_digital_product_response.dart';
import '../models/reorder_response_model.dart';
import '../utils/app_config.dart';
import '../utils/shared_value.dart';

class OrderRepository {
  Future<dynamic> getOrderList(
      {page = 1, payment_status = "", delivery_status = ""}) async {
    String url = ("${AppConfig.BASE_URL}/purchase-history" +
        "?page=${page}&payment_status=${payment_status}&delivery_status=${delivery_status}");

    Map<String,String> header = commonHeader;

    header.addAll(authHeader);
    header.addAll(currencyHeader);

    final response = await ApiRequest.get(
        url: url,
        headers: header,
        middleware: BannedUser());

    return orderMiniResponseFromJson(response.body);
  }

  Future<dynamic> getOrderDetails({int? id = 0}) async {
    String url =
    ("${AppConfig.BASE_URL}/purchase-history-details/$id");

    Map<String,String> header = commonHeader;

    header.addAll(authHeader);
    header.addAll(currencyHeader);

    final response = await ApiRequest.get(
        url: url,
        headers:header,
        middleware: BannedUser());
    return orderDetailResponseFromJson(response.body);
  }

  Future<ReOrderResponse> reOrder({int? id = 0}) async {
    String url = ("${AppConfig.BASE_URL}/re-order/$id");
    final response = await ApiRequest.get(
        url: url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser());
    print("reorder response==============>${response.body}");
    return reOrderResponseFromJson(response.body);
  }

  Future<CommonResponse> cancelOrder({int? id,String? reason}) async {
    String url = "${AppConfig.BASE_URL}/order/cancel/$id/$reason";

    final response = await ApiRequest.get(
        url: url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser());
    print("cancel order response==============>${response.body}");
    return commonResponseFromJson(response.body);
  }

  Future<dynamic> getOrderItems({int? id = 0}) async {
    String url =
    ("${AppConfig.BASE_URL}/purchase-history-items/" + id.toString());
    Map<String,String> header = commonHeader;

    header.addAll(authHeader);
    header.addAll(currencyHeader);

    final response = await ApiRequest.get(
        url: url,
        headers: header,
        middleware: BannedUser());

    return orderItemlResponseFromJson(response.body);
  }

  Future<dynamic> getPurchasedDigitalProducts({
    page = 1,
  }) async {
    String url = ("${AppConfig.BASE_URL}/digital/purchased-list?page=$page");
    Map<String,String> header = commonHeader;

    header.addAll(authHeader);
    header.addAll(currencyHeader);

    final response = await ApiRequest.get(
        url: url,
        headers: header,
        middleware: BannedUser());

    return purchasedDigitalProductResponseFromJson(response.body);
  }
}
