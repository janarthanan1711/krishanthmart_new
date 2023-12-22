import '../helpers/api_helpers.dart';
import '../models/brand_model.dart';
import '../utils/app_config.dart';
import '../utils/shared_value.dart';

class BrandRepository {

  Future<BrandResponse> getFilterPageBrands() async {
    String url=("${AppConfig.BASE_URL}/filter/brands");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return brandResponseFromJson(response.body);
  }

  Future<BrandResponse> getBrands({name = "", page = 1}) async {
    String url=("${AppConfig.BASE_URL}/brands"+
        "?page=${page}&name=${name}");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return brandResponseFromJson(response.body);
  }

  Future<BrandResponse> getTopBrands() async {
    String url=("${AppConfig.BASE_URL}/brands/top");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return brandResponseFromJson(response.body);
  }

}