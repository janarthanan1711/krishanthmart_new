import 'package:krishanthmart_new/models/login_model.dart';
import 'package:krishanthmart_new/repositories/auth_repositories.dart';
import 'package:krishanthmart_new/utils/shared_value.dart';
import 'package:krishanthmart_new/utils/system_config.dart';

class AuthHelper{
  setUserData(LoginResponse loginResponse) {
    if (loginResponse.result == true) {
      SystemConfig.systemUser= loginResponse.user;
      is_logged_in.$ = true;
      is_logged_in.save();
      access_token.$ = loginResponse.access_token;
      access_token.save();
      user_id.$ = loginResponse.user?.id;
      user_id.save();
      user_name.$ = loginResponse.user?.name;
      user_name.save();
      user_email.$ = loginResponse.user?.email ?? "";
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
    print("Fetch and Set Caleed");
    var userByTokenResponse = await AuthRepository().getUserByTokenResponse();
    print('It is True==========>${userByTokenResponse.user?.avatar_original}');
    print('It is True==========>${userByTokenResponse.user?.name}');
    print('It is True==========>${userByTokenResponse.user?.email ?? ''}');
    print('It is True==========>${userByTokenResponse.user?.phone ?? ''}');
    print("token Response result======> ${userByTokenResponse.result}");
    if (userByTokenResponse.result == true) {
      // setUserData(userByTokenResponse);
      SystemConfig.systemUser= userByTokenResponse.user;
       is_logged_in.$ = true;
       user_id.$ = userByTokenResponse.user!.id;
       user_name.$ = userByTokenResponse.user!.name;
       user_email.$ = userByTokenResponse.user!.email!;
       user_phone.$ = userByTokenResponse.user!.phone!;
       avatar_original.$ = userByTokenResponse.user!.avatar_original;
    }else{
      clearUserData();
    }
  }
}