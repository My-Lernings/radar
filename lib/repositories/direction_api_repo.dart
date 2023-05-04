import 'dart:io';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locale/controllers/current_location_controller.dart';
import 'package:locale/controllers/marker_locations_controller.dart';
import 'package:locale/network_helpers/api.dart';
import 'package:locale/repositories/marker_locations_repo.dart';

class DirectionApiRepo {
  final Api api;

  DirectionApiRepo({required this.api});

  static const DIRECTIONS_API_KEY = 'AIzaSyALV6CWkpb9XXhrOA11EE3yYIpgRvP3-wQ';
  static const BASE_URI =
      'https://maps.googleapis.com/maps/api/directions/json?';

  Future<dynamic> getDirections(LatLng destination) async {
    try {
      final response = await api.get(
        url: BASE_URI +
            'origin=${Get.find<CurrentLocationController>().currentPosition!.latitude},${Get.find<CurrentLocationController>().currentPosition!.longitude}&' +
            'destination=${destination.latitude},${destination.longitude}&' +
            'key=${DIRECTIONS_API_KEY}',
      );

      if (response.statusCode == 200) {
        return ApiSuccess(success: true, body: response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } on SocketException {
      return ApiError(errorMessage: 'No internet connection', success: false);
    } catch (e) {
      return ApiError(errorMessage: e.toString(), success: false);
    }
  }

  Future<dynamic> getAdressFromLatLng(LatLng latLng) async {
    try {
      final res = await api.get(
        url:
            "https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$DIRECTIONS_API_KEY",
      );

      if (res.statusCode == 200) {
        return ApiSuccess(success: true, body: res.body);
      }
    } on SocketException {
      return ApiError(errorMessage: 'No internet connection', success: false);
    } catch (e) {
      return ApiError(errorMessage: e.toString(), success: false);
    }
  }
}
