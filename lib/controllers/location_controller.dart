import 'dart:async';
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:krishanthmart_new/repositories/location_repository.dart';
import '../models/pincode_response_model.dart';

class LocationController extends GetxController {
  var currentLocation = "".obs;
  Position? position;
  var locationId = "";
  var isAddressSelected = false.obs;
  var pincodeList = <Data>[].obs;
  // RxList<Map<String, dynamic>> pincodeList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    getUserLocation();
    fetchPincodeData();
    super.onInit();
  }
  @override
  void onClose() {
    pincodeList.clear();
    super.onClose();
  }

  Future<void> fetchPincodeData() async {
    try {
      var pincodeResponse = await LocationRepository().getPincodeData();
      pincodeList.addAll(pincodeResponse.data ?? []);
      update();
    } catch (e) {
      print("Error fetching pincode data: $e");
    }
  }


  // Future<void> fetchPincodeData() async {
  //   try {
  //     final pincodeResponse = await LocationRepository().getPincodeData();
  //     if (pincodeResponse.success == true) {
  //       print(pincodeList);
  //       pincodeList.assignAll(pincodeResponse.data!.map((pincode) => pincode.name!));
  //     }
  //   } catch (e) {
  //     // Handle error
  //     print("Error fetching pincode data: $e");
  //   }
  // }


//   getPincodeFromServer() async {
//     var pincodeResponse = await LocationRepository().getPincodeData();
//     pincodeList.add(pincodeResponse.data!);
// }

  Future<void> getUserLocation() async {
    print("Calling location Function");
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    try {
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          return Future.error('Location Not Available');
        }
      } else if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          forceAndroidLocationManager: true,
        );

        if (position != null) {
          isAddressSelected.value = true;
          await getAddressFromLatLng();

          double latitude = position!.latitude;
          double longitude = position!.longitude;
          await getLocationId(latitude, longitude);
        } else {
          print('Error: Unable to get current position');
        }
      } else {
        throw Exception('Location permission not granted');
      }
    } catch (e) {
      print('Error: $e');
    }
    update();
  }

  Future<void> getLocationId(double latitude, double longitude) async {
    String apiKey =
        'ff9630d3e6664aad943a4c80ddc48cfe'; // Replace with your OpenCage API key
    String url =
        'https://api.opencagedata.com/geocode/v1/json?q=$latitude,$longitude&key=$apiKey';

    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        // Extract the location ID or address from the response
        locationId = data['results'][0]['formatted'];
        print('Location ID: $locationId');
      } else {
        print(
            'Failed to get location details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    update();
  }

  getAddressFromLatLng() async {
    print("address caLLLED");
    try {
      if (position != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position!.latitude, position!.longitude);
        Placemark place = placemarks[0];
        currentLocation.value =
            "${place.subAdministrativeArea} ${place.street}, ${place.locality},${place.country}";
        print("pincode======>${place.postalCode}");
        print(currentLocation.value);
      }
    } catch (e) {
      print(e);
    }

  }
}
