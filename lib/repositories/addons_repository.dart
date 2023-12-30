import '../helpers/api_helpers.dart';
import '../models/addons_response.dart';
import '../models/offline_wallet_recharge_response.dart';
import '../utils/app_config.dart';

class AddonsRepository{
  Future<List<AddonsListResponse>> getAddonsListResponse() async{$();
  String url=('${AppConfig.BASE_URL}/addon-list');
  final response = await ApiRequest.get(url: url);
  return addonsListResponseFromJson(response.body);
  }
}