// To parse this JSON data, do
//
//     final confirmCodeResponse = confirmCodeResponseFromJson(jsonString);

import 'dart:convert';

CommonResponse commonResponseFromJson(String str) => CommonResponse.fromJson(json.decode(str));

String commonResponseToJson(CommonResponse data) => json.encode(data.toJson());

class CommonResponse {
  CommonResponse({
    required this.result,
    required this.message,
  });

  bool result;
  String message;

  factory CommonResponse.fromJson(Map<String, dynamic> json) {
    print(json);
   return  CommonResponse(
      result: json["result"] ?? false,
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}