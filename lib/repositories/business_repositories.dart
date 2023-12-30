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
      //'keys':params
      "keys": params
    };
    //print("business ${body}");
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

      // Accessing individual values
      print("Success: ${businessResponseData.success}");
      print("Status: ${businessResponseData.status}");

      for (Datum datum in datumList) {
        print("Type: ${datum.type}, Value: ${datum.value}");
        // Example: Accessing verification form
        // if (datum.type == 'verification_form') {
        //   VerificationForm verificationForm =
        //   VerificationForm.fromJson(jsonDecode(datum.value));
        //   print('Verification Form Fields: ${verificationForm.fields}');
        // }
      }

      return datumList;
     //  final data=jsonDecode(response.body.toString())['data'];
     // final map = data.map((e)=>Datum.fromJson(e)).toList();
     //
     //  // BusinessLogicResponseDatas.fromJson(jsonDecode(response.body.toString()))
     //
     //  print("businesss Response Datas=====[=======[[[[-===>${response.body}");
     //  print("businesss Response Datas=====[=======[[[[-===>${data}");
     //  print("businesss Response mapss=====[=======[[[[-===>${map}");
     //
     //  return map;

      // return businessLogicResponseDatasFromJson(map);

    }
  }
