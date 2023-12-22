import 'package:get/get.dart';
import 'package:krishanthmart_new/views/account/accounts_page.dart';
import 'package:krishanthmart_new/views/address/address_page.dart';
import 'package:krishanthmart_new/views/brand_products/brand_products.dart';
import 'package:krishanthmart_new/views/brands/all_brands.dart';
import 'package:krishanthmart_new/views/category/category_page.dart';
import 'package:krishanthmart_new/views/category/sub_category_page.dart';
import 'package:krishanthmart_new/views/coupons/coupon.dart';
import 'package:krishanthmart_new/views/flashdeals/flashdealproducts.dart';
import 'package:krishanthmart_new/views/flashdeals/flashdealslist.dart';
import 'package:krishanthmart_new/views/mainpage/main_page.dart';
import 'package:krishanthmart_new/views/product_details/product_details.dart';
import 'package:krishanthmart_new/views/top_selling/top_sellers.dart';
import 'package:krishanthmart_new/views/wallet/wallets.dart';
import '../views/orders/my_orders_page.dart';
import '../views/top_selling/top_selling_products.dart';
import '../views/wishlist/wishlist.dart';

class Routes {
  static String mainPage = '/';
  static String category = '/category';
  static String flashDeal = '/flashDeal';
  static String subCategory = '/subcategory';
  static String wishlist = '/wishlist';
  static String orders = '/orders';
  static String address = '/address';
  static String accountsPage = '/accountsPage';
  static String productDetails = '/productDetails';
  static String flashDealProducts = '/flashDealProducts';
  static String wallets = '/wallets';
  static String coupons = '/coupons';
  static String brandProducts = '/brandProducts';
  static String allBrands = '/allBrands';
  static String topSellingProducts = '/topSelling';
  static String topSellers = '/topSellers';
}

List<GetPage<dynamic>>? getPages = [
  GetPage(
    name: Routes.mainPage,
    page: () => const MainPage(),
  ),
  GetPage(
    name: Routes.category,
    page: () => CategoryListPages(),
  ),
  GetPage(
    name: Routes.flashDeal,
    page: () => const FlashDealList(),
  ),
  GetPage(
    name: Routes.subCategory,
    page: () =>  SubCategoryPage(),
  ),
  GetPage(
    name: Routes.wishlist,
    page: () => const WishlistPage(),
  ),
  GetPage(
    name: Routes.orders,
    page: () => OrderList(),
  ),
  GetPage(
    name: Routes.address,
    page: () => const AddressPage(),
  ),
  GetPage(
    name: Routes.accountsPage,
    page: () => const AccountsPage(),
  ),
  GetPage(
    name: Routes.productDetails,
    page: () => ProductDetails(),
  ),
  GetPage(
    name: Routes.flashDealProducts,
    page: () => FlashDealProducts(),
  ),
  GetPage(
    name: Routes.wallets,
    page: () => Wallet(),
  ),
  GetPage(
    name: Routes.coupons,
    page: () => const Coupons(),
  ),
  GetPage(
    name: Routes.brandProducts,
    page: () => BrandProducts(id: 0,brand_name: ""),
  ),
  GetPage(
    name: Routes.allBrands,
    page: () => const AllBrands(),
  ),
  GetPage(
    name: Routes.topSellingProducts,
    page: () => const TopSellingProducts(),
  ),
  GetPage(
    name: Routes.topSellers,
    page: () => const TopSellers(),
  )
];
