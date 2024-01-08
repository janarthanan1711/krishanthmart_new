import '../helpers/api_helpers.dart';
import '../helpers/main_helpers.dart';
import '../helpers/middleware/banned_user.dart';
import '../models/wishlist_check_response_model.dart';
import '../models/wishlist_delete_response_model.dart';
import '../models/wishlist_response_model.dart';
import '../utils/app_config.dart';
import '../utils/shared_value.dart';

class WishListRepository {
  Future<dynamic> getUserWishlist() async {
    String url = ("${AppConfig.BASE_URL}/wishlists");
    Map<String, String> header = commonHeader;

    header.addAll(authHeader);
    header.addAll(currencyHeader);

    final response = await ApiRequest.get(
        url: url, headers: header, middleware: BannedUser());

    print("GET WISHLIST=======>${response.body}");

    return wishlistResponseFromJson(response.body);
  }

  Future<dynamic> delete({
    int? wishlist_id = 0,
  }) async {
    String url = ("${AppConfig.BASE_URL}/wishlists/${wishlist_id}");
    final response = await ApiRequest.delete(
        url: url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser());
    print("wishlist response========>${response.body}");
    return wishlistDeleteResponseFromJson(response.body);
  }

  Future<dynamic> isProductInUserWishList({product_id = 0}) async {
    String url =
    ("${AppConfig.BASE_URL}/wishlists-check-product?product_id=${product_id}");
    final response = await ApiRequest.get(
        url: url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser());
    print(response.body);

    return wishListChekResponseFromJson(response.body);
  }

  Future<dynamic> add({product_id = 0}) async {
    String url =
    ("${AppConfig.BASE_URL}/wishlists-add-product?product_id=${product_id}");

    print(url.toString());
    final response = await ApiRequest.get(
        url: url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser());
    print("product wishlist response=====================================>${response.body}");

    return wishListChekResponseFromJson(response.body);
  }

  Future<dynamic> remove({product_id = 0}) async {
    String url =
    ("${AppConfig.BASE_URL}/wishlists-remove-product?product_id=${product_id}");
    final response = await ApiRequest.get(
        url: url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser());
    print("product wishlist response=====================================>${response.body}");

    return wishListChekResponseFromJson(response.body);
  }
}
