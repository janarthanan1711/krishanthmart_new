import 'dart:convert';
import '../helpers/api_helpers.dart';
import '../helpers/middleware/banned_user.dart';
import '../models/offline_wallet_recharge_response.dart';
import '../utils/app_config.dart';
import '../utils/shared_value.dart';

class OfflineWalletRechargeRepository {
  Future<dynamic> getOfflineWalletRechargeResponse(
      {required String amount,
        required String name,
        required String trx_id,
        required int? photo}) async {
    var post_body = jsonEncode({
      "amount": "$amount",
      "payment_option": "Offline Payment",
      "trx_id": "$trx_id",
      "photo": "$photo",
    });
    String url = ("${AppConfig.BASE_URL}/wallet/offline-recharge");
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

    return offlineWalletRechargeResponseFromJson(response.body);
  }
}