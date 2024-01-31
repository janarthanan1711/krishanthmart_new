import 'dart:convert';

import 'package:krishanthmart_new/helpers/api_helpers.dart';
import 'package:krishanthmart_new/models/business_repo_model.dart';
import 'package:krishanthmart_new/utils/app_config.dart';

import '../models/business_data_response.dart';
import '../utils/shared_value.dart';


class BusinessSettingRepository {
  Future<List<BusinessSettingListResponse>> getBusinessSettingList() async {
    String url = ("${AppConfig.BASE_URL}/business-settings");

    var businessSettings = [
      "facebook_login",
      "google_login",
      "twitter_login",
      "pickup_point",
      "wallet_system",
      "email_verification",
      "conversation_system",
      "shipping_type",
      "classified_product",
      "google_recaptcha",
      "vendor_system_activation"
    ];
    String params = businessSettings.join(',');
    var body = {
      "keys": params
    };
    var response = await ApiRequest.post(url: url, body: jsonEncode(body));

    print("business ${response.body}");

    return businessSettingListResponseFromJson(response.body);
  }

  getBusinessResponse() async {
      String url = ("${AppConfig.BASE_URL}/business-settings");
      final response = await ApiRequest.get(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
      );
      Map<String, dynamic> responseData = jsonDecode(response.body.toString());

      BusinessLogicResponseDatas businessResponseData =
      BusinessLogicResponseDatas.fromJson(responseData);

      List<Datum> datumList = businessResponseData.data;

      return datumList;
    }
  }
