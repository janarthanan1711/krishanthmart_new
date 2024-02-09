import 'dart:convert';

List<BusinessLogicResponseDatas> businessLogicResponseDatasFromJson(String str) =>
    List<BusinessLogicResponseDatas>.from(
      json.decode(str)['data'].map(
            (x) => BusinessLogicResponseDatas.fromJson(x),
      ),
    );

String businessLogicResponseDatasToJson(
    List<BusinessLogicResponseDatas> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusinessLogicResponseDatas {
  List<Datum> data;
  bool success;
  int status;

  BusinessLogicResponseDatas({
    required this.data,
    required this.success,
    required this.status,
  });

  factory BusinessLogicResponseDatas.fromJson(Map<String, dynamic> json) {
    var jsonData = json["data"];
    List<Datum> dataList;

    if (jsonData is List) {
      dataList = jsonData
          .map((x) => Datum.fromJson(x as Map<String, dynamic>))
          .toList();
    } else if (jsonData is Map && jsonData.containsKey("value")) {
      dataList = (jsonData["value"] as List<dynamic>? ?? [])
          .map((x) => Datum.fromJson(x as Map<String, dynamic>))
          .toList();
    } else {
      dataList = [];
    }

    return BusinessLogicResponseDatas(
      data: dataList,
      success: json["success"] ?? false,
      status: json["status"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": List<dynamic>.from(data.map((x) => x.toJson())),
      "success": success,
      "status": status,
    };
  }
}

class Datum {
  String type;
  dynamic value;

  Datum({
    required this.type,
    required this.value,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      type: json["type"],
      value: json["value"].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "value": value,
    };
  }
}