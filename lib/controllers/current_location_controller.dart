import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locale/controllers/marker_locations_controller.dart';
import 'package:locale/globals/string_constants.dart';
import 'package:locale/globals/us_globals.dart';
import 'package:locale/helpers/ui_helpers/asset_icon_loader.dart';
import 'package:locale/modals/location_modal/location_modal.dart';

import '../helpers/distance_calculator.dart';

class CurrentLocationController extends GetxController {
  Completer<GoogleMapController> _controller = Completer();
  Completer<GoogleMapController> get getController => _controller;
  set setController(Completer<GoogleMapController> value) =>
      _controller = value;

  bool _streamInitialized = false;
  bool get streamInitialized => _streamInitialized;

  bool _defaultLocationIconEnabled = true;
  bool get defaultLocationIconEnabled => _defaultLocationIconEnabled;
  set setdefaultLocationIconEnabled(bool v) {
    _defaultLocationIconEnabled = v;
    update();
  }

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;
  set setCurrentPos(Position v) {
    _currentPosition = v;
    update();
  }

  late StreamSubscription<Position>? _positionStream;
  StreamSubscription<Position>? get positionStream => _positionStream;
  set setPosStream(StreamSubscription<Position>? v) {
    _positionStream = v;
    update();
  }

  Set<Circle> _currentCircle = {};
  Set<Circle> get currentCircle => _currentCircle;
  set addCircle(Circle value) {
    _currentCircle.add(value);
    update();
  }

  set setCurrentCircle(Set<Circle> value) {
    _currentCircle = value;
    update();
  }

  AppMode _appMode = AppMode.WATCH;
  AppMode get appMode => _appMode;
  set setAppMode(AppMode value) {
    _appMode = value;
    update();
  }

  LocationSettings? locationSettings;
  @override
  void onInit() async {
    locationSettings = _createLocationSetting();
    super.onInit();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
  }

  Future<void> _updateCameraOnTenKm(Position? position) async {
    double distance;
    final lastSyncPos =
        await Get.find<MarkersController>().getLastSyncLocation();

    if (position != null) {
      distance = Geolocator.distanceBetween(lastSyncPos.latitude,
          lastSyncPos.longitude, position.latitude, position.longitude);

      if (distance > 10000) {
        Get.find<MarkersController>().getNearestCameras(
            lat: position.latitude.toString(),
            long: position.longitude.toString());
      }
    }
  }

  // Future<void> switchDriveModes(bool goToDrive) async {
  //   final Uint8List markerIconAi =
  //       await getBytesFromAsset('assets/images/car.png', 50);
  //   final BitmapDescriptor carIcon = BitmapDescriptor.fromBytes(markerIconAi);

  //   getCurrentLocation().then((value) => goToDrive
  //       ? animateCameraToPosition(position: value!, zoom: 15, tilt: 80)
  //       : animateCameraToPosition(position: value!, zoom: 10, tilt: 80));
  //   if (goToDrive) {
  //     subscribeUnsubscribeToLocationUpdates(true);
  //   } else {
  //     subscribeUnsubscribeToLocationUpdates(false);
  //   }
  // }

  Future<StreamSubscription<Position>?> subscribeUnsubscribeToLocationUpdates(
      bool subscribe) async {
    final BitmapDescriptor carIcon =
        await Get.find<AssetIconLoader>().getMarkerIcon('car');
    StreamSubscription<Position> positionStreamSubscription;

    if (subscribe) {
      setdefaultLocationIconEnabled = false;
      _streamInitialized = true;

      if (_currentPosition != null) {
        animateCameraToPosition(
            position: _currentPosition!, zoom: 15, tilt: 80);
      }

      positionStreamSubscription =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position? position) {
        if (position != null) {
          _updateCameraOnTenKm(position);
          setCurrentPos = position;
          animateCameraToPosition(position: position, zoom: 15, tilt: 0);
          localBasedCameraListCalculatorOfOneKm(position);

          ///TODO: possible memory leak
          const MarkerId markerId = MarkerId(StringConstants.CAR);
          Get.find<MarkersController>().addOrUpdateMarkerWithId(
              marker: Marker(
                  markerId: markerId,
                  flat: true,
                  anchor: const Offset(.5, .5),
                  rotation: position.heading,
                  position: LatLng(position.latitude, position.longitude),
                  icon: carIcon),
              markerId: markerId);

          setCurrentCircle = {
            _createCircle(
                position, 20001, 'circle20K', Colors.lightBlue.withOpacity(.05))
          };
          addCircle = _createCircle(
              position, 500, 'circle100', Colors.red.withOpacity(.05));
        }
      });
      setPosStream = positionStreamSubscription;
      update();
      return positionStreamSubscription;
    } else {
      _defaultLocationIconEnabled = true;
      const MarkerId markerId = MarkerId(StringConstants.CAR);
      Get.find<MarkersController>().removeMarkerWithId(markerId: markerId);
      positionStream?.cancel();
      setPosStream = null;
      animateCameraToPosition(position: _currentPosition!, zoom: 10, tilt: 80);
      update();
      return null;
    }
  }

  Future<Position?> getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      _currentPosition = position;
      update();
      await _onCureentLocationFetch();
      return position;
    } catch (e) {
      mapScreenScaffoldKey.currentState?.showSnackBar(SnackBar(
        action: SnackBarAction(
          onPressed: () {
            Geolocator.openLocationSettings();
          },
          label: 'Open Settings',
        ),
        content: Text(e.toString()),
      ));
      return null;
    }
  }

  Future<void> _onCureentLocationFetch() async {
    if (currentPosition != null) {
      Get.find<MarkersController>().getNearestCameras(
        lat: currentPosition!.latitude.toString(),
        long: currentPosition!.longitude.toString(),
      );
      animateCameraToPosition(position: currentPosition!, zoom: 10, tilt: 0.0);
      setCurrentCircle = {
        _createCircle(currentPosition!, 20001, StringConstants.CIRCLE20K,
            Colors.lightBlue.withOpacity(.05))
      };
    }
  }

  void animateCameraToPosition(
      {required Position position,
      required double zoom,
      required double tilt}) {
    _controller.future.asStream().listen((GoogleMapController controller) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(
            position.latitude,
            position.longitude,
          ),
          zoom: zoom)));
    });
  }

  void animateCameraToBounds({
    required LatLngBounds bounds,
    required double padding,
  }) {
    _controller.future.asStream().listen((GoogleMapController controller) {
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, padding));
    });
  }

  Circle _createCircle(
      Position position, double radius, String id, Color color) {
    return Circle(
      fillColor: color,
      strokeWidth: 1,
      circleId: CircleId(id),
      center: LatLng(position.latitude, position.longitude),
      radius: radius,
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  List<LocationModal> _listIn1Km = [];
  List<LocationModal> get listIn1Km => _listIn1Km;
  set setListIn1Km(List<LocationModal> value) {
    _listIn1Km = value;
    update();
  }

  void localBasedCameraListCalculatorOfOneKm(Position position) {
    setListIn1Km = Get.find<DistanceCalculator>().filterWithRadius(
        latitude: position.latitude,
        longitude: position.longitude,
        radius: 1000,
        list: Get.find<MarkersController>().markerLocations);
  }

  LocationSettings _createLocationSetting() {
    late LocationSettings locationSettings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 1,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Locale  will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        activityType: ActivityType.fitness,
        distanceFilter: 1,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
      );
    }
    return locationSettings;
  }
}

//         .listen((Position? position) async {
//
//   if (position != null) {
//     print('new pos');
//
//     setCurrentPos = position;
//     animateCameraToPosition(position: position, zoom: 17, tilt: 80);
//
//     await Get.find<MarkerLocationsController>().getNearestCameras(
//       lat: position.latitude.toString(),
//       long: position.longitude.toString(),
//     );
//     Get.find<MarkerLocationsController>().updateMarker(Marker(
//         markerId: const MarkerId('car'),
//         position: LatLng(position.latitude, position.longitude),
//         icon: carIcon));
//     setCurrentCircle ={
//       _createCircle(position, 20001,'circle20K',Colors.lightBlue.withOpacity(.05))
//     };
//
//     addCircle = _createCircle(position, 1000, 'circle100',Colors.red.withOpacity(.05));
//   }
// });
//
//setPosSubscription = positionStream as StreamSubscription<Position>;

enum AppMode {
  // ignore: constant_identifier_names
  DRIVE,
  // ignore: constant_identifier_names
  WATCH,
}
