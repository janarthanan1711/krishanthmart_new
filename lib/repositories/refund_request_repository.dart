import 'dart:convert';

import '../helpers/api_helpers.dart';
import '../helpers/main_helpers.dart';
import '../helpers/response_check.dart';
import '../models/check_response_model.dart';
import '../models/refund_request_model.dart';
import '../models/refund_send_model.dart';
import '../utils/app_config.dart';
import '../utils/shared_value.dart';

class RefundRequestRepository {
  Future<dynamic> getRefundRequestListResponse({page = 1}) async {
    Map<String, String> header = commonHeader;

    header.addAll(authHeader);
    header.addAll(currencyHeader);

    String url = ("${AppConfig.BASE_URL}/refund-request/get-list?page=$page");
    final response = await ApiRequest.get(
      url: url,
      headers: header,
    );
    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return refundRequestResponseFromJson(response.body);
  }

  Future<dynamic> getRefundRequestSendResponse(
      {required int? id, required String reason}) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "reason": "${reason}",
    });

    String url = ("${AppConfig.BASE_URL}/refund-request/send");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        body: post_body);
    bool checkResult = ResponseCheck.apply(response.body);

    if (!checkResult) return responseCheckModelFromJson(response.body);

    return refundRequestSendResponseFromJson(response.body);
  }
}