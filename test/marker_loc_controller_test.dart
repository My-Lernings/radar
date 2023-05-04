// import 'package:flutter_test/flutter_test.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:locale/controllers/current_location_controller.dart';
// import 'package:locale/controllers/marker_locations_controller.dart';
// import 'package:mocktail/mocktail.dart';

// class MockMarkerLocationsController extends Mock
//     implements MarkerLocationsController {
//   @override
//   Future<void> getMarkerLocations() async {
//     return Future.value([
//       const Marker(
//           markerId: MarkerId('markerId1'),
//           position: LatLng(11.589878, 75.725379)),
//       Marker(
//           markerId: MarkerId('markerId2'),
//           position: LatLng(11.549878, 75.729379)),
//       Marker(
//           markerId: MarkerId('markerId3'),
//           position: LatLng(11.589878, 75.725379)),
//     ]);
//   }
// }

// void main() {
//   late MockMarkerLocationsController sut;

//   setUp(() {
//     sut = MockMarkerLocationsController();
//   });

//   group('marker list class', () {
//     test('get camera list', () async {
//       when(() => sut.getNearestCameras(lat: '11.589878', long: '75.725379'))
//           .thenAnswer((value) async {
//         print(value);
//         return Future.value([]);
//       });
//       await sut.getNearestCameras(lat: '11.589878', long: '75.725379');
//       verify(() => sut
//           .getNearestCameras(lat: '11.589878', long: '75.725379')
//           .then((value) => print(value))).called(1);
//     });

//     test('get last sync location', () {
//       when(() => sut.getLastSyncLocation()).thenAnswer((value) async {
//         return Future.value(const LatLng(11.3434, 34.7343425379));
//       });
//       sut.getLastSyncLocation();
//       verify(() => sut.getLastSyncLocation()).called(1);
//     });
//   });
// }
