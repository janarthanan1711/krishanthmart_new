import 'dart:convert';
import '../helpers/api_helpers.dart';
import '../helpers/middleware/banned_user.dart';
import '../models/simple_image_upload.dart';
import '../utils/app_config.dart';
import '../utils/shared_value.dart';

class FileRepository {
  Future<dynamic> getSimpleImageUploadResponse(
      String image,  String filename) async {
    var post_body = jsonEncode({"image": "${image}", "filename": "$filename"});

    String url=("${AppConfig.BASE_URL}/file/image-upload");
    final response = await ApiRequest.post(url:url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body,middleware: BannedUser());

    return simpleImageUploadResponseFromJson(response.body);
  }
}