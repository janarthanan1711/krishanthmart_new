import '../helpers/api_helpers.dart';
import '../models/slider_model.dart';
import 'package:http/http.dart' as http;

import '../utils/app_config.dart';
import '../utils/shared_value.dart';

class SliderRepository {
  Future<SliderResponse> getSliders() async {
    String url = ("${AppConfig.BASE_URL}/sliders");
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "App-Language": app_language.$!,
      },
    );
    return sliderResponseFromJson(response.body);
  }
  Future<SliderResponse> getBannerOneImages() async {

    String url =  ("${AppConfig.BASE_URL}/banners-one");
    final response =
    await ApiRequest.get(url: url,
      headers: {
        "App-Language": app_language.$!,
      },);
    print(response.body.toString());
    print("sliders");
    return sliderResponseFromJson(response.body);
  }

  Future<SliderResponse> getBannerTwoImages() async {

    String url =  ("${AppConfig.BASE_URL}/banners-two");
    print(url.toString());
    final response =
    await ApiRequest.get(url: url,
      headers: {
        "App-Language": app_language.$!,
      },);
    return sliderResponseFromJson(response.body);
  }

  Future<SliderResponse> getBannerThreeImages() async {

    String url =  ("${AppConfig.BASE_URL}/banners-three");
    final response =
    await ApiRequest.get(url: url,
      headers: {
        "App-Language": app_language.$!,
      },);
    /*print(response.body.toString());
    print("sliders");*/
    return sliderResponseFromJson(response.body);
  }
}
