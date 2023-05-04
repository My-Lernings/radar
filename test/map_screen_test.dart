// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility that Flutter provides. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:locale/controllers/current_location_controller.dart';
// import 'package:locale/controllers/marker_locations_controller.dart';
// import 'package:locale/globals/us_globals.dart';
// import 'package:locale/helpers/distance_calculator.dart';
// import 'package:locale/home_screen.dart';

// import 'package:locale/main.dart';
// import 'package:locale/network_helpers/api.dart';
// import 'package:locale/repositories/last_sync_location_repo.dart';
// import 'package:locale/repositories/marker_locations_repo.dart';
// import 'package:locale/screens/map_screen/map_screen.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> setupLocale() async {
//   SharedPreferences.setMockInitialValues({});
//   final sharedPreferences = await SharedPreferences.getInstance();
//   Get.lazyPut(() => Api());
//   Get.lazyPut(() => sharedPreferences);

//   Get.lazyPut(() => DistanceCalculator());

//   Get.lazyPut(() => MarkerLocationsRepo(api: Get.find()));
//   Get.lazyPut(() => LastSyncLocationRepo(sharedPreferences: Get.find()));

//   Get.lazyPut(() => CurrentLocationController());
//   Get.lazyPut(() => MarkerLocationsController(
//       markerLocationsRepo: Get.find(), lastSyncLocationRepo: Get.find()));
// }

// class MockMarkerLocationsController extends Mock
//     implements MarkerLocationsController {}

// Widget createWidgetUnderTest() {
//   return MaterialApp(
//     scaffoldMessengerKey: mapScreenScaffoldKey,
//     theme: ThemeData(
//       primarySwatch: Colors.blue,
//     ),
//     home: MapScreen(),
//   );
// }

// late MockMarkerLocationsController mockMarkerLocationsController;
// void main() {
//   setUp(() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await setupLocale();
//     mockMarkerLocationsController = MockMarkerLocationsController();
//   });

//   final markers = [
//     Marker(
//         markerId: MarkerId('markerId1'),
//         position: LatLng(11.589878, 75.725379)),
//     Marker(
//         markerId: MarkerId('markerId2'),
//         position: LatLng(11.549878, 75.729379)),
//     Marker(
//         markerId: MarkerId('markerId3'),
//         position: LatLng(11.589878, 75.725379)),
//   ];

//   arrangeMarkerLocations() async {
//     when(() async => mockMarkerLocationsController.getNearestCameras(
//             lat: '11.589878', long: '75.725379'))
//         .thenAnswer((_) async => await Future.value(markers));
//   }

//   testWidgets('Map screen test', (WidgetTester tester) async {
//     await arrangeMarkerLocations();
//     await tester.pumpWidget(createWidgetUnderTest());

//     expect(
//         find.byWidgetPredicate((widget) => widget is Marker), findsOneWidget);

//     await tester.pumpAndSettle();
//   });
// }
