
import 'dart:convert';

SubChildResponse subChildResponseFromJson(String str) => SubChildResponse.fromJson(json.decode(str));

String subChildResponseToJson(SubChildResponse data) => json.encode(data.toJson());
class SubChildResponse {
  SubChildResponse({
    required this.subChildCategory,
    required this.success,
    required this.status,
  });

  final List<SubChildCategories> subChildCategory;
  final bool? success;
  final int? status;

  factory SubChildResponse.fromJson(Map<String, dynamic> json){
    return SubChildResponse(
      subChildCategory: json["data"] == null ? [] : List<SubChildCategories>.from(json["data"]!.map((x) => SubChildCategories.fromJson(x))),
      success: json["success"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "data": subChildCategory.map((x) => x.toJson()).toList(),
    "success": success,
    "status": status,
  };

}

class SubChildCategories {
  SubChildCategories({
    required this.id,
    required this.name,
    required this.banner,
    required this.icon,
    required this.numberOfChildren,
    required this.links,
  });

  final int? id;
  final String? name;
  final String? banner;
  final String? icon;
  final int? numberOfChildren;
  final Links? links;

  factory SubChildCategories.fromJson(Map<String, dynamic> json){
    return SubChildCategories(
      id: json["id"],
      name: json["name"],
      banner: json["banner"],
      icon: json["icon"],
      numberOfChildren: json["number_of_children"],
      links: json["links"] == null ? null : Links.fromJson(json["links"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "banner": banner,
    "icon": icon,
    "number_of_children": numberOfChildren,
    "links": links?.toJson(),
  };

}

class Links {
  Links({
    required this.products,
    required this.subCategories,
  });

  final String? products;
  final String? subCategories;

  factory Links.fromJson(Map<String, dynamic> json){
    return Links(
      products: json["products"],
      subCategories: json["sub_categories"],
    );
  }

  Map<String, dynamic> toJson() => {
    "products": products,
    "sub_categories": subCategories,
  };

}
