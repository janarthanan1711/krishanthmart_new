import 'package:get/get.dart';

import '../repositories/cart_repositories.dart';

class CartController extends GetxController{
  var cartCounter=0.obs;

  getCount()async{
    var res = await CartRepository().getCartCount();
    cartCounter.value = res.count;
    print("Get Cart Count============> ${cartCounter.value}");
    update();
  }
}