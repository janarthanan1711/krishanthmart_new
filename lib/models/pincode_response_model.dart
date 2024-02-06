import 'dart:convert';

Pincode pincodeResponseFromJson(String str) =>
    Pincode.fromJson(json.decode(str));

String pincodeResponseToJson(Pincode data) =>
    json.encode(data.toJson());
class Pincode {
  List<Data>? data;
  bool? success;
  int? status;

  Pincode({this.data, this.success, this.status});

  Pincode.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    success = json['success'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int? id;
  int? cityId;
  String? name;
  int? cost;

  Data({this.id, this.cityId, this.name, this.cost});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cityId = json['city_id'];
    name = json['name'];
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city_id'] = this.cityId;
    data['name'] = this.name;
    data['cost'] = this.cost;
    return data;
  }
}