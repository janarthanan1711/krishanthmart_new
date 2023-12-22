import 'package:flutter/material.dart';
import 'package:krishanthmart_new/utils/colors.dart';
import 'package:krishanthmart_new/utils/size_config.dart';

const AnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: MyTheme.SecondaryColorDark,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
final RegExp passwordValidatorRegExp = RegExp(r'^(?=.*?[a-zA-Z])(?=.*?[0-9])');
final RegExp phoneNumValidatorRegExp = RegExp(r'^[0-9]{11}$');
final RegExp nameValidatorRegExp = RegExp(r'^[a-zA-Z\s]*$');

const String EmailNullError = 'Please Enter your email';
const String InvalidEmailError = 'Please Enter a valid email';
const String InvalidPassError = 'Password must contain both letters and numbers';
const String InvalidPhoneNumError = 'Phone number must contain 11 numbers';
const String InvalidNameError = 'Name must contain letters only';
const String PassNullError = 'Please Enter your password';
const String ShortPassError = 'Password must contain at least 8 characters';
const String MatchPassError = "Passwords don't match";
const String NameNullError = 'Please Enter your name';
const String PhoneNumberNullError = 'Please Enter your phone number';
const String AddressNullError = 'Please Enter your address';
const String WrongEorP = 'Wrong email or password';

final otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(2)),
    borderSide: const BorderSide(color: MyTheme.SecondaryColorDark),
  );
}

