import '../helpers/api_helpers.dart';
import '../helpers/response_check.dart';
import '../models/check_response_model.dart';
import '../models/delivery_info_response.dart';
import '../utils/app_config.dart';
import '../utils/shared_value.dart';

class ShippingRepository{
  Future<dynamic> getDeliveryInfo() async {
    String url =
    ("${AppConfig.BASE_URL}/delivery-info");
    print(url.toString());
    final response = await ApiRequest.get(
      url:url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },
    );

    bool checkResult = ResponseCheck.apply(response.body);
    print("check deliveryResponseeeeeee========>${response.body}");
    if(!checkResult) {
      return responseCheckModelFromJson(response.body);
    }


    return deliveryInfoResponseFromJson(response.body);
  }

}