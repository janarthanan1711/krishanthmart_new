import 'dart:convert';
import 'package:krishanthmart_new/helpers/auth_helpers.dart';
import 'package:http/http.dart' as http;
import 'middleware.dart';

class BannedUser extends Middleware {
  @override
  bool next(http.Response response) {
    var jsonData = jsonDecode(response.body);
    if (jsonData.runtimeType!=List && jsonData.containsKey("result") && !jsonData['result']) {
      if (jsonData.containsKey("status") &&
          jsonData['status'] == "banned") {
        AuthHelper().clearUserData();
        // Navigator.pushAndRemoveUntil(OneContext().context!,
        //     MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
        return false;
      }
    }
    return true;
  }
}