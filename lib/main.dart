import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:locale/controllers/current_location_controller.dart';
import 'package:locale/controllers/dirctions_controller.dart';
import 'package:locale/controllers/initial_data_controller.dart';
import 'package:locale/controllers/marker_locations_controller.dart';
import 'package:locale/globals/us_globals.dart';
import 'package:locale/helpers/distance_calculator.dart';
import 'package:locale/helpers/ui_helpers/asset_icon_loader.dart';
import 'package:locale/modals/location_modal/location_modal.dart';
import 'package:locale/network_helpers/api.dart';
import 'package:locale/repositories/direction_api_repo.dart';
import 'package:locale/repositories/initial_data_repo.dart';
import 'package:locale/repositories/last_sync_location_repo.dart';
import 'package:locale/repositories/marker_locations_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'home_screen.dart';

Future<void> setupLocale() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => Api());
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => AssetIconLoader());

  Get.lazyPut(() => DistanceCalculator());

  Get.lazyPut(() => MarkerLocationsRepo());
  Get.lazyPut(() => LastSyncLocationRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => DirectionApiRepo(api: Get.find()));
  Get.lazyPut(() => InitialDataRepo(api: Get.find()));

  Get.lazyPut(() => CurrentLocationController());
  Get.lazyPut(() => MarkersController(
      markerLocationsRepo: Get.find(), lastSyncLocationRepo: Get.find()));
  Get.lazyPut(() => DirectionsController(directionApiRepo: Get.find()));
  Get.lazyPut(() => InitialDataController(
      sharedPreferences: Get.find(), initialDataRepo: Get.find()));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded<Future<void>>(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await setupLocale();
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(LocationAdapter().typeId)) {
      Hive.registerAdapter(LocationAdapter());
    }

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    runApp(const MyApp());
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<InitialDataController>().getAllCamerasIfFirstTime();
    return GetMaterialApp(
      scaffoldMessengerKey: mapScreenScaffoldKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
