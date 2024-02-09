class DeliverySlot {
  List<TimeDelivery>? data;
  DeliverySlot({this.data});

  DeliverySlot.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TimeDelivery>[];
      json['data'].forEach((v) {
        data!.add(new TimeDelivery.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeDelivery {
  int? id;
  String? name;
  String? logo;
  String? transitTime;
  int? freeShipping;
  int? status;
  String? createdAt;
  String? updatedAt;

  TimeDelivery(
      {this.id,
        this.name,
        this.logo,
        this.transitTime,
        this.freeShipping,
        this.status,
        this.createdAt,
        this.updatedAt});

  TimeDelivery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    transitTime = json['transit_time'];
    freeShipping = json['free_shipping'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['transit_time'] = this.transitTime;
    data['free_shipping'] = this.freeShipping;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}