// To parse this JSON VariantData, do
//
//     final variantResponse = variantResponseFromJson(jsonString);

import 'dart:convert';

VariantResponse variantResponseFromJson(String str) =>
    VariantResponse.fromJson(json.decode(str));

String variantResponseToJson(VariantResponse VariantData) =>
    json.encode(VariantData.toJson());

class VariantResponse {
  bool? result;
  VariantData? variantData;

  VariantResponse({
    this.result,
    this.variantData,
  });

  factory VariantResponse.fromJson(Map<String, dynamic> json) =>
      VariantResponse(
        result: json["result"],
        variantData:
            json["data"] != null ? VariantData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "data": variantData != null ? variantData!.toJson() : null,
      };
}

class VariantData {
  String? price;
  int? stock;
  var stockTxt;
  int? digital;
  String? variant;
  String? variation;
  int? maxLimit;
  int? inStock;
  String? image;
  String? priceDis;
  String? mrp;
  int? discount;

  VariantData(
      {this.price,
      this.stock,
      this.stockTxt,
      this.digital,
      this.variant,
      this.variation,
      this.maxLimit,
      this.inStock,
      this.image,
      this.priceDis,
      this.mrp,
      this.discount});

  factory VariantData.fromJson(Map<String, dynamic> json) => VariantData(
      price: json["price"] ?? 0,
      stock: int.parse(json["stock"].toString()),
      stockTxt: json["stock_txt"] ?? "",
      digital: int.parse(json["digital"].toString()),
      variant: json["variant"],
      variation: json["variation"],
      maxLimit: int.parse(json["max_limit"].toString()),
      inStock: int.parse(json["in_stock"].toString()),
      image: json["image"],
      priceDis: json['price_dis'] ?? 0,
      mrp: json['mrp'] ?? 0,
      discount: json['discount'] ?? 0);

  Map<String, dynamic> toJson() => {
        "price": price,
        "stock": stock,
        "digital": digital,
        "variant": variant,
        "variation": variation,
        "max_limit": maxLimit,
        "in_stock": inStock,
        "image": image,
        "mrp": mrp,
        "price_dis": priceDis,
        "discount": discount
      };
}
