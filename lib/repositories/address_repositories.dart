import '../helpers/api_helpers.dart';
import '../helpers/middleware/banned_user.dart';
import '../models/country_response.dart';
import '../utils/app_config.dart';

class AddressRepository {

  Future<dynamic> getCountryList({name = ""}) async {
    String url=("${AppConfig.BASE_URL}/countries?name=${name}");
    final response = await ApiRequest.get(url: url,middleware: BannedUser());
    return countryResponseFromJson(response.body);
  }
}