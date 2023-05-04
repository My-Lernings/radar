import 'dart:convert';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:locale/controllers/current_location_controller.dart';
import 'package:locale/controllers/marker_locations_controller.dart';
import 'package:locale/helpers/distance_calculator.dart';
import 'package:locale/modals/address_modal.dart';
import 'package:locale/modals/directions_modal.dart';
import 'package:locale/repositories/direction_api_repo.dart';
import 'package:locale/repositories/marker_locations_repo.dart';

class DirectionsController extends GetxController {
  final DirectionApiRepo directionApiRepo;

  DirectionsController({required this.directionApiRepo});

  DirectiondModal? _directions;
  DirectiondModal? get directions => _directions;
   set setDirections(DirectiondModal? value) {
    _directions = value;
    update();
  }

  Address? _destinationAddress;
  Address? get destinationAddress => _destinationAddress;

  LatLng? _destination;
  LatLng? get destination => _destination;
  set destination(LatLng? destination) {
    _destination = destination;
    update();
  }



  Future<dynamic> getDirections() async {
    if (_destination == null) {
      return;
    }
    final res = await directionApiRepo.getDirections(destination!);
    if (res is ApiSuccess) {
      DirectiondModal directions =
          DirectiondModal.fromMap(jsonDecode(res.body));
      final filteredList = await Get.find<DistanceCalculator>()
          .findCamerasOnRoute(directions.polylinePoints);
      Get.find<MarkersController>().updateMarkersCameraList(filteredList);
      Get.find<MarkersController>().markerLocations = filteredList;
      setDirections = directions;
      Get.find<CurrentLocationController>().animateCameraToBounds(
        bounds: directions.bounds,
        padding: 20,
      );
      return res.body;
    } else {
      throw Exception(res.errorMessage);
    }
  }

  Future<Address> getAddressFromLatLng(LatLng latLng) async {
    final res = await directionApiRepo.getAdressFromLatLng(latLng);

    if (res is ApiSuccess) {
      final response = jsonDecode(res.body);
      final address = Address.fromJson(response['results'][0]);

      _destinationAddress = address;
      return address;
    } else {
      print(res);
      throw Exception(res.errorMessage);
    }
  }
}
