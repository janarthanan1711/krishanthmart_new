import 'dart:convert';

SliderResponse sliderResponseFromJson(String str) => SliderResponse.fromJson(json.decode(str));
String sliderResponseToJson(SliderResponse data) => json.encode(data.toJson());

class SliderResponse {
  List<String>? image;
  List<int>? parentId;
  List<String>? parentName;
  List<String>? childId;
  List<String>? childName;

  SliderResponse(
      {this.image,
        this.parentId,
        this.parentName,
        this.childId,
        this.childName});

  SliderResponse.fromJson(Map<String, dynamic> json) {
    image = json['image'].cast<String>();
    parentId = json['parent_id'].cast<int>();
    parentName = json['parent_name'].cast<String>();
    childId = json['child_id'].cast<String>();
    childName = json['child_name'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['parent_id'] = this.parentId;
    data['parent_name'] = this.parentName;
    data['child_id'] = this.childId;
    data['child_name'] = this.childName;
    return data;
  }
}

// class SliderResponse {
//   SliderResponse({
//     this.sliders,
//     this.success,
//     this.status,
//   });
//
//   List<Slider>? sliders;
//   bool? success;
//   int? status;
//
//   factory SliderResponse.fromJson(Map<String, dynamic> json) => SliderResponse(
//     sliders: List<Slider>.from(json["data"].map((x) => Slider.fromJson(x))),
//     success: json["success"],
//     status: json["status"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "data": List<dynamic>.from(sliders!.map((x) => x.toJson())),
//     "success": success,
//     "status": status,
//   };
// }
//
// class Slider {
//   Slider({
//     this.photo,
//   });
//
//   String? photo;
//
//   factory Slider.fromJson(Map<String, dynamic> json) => Slider(
//     photo: json["image"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "image": photo,
//   };
// }

