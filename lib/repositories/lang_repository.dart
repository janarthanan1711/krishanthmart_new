import '../helpers/api_helpers.dart';
import '../models/language_model_response.dart';
import '../utils/app_config.dart';
import '../utils/shared_value.dart';

class LanguageRepository {
  Future<LanguageListResponse> getLanguageList() async {
    String url=(
        "${AppConfig.BASE_URL}/languages");
    final response = await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    }
    );
    //print(response.body.toString());
    return languageListResponseFromJson(response.body);
  }
}