import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:locale/globals/string_constants.dart';
import 'package:locale/modals/location_modal/location_modal.dart';
import 'package:locale/repositories/initial_data_repo.dart';
import 'package:locale/repositories/marker_locations_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialDataController extends GetxController {
  InitialDataController(
      {required this.sharedPreferences, required this.initialDataRepo});

  final InitialDataRepo initialDataRepo;
  final SharedPreferences sharedPreferences;

  Future<void> getAllCamerasIfFirstTime() async {
    if (sharedPreferences.getBool(StringConstants.SHPREF_FIRST_TIME) ?? true) {
      List<LocationModal> camerasList = [];
      final response = await initialDataRepo.getAllCameras();

      if (response is ApiSuccess) {
        final cameras = jsonDecode(response.body);
        for (final camera in cameras) {
          final location = LocationModal.fromJson(camera);
          camerasList.add(location);
        }
        await addAllLocation(camerasList);
        sharedPreferences.setBool(StringConstants.SHPREF_FIRST_TIME, false);
      } else {
        FirebaseCrashlytics.instance
            .recordError(response.toString(), StackTrace.current);
      }
    }
  }
}

Future<void> addAllLocation(List<LocationModal> locations) async {
  final studabtDb =
      await Hive.openBox<LocationModal>(StringConstants.HIVE_BOX_ALL_CAM);
  final _id = await studabtDb.addAll(locations);
}

Future<List<LocationModal>> getAllLocation() async {
  List<LocationModal> locations = [];
  final studabtDb =
      await Hive.openBox<LocationModal>(StringConstants.HIVE_BOX_ALL_CAM);
  studabtDb.values.forEach((element) {
    final location = LocationModal.fromJson(element.toJson());
    locations.add(location);
  });
  if (locations.isEmpty) {
    throw Exception('No locations found');
  }
  return locations;
}
