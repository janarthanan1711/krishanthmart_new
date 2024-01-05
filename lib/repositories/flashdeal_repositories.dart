import '../helpers/api_helpers.dart';
import '../models/flash_deal_model.dart';
import '../utils/app_config.dart';
import '../utils/shared_value.dart';

class FlashDealRepository {
  Future<FlashDealResponse> getFlashDeals() async {
    String url = ("${AppConfig.BASE_URL}/flash-deals");
    final response = await ApiRequest.get(
      url: url,
      headers: {
        "App-Language": app_language.$!,
      },
    );
    return flashDealResponseFromJson(response.body.toString());
  }
}