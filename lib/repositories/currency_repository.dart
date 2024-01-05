
import '../helpers/api_helpers.dart';
import '../models/currency_model.dart';
import '../utils/app_config.dart';

class CurrencyRepository{
  Future<CurrencyResponse> getListResponse() async{
    String url=('${AppConfig.BASE_URL}/currencies');
    final response = await ApiRequest.get(url: url);
    print("CurrencyList Response ==========>${response.body}");
    return currencyResponseFromJson(response.body);
  }
}