import 'dart:convert';
import '../helpers/api_helpers.dart';
import '../helpers/middleware/banned_user.dart';
import '../models/offline_payment_submit_response.dart';
import '../utils/app_config.dart';
import '../utils/shared_value.dart';

class OfflinePaymentRepository {
  Future<dynamic> getOfflinePaymentSubmitResponse(
      {required int? order_id,
        required String amount,
        required String name,
        required String trx_id,
        required int? photo}) async {
    var post_body = jsonEncode({
      "order_id": "$order_id",
      "amount": "$amount",
      "name": "$name",
      "trx_id": "$trx_id",
      "photo": "$photo",
    });

    String url = ("${AppConfig.BASE_URL}/offline/payment/submit");

    print(post_body);
    print(url);

    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
          "Accept": "application/json",
          "System-Key": AppConfig.system_key
        },
        body: post_body,
        middleware: BannedUser());
    return offlinePaymentSubmitResponseFromJson(response.body);
  }
}
