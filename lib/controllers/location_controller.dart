import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/pincode_response_model.dart';
import '../repositories/location_repository.dart';
import '../utils/shared_value.dart';

class LocationController extends GetxController {
  var currentLocation = "".obs;
  var pincodeData = "".obs;
  var isAddressSelected = false.obs;
  var pincodeIsMatched = false.obs;
  Position? position;
  var pincodeList = <Data>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUserLocation().then((value) => fetchPincodeData());
  }

  Future<void> fetchPincodeData() async {
    try {
      // Set loading to true to display loader
      isLoading.value = true;

      var pincodeResponse = await LocationRepository().getPincodeData();
      isLoading.value = false;
      // Iterate through the list of pincode data
      pincodeIsMatched.value = pincodeResponse.data!
          .any((element) => element.name == pincodeData.value);
      pincode_matched.$ = pincodeIsMatched.value;

      update();
    } catch (e) {
      // Set loading to false in case of error
      isLoading.value = false;
      print("Error fetching pincode data: $e");
    }
  }

  // Future<void> fetchPincodeData() async {
  //   try {
  //     var pincodeResponse = await LocationRepository().getPincodeData();
  //     // Iterate through the list of pincode data
  //     // bool pinCodeAvailable = pincodeResponse.data.where((element) => element.name == pincodeData.value);
  //     pincodeIsMatched.value = pincodeResponse.data!
  //         .any((element) => element.name == pincodeData.value);
  //     pincode_matched.$ = pincodeIsMatched.value;
  //     // for (var pincodeDataItem in pincodeResponse.data!) {
  //     //   // Assuming pincodeDataItem is a Data object with a pincode attribute
  //     //   if (pincodeDataItem.name == pincodeData.value) {
  //     //     print(
  //     //         "Success: Pincode ${pincodeData.value} : ${pincodeDataItem.name} found in the list.");
  //     //     // Perform any actions you need when the pincode matches
  //     //   } else {
  //     //     print(
  //     //         "Failure: Pincode ${pincodeData.value} : ${pincodeDataItem.name} not found in the list.");
  //     //     // Perform any actions you need when the pincode doesn't match
  //     //   }
  //     // }
  //     update();
  //   } catch (e) {
  //     print("Error fetching pincode data: $e");
  //   }
  // }


  Future<void> getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          throw Exception('Location permission denied forever');
        }
      } else if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high)
            .then((Position _position) {
          position = _position;
          update();
          print("Positon Gotted=====>${position}");
        }).catchError((e) {
          debugPrint(e);
        });
        print(
            'Location permission granted: ${position!.latitude} : ${position!.longitude}');
        await fetchLocationData(position!);
      } else {
        throw Exception('Location permission not granted');
      }
    } catch (e) {
      print('Error fetching user location: $e');
    }
  }

  Future<void> fetchLocationData(Position position) async {
    try {
      String apiKey = 'ff9630d3e6664aad943a4c80ddc48cfe';
      String url =
          'https://api.opencagedata.com/geocode/v1/json?q=${position.latitude},${position.longitude}&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        currentLocation.value = data['results'][0]['formatted'];
        pincodeData.value =
            await getAddressPincode(position.latitude, position.longitude);
        // pincodeData.value = '890230';
        print("fetched pincoded Value========>${pincodeData.value}");
      } else {
        print(
            'Failed to get location details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching location data: $e');
    }
  }

  Future<String> getAddressPincode(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      return place.postalCode ?? "";
    } catch (e) {
      print('Error fetching address: $e');
      return "";
    }
  }
}

// import 'dart:async';
// import 'dart:convert';
// import 'package:geocoding/geocoding.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';
// import 'package:krishanthmart_new/repositories/location_repository.dart';
// import '../models/pincode_response_model.dart';
//
// class LocationController extends GetxController {
//   var currentLocation = "".obs;
//   Position? position;
//   var locationId = "";
//   var isAddressSelected = false.obs;
//   var pincodeList = <Data>[].obs;
//   var pincodeData = ''.obs;
//   // RxList<Map<String, dynamic>> pincodeList = <Map<String, dynamic>>[].obs;
//
//   @override
//   void onInit() async {
//     await getUserLocation();
//     // await fetchPincodeData();
//     super.onInit();
//   }
//   @override
//   void onClose() {
//     pincodeList.clear();
//     super.onClose();
//   }
//
//   Future<void> fetchPincodeData() async {
//     try {
//       var pincodeResponse = await LocationRepository().getPincodeData();
//       pincodeList.addAll(pincodeResponse.data ?? []);
//       update();
//     } catch (e) {
//       print("Error fetching pincode data: $e");
//     }
//   }
//
//   Future<void> getUserLocation() async {
//     LocationPermission permission;
//     permission = await Geolocator.checkPermission();
//     try {
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.deniedForever) {
//           return Future.error('Location Not Available');
//         }
//       } else if (permission == LocationPermission.whileInUse ||
//           permission == LocationPermission.always) {
//         position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.medium,
//           forceAndroidLocationManager: true,
//         );
//
//         if (position != null) {
//           print("Position=======>${position}");
//           isAddressSelected.value = true;
//           getAddressFromLatLng();
//
//           double latitude = position!.latitude;
//           double longitude = position!.longitude;
//           await getLocationId(latitude, longitude);
//         } else {
//           print('Error: Unable to get current position');
//         }
//       } else {
//         throw Exception('Location permission not granted');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//     update();
//   }
//
//   Future<void> getLocationId(double latitude, double longitude) async {
//     String apiKey =
//         'ff9630d3e6664aad943a4c80ddc48cfe'; // Replace with your OpenCage API key
//     String url =
//         'https://api.opencagedata.com/geocode/v1/json?q=$latitude,$longitude&key=$apiKey';
//
//     try {
//       http.Response response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         Map<String, dynamic> data = jsonDecode(response.body);
//
//         // Extract the location ID or address from the response
//         locationId = data['results'][0]['formatted'];
//         print('Location ID: $locationId');
//       } else {
//         print(
//             'Failed to get location details. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//     update();
//   }
//
//   Future<void> getAddressFromLatLng() async {
//     print("address caLLLED");
//     try {
//       if (position != null) {
//         List<Placemark> placemarks = await placemarkFromCoordinates(
//             position!.latitude, position!.longitude);
//         Placemark place = placemarks[0];
//         currentLocation.value =
//             "${place.subAdministrativeArea} ${place.street}, ${place.locality},${place.country}";
//         print("pincode======>${place.postalCode}");
//         pincodeData.value = place.postalCode!;
//         update();
//         print(currentLocation.value);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
// }
