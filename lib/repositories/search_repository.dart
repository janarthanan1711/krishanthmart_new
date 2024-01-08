import '../helpers/api_helpers.dart';
import '../models/search_suggestion_model.dart';
import '../utils/app_config.dart';
import '../utils/shared_value.dart';

class SearchRepository {
  Future<List<SearchSuggestionResponse>> getSearchSuggestionListResponse(
      {query_key = "", type = "product"}) async {
    String url=(
        "${AppConfig.BASE_URL}/get-search-suggestions?query_key=$query_key&type=$type");
    final response = await ApiRequest.get(
      url:url,
      headers: {
        "App-Language": app_language.$!,
      },
    );


    return searchSuggestionResponseFromJson(response.body);
  }
}