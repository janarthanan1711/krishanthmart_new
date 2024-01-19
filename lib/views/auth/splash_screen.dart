import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/controllers/cart_controller.dart';
import 'package:krishanthmart_new/controllers/currency_controller.dart';
import 'package:krishanthmart_new/controllers/language_controller.dart';
import 'package:krishanthmart_new/views/mainpage/main_page.dart';
import 'package:package_info/package_info.dart';
import '../../helpers/auth_helpers.dart';
import '../../helpers/business_settings_helpers.dart';
import '../../utils/app_config.dart';
import '../../utils/colors.dart';
import '../../utils/device_info.dart';
import '../../utils/image_directory.dart';
import '../../utils/shared_value.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  LanguageController languageController = Get.put(LanguageController());
  CurrencyController currencyController = Get.put(CurrencyController());
  CartController cartController = Get.put(CartController());
  PackageInfo _packageInfo = PackageInfo(
    appName: AppConfig.app_name,
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPackageInfo();
    getSharedValueHelperData().then((value){
      Future.delayed(const Duration(seconds: 3)).then((value) {
        languageController.setLocale(app_mobile_language.$!);
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
            return MainPage(go_back: false,);
          },
          ),(route)=>false,);
      }
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return splashScreen();
  }

  Widget splashScreen() {
    return Container(
      width: DeviceInfo(context).height,
      height: DeviceInfo(context).height,
      color:  MyTheme.white,
      child: InkWell(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Hero(
                      tag: "splashscreenImage",
                      child: Container(
                        height: 250,
                        width: 225,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: MyTheme.white,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Image.asset(
                          ImageDirectory.appLogo,
                          filterQuality: FilterQuality.low,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      AppConfig.app_name,
                      style:  TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          color: MyTheme.black),
                    ),
                  ),
                  Text(
                    "V ${_packageInfo.version}",
                    style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      color: MyTheme.black,
                    ),
                  ),
                ],
              ),
            ),

            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 51.0),
                  child: Text(
                    AppConfig.copyright_text,
                    style:  TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      color: MyTheme.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?>  getSharedValueHelperData()async{
    access_token.load().whenComplete(() {
      AuthHelper().fetch_and_set();
    });
    // AddonsHelper().setAddonsData();
    BusinessSettingHelper().setBusinessSettingData();
    await app_language.load();
    await app_mobile_language.load();
    await app_language_rtl.load();
    await system_currency.load();
    currencyController.fetchListData();
    cartController.getCount();
    return app_mobile_language.$;

  }
}