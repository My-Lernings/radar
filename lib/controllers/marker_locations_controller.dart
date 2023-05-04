import 'package:firebase_performance/firebase_performance.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locale/globals/string_constants.dart';
import 'package:locale/helpers/ui_helpers/asset_icon_loader.dart';
import 'dart:async';

import 'package:locale/modals/location_modal/location_modal.dart';
import 'package:locale/repositories/marker_locations_repo.dart';
import '../repositories/last_sync_location_repo.dart';

Trace getNearestCamerasTrace =
    FirebasePerformance.instance.newTrace('getNearestCamerasTrace');

class MarkersController extends GetxController {
  MarkersController(
      {required this.lastSyncLocationRepo, required this.markerLocationsRepo});
  final MarkerLocationsRepo markerLocationsRepo;
  final LastSyncLocationRepo lastSyncLocationRepo;

  // LatLng? _destination;
  // LatLng? get destination => _destination;
  // set destination(LatLng? value) {
  //   _destination = value;
  //   update();
  // }

  Map<MarkerId, Marker> _markers = {};
  Map<MarkerId, Marker> get markers => _markers;

  void updateMarkersCameraList(List<LocationModal> locations) async {
    final cameraIcon =
        await Get.find<AssetIconLoader>().getMarkerIcon('pvds_cam');
    _markers.removeWhere((key, value) =>
        key != const MarkerId(StringConstants.DESTINATION) &&
        key != const MarkerId(StringConstants.START) &&
        key != const MarkerId(StringConstants.CAR));

    for (var element in locations) {
      _markers[MarkerId(element.dbId)] = Marker(
        markerId: MarkerId(element.dbId),
        position: LatLng(element.latitude, element.longitude),
        icon: cameraIcon,
      );
    }
    update();
  }

  void addOrUpdateMarkerWithId(
      {required Marker marker, required MarkerId markerId}) {
    _markers[markerId] = marker;
    update();
  }

  void removeMarkerWithId({required MarkerId markerId}) {
    _markers.remove(markerId);
    update();
  }

  List<LocationModal> _markerLocations = [];
  List<LocationModal> get markerLocations => _markerLocations;
  set markerLocations(List<LocationModal> value) {
    _markerLocations = value;
    update();
  }

  double _currentZoom = 8;
  double get currentZoom => _currentZoom;
  set currentZoom(double value) {
    _currentZoom = value;
  }

  Future<void> getNearestCameras(
      {required String lat, required String long}) async {
    await getNearestCamerasTrace.start();
    _markerLocations.clear();
    List<LocationModal> locations =
        await markerLocationsRepo.getCameras(lat: lat, long: long);
    markerLocations = locations;
    lastSyncLocationRepo.setLastSyncLocation(lat, long);
    updateMarkersCameraList(locations);
    update();
    await getNearestCamerasTrace.stop();
  }

  Future<LatLng> getLastSyncLocation() async {
    final list = await lastSyncLocationRepo.getLastSyncLocation();
    if (list.isNotEmpty) {
      return LatLng(list[0], list[1]);
    } else {
      return const LatLng(0, 0);
    }
  }
}
