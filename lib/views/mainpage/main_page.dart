import 'dart:io';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/controllers/cart_controller.dart';
import 'package:krishanthmart_new/controllers/home_controller.dart';
import 'package:one_context/one_context.dart';
import '../../utils/colors.dart';
import '../../utils/image_directory.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../utils/shared_value.dart';
import '../cart/cart_page.dart';
import '../category/category_page.dart';
import '../flashdeals/flashdealslist.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';

class MainPage extends StatefulWidget {
   MainPage({Key? key,go_back = true}) : super(key: key);

  late bool go_back;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final HomeController homeController = Get.put(HomeController());
  final CartController cartController = Get.put(CartController());
  int _currentIndex = 0;
  var bottomPages = [
    HomePage(),
    CategoryListPages(is_viewMore: true),
    CartPage(has_bottomnav: true,from_navigation: false),
    const FlashDealList(
      hasBottomNav: true,
    ),
    ProfilePage()
  ];

  void onTapped(int i) {
    setState(() {
      _currentIndex = i;
    });
  }
  fetchAll(){
    getCartCount();
  }

  getCartCount() async {
    await cartController.getCount();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
          if (_currentIndex != 0) {
            fetchAll();
            setState(() {
              _currentIndex = 0;
            });
          } else {
            // CommonFunctions(context).appExitDialog();
            final shouldPop = (await OneContext().showDialog<bool>(
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Directionality(
                  textDirection:
                  app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
                  child: AlertDialog(
                    contentPadding: const EdgeInsets.only(left: 15,right: 15,top: 15),
                    content: SizedBox(
                      height: 61.h,
                      width: 250.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Image(
                              image: AssetImage(ImageDirectory.appLogo),height: 50,width: 50,),
                          Row(
                            children: [
                              Text(
                                  AppLocalizations.of(context)!.do_you_want_close_the_app),
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Platform.isAndroid ? SystemNavigator.pop() : exit(0);
                          },
                          child: Text(AppLocalizations.of(context)!.yes_ucf)),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(AppLocalizations.of(context)!.no_ucf)),
                    ],
                  ),
                );
              },
            ))!;
            return shouldPop;
          }
          return widget.go_back;
      },
      child: Directionality(
        textDirection: app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          body: bottomPages[_currentIndex],
          bottomNavigationBar: SizedBox(
            height: 70,
            child: BottomNavigationBar(
              onTap: onTapped,
              currentIndex: _currentIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white.withOpacity(0.95),
              unselectedItemColor: MyTheme.black,
              selectedItemColor: MyTheme.accent_color2,
              selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: MyTheme.accent_color2,
                  fontSize: 12),
              unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: MyTheme.black,
                  fontSize: 12),
              items: [
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Image.asset(
                        ImageDirectory.homeIconImage,
                        color: _currentIndex == 0
                            ? MyTheme.accent_color2
                            : MyTheme.black,
                        height: 16,
                      ),
                    ),
                    label: AppLocalizations.of(context)!.home_ucf),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.asset(
                      ImageDirectory.categoriesIconImage,
                      color: _currentIndex == 1
                          ? MyTheme.accent_color2
                          : MyTheme.black,
                      height: 16,
                    ),
                  ),
                  label: AppLocalizations.of(context)!.categories_ucf,
                ),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: badges.Badge(
                        badgeStyle: badges.BadgeStyle(
                          shape: badges.BadgeShape.circle,
                          badgeColor: MyTheme.accent_color,
                          borderRadius: BorderRadius.circular(10),
                          padding: const EdgeInsets.all(5),
                        ),
                        badgeAnimation: const badges.BadgeAnimation.slide(
                          toAnimate: false,
                        ),
                        child: Image.asset(
                          ImageDirectory.cartIconImage,
                          color: _currentIndex == 2
                              ? MyTheme.accent_color2
                              : MyTheme.black,
                          height: 16,
                        ),

                        badgeContent:
                           GetBuilder<CartController>(builder: (cartController){
                             return Text(
                             "${cartController.cartCounter}",
                             style:
                             TextStyle(fontSize: 10, color: Colors.white),
                             );
                           },)

                      ),
                    ),
                    label: AppLocalizations.of(context)!.cart_ucf),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Image.asset(
                        ImageDirectory.flashDeal,
                        color: _currentIndex == 3
                            ? MyTheme.accent_color2
                            : MyTheme.black,
                        height: 16,
                      ),
                    ),
                    label: AppLocalizations.of(context)!.flash_deal_ucf),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.asset(
                      ImageDirectory.profileIconImage,
                      color: _currentIndex == 4
                          ? MyTheme.accent_color2
                          : MyTheme.black,
                      height: 16,
                    ),
                  ),
                  label: AppLocalizations.of(context)!.profile_ucf,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
