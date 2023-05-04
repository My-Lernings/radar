import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:locale/controllers/initial_data_controller.dart';
import 'package:locale/helpers/distance_calculator.dart';
import 'package:locale/modals/location_modal/location_modal.dart';
import 'package:locale/network_helpers/api.dart';

class MarkerLocationsRepo {
  Future<List<LocationModal>> getCameras(
      {required String lat, required String long}) async {
    List<LocationModal> filteredLocations = [];
    try {
      final allLocations = await getAllLocation();
      filteredLocations = Get.find<DistanceCalculator>().filterWithRadius(
          latitude: double.parse(lat),
          longitude: double.parse(long),
          radius: 20000,
          list: allLocations);
    } catch (e) {
      throw e;
    }

    return filteredLocations;
  }
}

class ApiSuccess {
  ApiSuccess({required this.success, required this.body});
  final String body;
  final bool success;
}

class ApiError {
  ApiError({required this.success, required this.errorMessage});
  final String errorMessage;
  final bool success;
}


    // try {
    //   final response = await api.post(
    //     url: URI,
    //     body: {
    //       'lat': lat,
    //       'long': long,
    //     },
    //   );

    //   if (response.statusCode == 200) {
    //     return ApiSuccess(body: response.body, success: true);
    //   } else {
    //     final res = jsonDecode(response.body);
    //     return ApiError(errorMessage: res['message'], success: false);
    //   }
    // } on SocketException {
    //   return ApiError(errorMessage: 'No internet connection', success: false);
    // } catch (e) {
    //   return ApiError(errorMessage: e.toString(), success: false);
    // }