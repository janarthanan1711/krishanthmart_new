
import '../helpers/api_helpers.dart';
import '../models/pincode_response_model.dart';
import '../utils/app_config.dart';
import '../utils/shared_value.dart';

class LocationRepository{
  Future<Pincode> getPincodeData() async {
    String url = ("${AppConfig.BASE_URL}/pincodes");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    print("Pincode Response Datas for users ========> ${response.body}");
    return pincodeResponseFromJson(response.body);
  }
}