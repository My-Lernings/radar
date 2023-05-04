import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectiondModal {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;

  DirectiondModal({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory DirectiondModal.fromMap(Map<String, dynamic> map) {
    if ((map['routes'] as List).isEmpty) return DirectiondModal.empty();

    final data = Map<String, dynamic>.from(map['routes'][0]);

    final northEast = data['bounds']['northeast'];
    final southWest = data['bounds']['southwest'];

    final bounds = LatLngBounds(
      northeast: LatLng(northEast['lat'], northEast['lng']),
      southwest: LatLng(southWest['lat'], southWest['lng']),
    );

    String totalDistance = '';
    String totalDuration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      totalDistance = leg['distance']['text'];
      totalDuration = leg['duration']['text'];
    }
// legs[0].steps
//routes[0].legs[0].steps[0].polyline.points

    // final steps = (data['legs'][0]['steps'] as List)
    //     .map((step) => step['polyline']['points'])
    //     .toList();

    final points = data['overview_polyline']['points'];

    final polylinePoints = PolylinePoints().decodePolyline(points);

    return DirectiondModal(
      bounds: bounds,
      polylinePoints: polylinePoints,
      totalDistance: totalDistance,
      totalDuration: totalDuration,
    );
  }

  static DirectiondModal empty() {
    return DirectiondModal(
      bounds: LatLngBounds(
        northeast: LatLng(0, 0),
        southwest: LatLng(0, 0),
      ),
      polylinePoints: [],
      totalDistance: '',
      totalDuration: '',
    );
  }
}
