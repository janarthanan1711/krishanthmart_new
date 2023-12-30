import 'package:get/get.dart';

import '../models/currency_model.dart';
import '../repositories/currency_repository.dart';
import '../utils/shared_value.dart';
import '../utils/system_config.dart';

class CurrencyController extends GetxController{
  List<CurrencyInfo> currencyList = [];

  fetchListData() async {
    currencyList.clear();
    var res = await CurrencyRepository().getListResponse();
    print("res.data ${system_currency.$}");
    print(res.data.toString());
    currencyList.addAll(res.data!);

    for (var element in currencyList) {
      if (element.isDefault!) {
        SystemConfig.defaultCurrency = element;
      }
      if (system_currency.$ == 0 && element.isDefault!) {
        SystemConfig.systemCurrency = element;
        system_currency.$ = element.id;
        system_currency.save();
      }
      if (system_currency.$ != null && element.id == system_currency.$) {
        SystemConfig.systemCurrency = element;
        system_currency.$ = element.id;
        system_currency.save();
      }
    }
    update();
  }
}