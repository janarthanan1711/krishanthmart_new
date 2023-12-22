import 'package:get/get.dart';

import '../models/variant_model.dart';
import '../repositories/product_repository.dart';

class VariantController extends GetxController {
  // Define an Rx variable to hold the selected variant
  Rx<VariantData?> selectedVariant = Rx<VariantData?>(null);

  Future<void> fetchVariantInfo(int productId) async {
    print("Hello");
    var variantResponse = await ProductRepository().getVariantWiseInfo(id: productId);

    selectedVariant.value = variantResponse.variantData;
  }
}