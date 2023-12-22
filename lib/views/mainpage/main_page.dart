import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:badges/badges.dart' as badges;
import '../../utils/colors.dart';
import '../../utils/image_directory.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../cart/cart_page.dart';
import '../flashdeals/flashdealslist.dart';
import '../home/home_page.dart';
import '../notification/notificationpage.dart';
import '../profile/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  var bottomPages =[
     HomePage(),
    const FlashDealList(),
    CartPage(has_bottomnav: true),
    // const NotificationPage(),
    ProfilePage()
  ];
  void onTapped(int i){
    setState(() {
      _currentIndex = i;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomPages[_currentIndex],
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          onTap: onTapped,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white.withOpacity(0.95),
          unselectedItemColor: const Color.fromRGBO(168, 175, 179, 1),
          selectedItemColor: MyTheme.accent_color2,
          selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              color: MyTheme.accent_color2,
              fontSize: 12),
          unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(168, 175, 179, 1),
              fontSize: 12),
          items: [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.asset(
                    ImageDirectory.homeIconImage,
                    color: _currentIndex == 0
                        ? MyTheme.accent_color2
                        : const Color.fromRGBO(153, 153, 153, 1),
                    height: 16,
                  ),
                ),
                label: AppLocalizations.of(context)!.home_ucf),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.asset(
                    ImageDirectory.flashDeal,
                    color: _currentIndex == 1
                        ? MyTheme.accent_color2
                        : const Color.fromRGBO(153, 153, 153, 1),
                    height: 16,
                  ),
                ),
                label: AppLocalizations.of(context)!.flash_deal_ucf),
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
                          : const Color.fromRGBO(153, 153, 153, 1),
                      height: 16,
                    ),

                    // badgeContent: Consumer<CartCounter>(
                    //   builder: (context, cart, child) {
                    //     return Text(
                    //       "${cart.cartCounter}",
                    //       style:
                    //       TextStyle(fontSize: 10, color: Colors.white),
                    //     );
                    //   },
                    // ),
                  ),
                ),
                label: AppLocalizations.of(context)!.cart_ucf),
            // BottomNavigationBarItem(
            //   icon: Padding(
            //     padding: const EdgeInsets.only(bottom: 8.0),
            //     child: Image.asset(
            //       ImageDirectory.notificationIconImage,
            //       color: _currentIndex == 3
            //           ? MyTheme.accent_color2
            //           : const Color.fromRGBO(153, 153, 153, 1),
            //       height: 16,
            //     ),
            //   ),
            //   label: AppLocalizations.of(context)!.notification_ucf,
            // ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Image.asset(
                  ImageDirectory.profileIconImage,
                  color: _currentIndex == 4
                      ? MyTheme.accent_color2
                      : const Color.fromRGBO(153, 153, 153, 1),
                  height: 16,
                ),
              ),
              label: AppLocalizations.of(context)!.profile_ucf,
            ),
          ],),
      ),
    );
  }
}
