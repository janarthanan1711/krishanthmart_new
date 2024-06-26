import 'package:krishanthmart_new/models/login_model.dart';
import 'package:krishanthmart_new/repositories/auth_repositories.dart';
import 'package:krishanthmart_new/utils/shared_value.dart';
import 'package:krishanthmart_new/utils/system_config.dart';


class AuthHelper {
  setUserData(LoginResponse loginResponse) {
    if (loginResponse.result == true) {
      print("login Response Data"
          " ${loginResponse.result}"
          " ${loginResponse.user}"
          " ${loginResponse.access_token}"
          " ${loginResponse.user?.id} "
          "${loginResponse.user?.name}"
          " ${loginResponse.user?.email}"
          " ${loginResponse.user?.phone}"
          " ${loginResponse.user?.avatar_original}"
          " ${loginResponse.user?.type}"
      );
      SystemConfig.systemUser= loginResponse.user;
      is_logged_in.$ = true;
      is_logged_in.save();
      access_token.$ = loginResponse.access_token;
      access_token.save();
      print("login Response access Token=======>${access_token.$}");
      user_id.$ = loginResponse.user?.id;
      user_id.save();
      user_name.$ = loginResponse.user?.name;
      user_name.save();
      user_email.$ = loginResponse.user?.email??"";
      user_email.save();
      user_phone.$ = loginResponse.user?.phone??"";
      user_phone.save();
      avatar_original.$ = loginResponse.user?.avatar_original;
      avatar_original.save();
    }
  }

  clearUserData() {
    SystemConfig.systemUser= null;
    is_logged_in.$ = false;
    is_logged_in.save();
    access_token.$ = "";
    access_token.save();
    user_id.$ = 0;
    user_id.save();
    user_name.$ = "";
    user_name.save();
    user_email.$ = "";
    user_email.save();
    user_phone.$ = "";
    user_phone.save();
    avatar_original.$ = "";
    avatar_original.save();
  }


  fetch_and_set() async {
    // print("fetch and Set access token=======>${access_token.$}");
    LoginResponse userByTokenResponse = await AuthRepository().getUserByTokenResponse(access_token.$);
    if (userByTokenResponse.result == true) {
      setUserData(userByTokenResponse);
    }else{
      clearUserData();
    }
  }
}
