import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:krishanthmart_new/helpers/api_helpers.dart';
import 'package:krishanthmart_new/models/login_model.dart';
import 'package:krishanthmart_new/utils/app_config.dart';
import 'package:krishanthmart_new/utils/shared_value.dart';

import '../models/common_response.dart';
import '../models/confirm_code_response.dart';
import '../models/password_confirm_response.dart';
import '../models/password_forget_response.dart';
import '../models/resend_code_response.dart';

class AuthRepository {
  Future<LoginResponse> getLoginResponse(
      String? email, String password, String loginBy) async {
    var post_body = jsonEncode({
      "email": "$email",
      "password": password,
      // "identity_matrix": AppConfig.purchase_code,
      "login_by": loginBy
    });

    String url = ("${AppConfig.BASE_URL}/auth/login");
    final response = await http.post(Uri.parse(url),
        headers: {
          // "Accept": "*/*",
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: post_body);

    // print("post Login Data==========>${post_body}");
    //
    // print("login data ====> ${response.body}");

    return loginResponseFromJson(response.body);
  }

  Future<LoginResponse> getSocialLoginResponse(
    String social_provider,
    String? name,
    String? email,
    String? provider, {
    access_token = "",
    secret_token = "",
  }) async {
    email = email == ("null") ? "" : email;

    var post_body = jsonEncode({
      "name": name,
      "email": email,
      "provider": "$provider",
      "social_provider": social_provider,
      "access_token": "$access_token",
      "secret_token": "$secret_token"
    });

    print(post_body);
    String url = ("${AppConfig.BASE_URL}/auth/social-login");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: post_body);
    print(post_body);
    print(response.body.toString());
    return loginResponseFromJson(response.body);
  }

  // Future<LogoutResponse> getLogoutResponse() async {
  //   String url = ("${AppConfig.BASE_URL}/auth/logout");
  //   final response = await ApiRequest.get(
  //     url: url,
  //     headers: {
  //       "Authorization": "Bearer ${access_token.$}",
  //       "App-Language": app_language.$!,
  //     },
  //   );
  //
  //   print(response.body);
  //
  //   return logoutResponseFromJson(response.body);
  // }
  //
  Future<CommonResponse> getAccountDeleteResponse() async {
    String url = ("${AppConfig.BASE_URL}/auth/account-deletion");

    print(url.toString());

    print("Bearer ${access_token.$}");
    final response = await ApiRequest.get(
      url: url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },
    );
    print(response.body);
    return commonResponseFromJson(response.body);
  }

  Future<LoginResponse> getSignupResponse(
    String name,
    String? email_or_phone,
    String password,
    String passowrd_confirmation,
    String register_by,
    // String capchaKey,
  ) async {
    var post_body = jsonEncode({
      "name": name,
      "email_or_phone": "$email_or_phone",
      "password": password,
      "password_confirmation": passowrd_confirmation,
      "register_by": register_by,
      // "g-recaptcha-response": capchaKey,
    });

    String url = ("${AppConfig.BASE_URL}/auth/signup");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: post_body);
    // print("Signup_Response=========>${post_body}");
    // print("Signup_Response=========>${response.body}");
    return loginResponseFromJson(response.body);
  }

  // Future<ResendCodeResponse> getResendCodeResponse() async {
  //   String url = ("${AppConfig.BASE_URL}/auth/resend_code");
  //   final response = await ApiRequest.get(
  //     url: url,
  //     headers: {
  //       "Content-Type": "application/json",
  //       "App-Language": app_language.$!,
  //       "Authorization": "Bearer ${access_token.$}",
  //     },);
  //   return resendCodeResponseFromJson(response.body);
  // }

  Future<ConfirmCodeResponse> getConfirmCodeResponse(
      String verification_code) async {
    var post_body = jsonEncode({"verification_code": "$verification_code"});

    String url = ("${AppConfig.BASE_URL}/auth/confirm_code");
    print(url);
    print(post_body);
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
          "Authorization": "Bearer ${access_token.$}",
        },
        body: post_body);

    return confirmCodeResponseFromJson(response.body);
  }

  Future<PasswordForgetResponse> getPasswordForgetResponse(
      String? email_or_phone, String send_code_by) async {
    var post_body = jsonEncode(
        {"email_or_phone": "$email_or_phone", "send_code_by": "$send_code_by"});

    String url = ("${AppConfig.BASE_URL}/auth/password/forget_request");

    print(url.toString());
    print(post_body.toString());

    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: post_body);

    return passwordForgetResponseFromJson(response.body);
  }

  Future<PasswordConfirmResponse> getPasswordConfirmResponse(
      String verification_code, String password) async {
    var post_body = jsonEncode(
        {"verification_code": "$verification_code", "password": "$password"});

    String url = ("${AppConfig.BASE_URL}/auth/password/confirm_reset");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: post_body);

    return passwordConfirmResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getPasswordResendCodeResponse(
      String? email_or_code, String verify_by) async {
    var post_body = jsonEncode(
        {"email_or_code": "$email_or_code", "verify_by": "$verify_by"});

    String url = ("${AppConfig.BASE_URL}/auth/password/resend_code");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$!,
        },
        body: post_body);

    return resendCodeResponseFromJson(response.body);
  }

  Future<LoginResponse> getUserByTokenResponse(access_token) async {
    // var post_body = jsonEncode(
    //     {"access_token": "${access_token.$ != null ? access_token.$ : ''}"});
    var post_body = jsonEncode({"access_token": "$access_token"});

    String url = ("${AppConfig.BASE_URL}/get-user-by-access_token");
      final response = await ApiRequest.post(
          url: url,
          headers: {
            "Content-Type": "application/json",
            "App-Language": app_language.$!,
          },
          body: post_body);
      // print("auth Post----${post_body}");
      // print("auth Info -------${response.body}");
      return loginResponseFromJson(response.body);

    return LoginResponse();
  }
}
