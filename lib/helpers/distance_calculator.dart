import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locale/controllers/initial_data_controller.dart';
import 'package:locale/controllers/marker_locations_controller.dart';
import 'package:locale/modals/location_modal/location_modal.dart';

class DistanceCalculator {
  List<LocationModal> filterWithRadius(
      {required double latitude,
      required double longitude,
      required int radius,
      required List<LocationModal> list}) {
    List<LocationModal> filteredList = [];
    if (list.isNotEmpty) {
      for (var element in list) {
        if (_calculateDistanceBetweenTwoPoints(
                element.latitude, element.longitude, latitude, longitude) <
            radius) {
          filteredList.add(element);
        }
      }
    }
    return filteredList;
  }

  Future<List<LocationModal>> findCamerasOnRoute(
    List<PointLatLng> routePoints,
  ) async {
    final list = await getAllLocation();
    print(list.length);
    List<LocationModal> filteredList = [];
    if (list.isNotEmpty) {
      for (var element in list) {
        for (var point in routePoints) {
          if (_calculateDistanceBetweenTwoPoints(element.latitude,
                  element.longitude, point.latitude, point.longitude) <
              500) {
            filteredList.add(element);
          }
        }
      }
    }
    
    return filteredList;
  }

  double _calculateDistanceBetweenTwoPoints(double startLatitude,
      double startLongitude, double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }
}
