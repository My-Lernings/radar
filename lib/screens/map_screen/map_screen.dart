import 'package:cron/cron.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locale/controllers/current_location_controller.dart';
import 'package:locale/controllers/dirctions_controller.dart';
import 'package:locale/controllers/marker_locations_controller.dart';
import 'package:locale/globals/string_constants.dart';
import 'package:locale/modals/directions_modal.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'bottom_panel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final cron = Cron();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Trace homeScreenRenderTrace;
  double fabPosition = 180;
  bool isDriveMod = false;
  final TextEditingController _destinationTextController =
      TextEditingController();
  @override
  void initState() {
    homeScreenRenderTrace =
        FirebasePerformance.instance.newTrace('homeScreenRender');
    homeScreenRenderTrace.start();
    Get.find<CurrentLocationController>().getCurrentLocation();
    if (Get.find<CurrentLocationController>().currentPosition != null) {
      Get.find<CurrentLocationController>()
          .localBasedCameraListCalculatorOfOneKm(
              Get.find<CurrentLocationController>().currentPosition!);
    }
    _animationController = AnimationController(vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    homeScreenRenderTrace.start();
    super.dispose();
  }

  double maxHeight = 100;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return MediaQuery(
      data: const MediaQueryData(),
      child: GetBuilder<CurrentLocationController>(
          builder: (currentLocationController) {
        return GetBuilder<MarkersController>(
          builder: (MarkersController markerLocationsController) {
            return GetBuilder(
              builder: (DirectionsController directionsController) => Scaffold(
                key: _scaffoldKey,
                body: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: height * 0.15),
                      child: GoogleMap(
                        myLocationEnabled: true,
                        zoomControlsEnabled: true,
                        circles: currentLocationController.currentCircle,
                        myLocationButtonEnabled: false,
                        markers:
                            markerLocationsController.markers.values.toSet(),
                        polylines: {
                          if (directionsController.directions != null)
                            Polyline(
                                polylineId: PolylineId('poly'),
                                visible: true,
                                color: Colors.red,
                                width: 5,
                                points: directionsController
                                    .directions!.polylinePoints
                                    .map((e) => LatLng(e.latitude, e.longitude))
                                    .toList())
                        },
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(0, 0),
                          zoom: 1,
                        ),
                        onMapCreated: (GoogleMapController controller) async {
                          currentLocationController.getController
                              .complete(controller);
                        },
                        onLongPress: (LatLng latLng) {
                          _onLongPressAddMarker(latLng);
                        },
                        onCameraMove: (CameraPosition cameraPosition) {
                          markerLocationsController.currentZoom =
                              cameraPosition.zoom;
                        },
                      ),
                    ),
                    Positioned(
                        top: 40,
                        left: 10,
                        right: 10,
                        child: TopDroppableContainer(
                            title: markerLocationsController.markers.length
                                    .toString() +
                                ':')),
                    Positioned(
                        right: 20,
                        bottom: fabPosition,
                        child: FloatingActionButton(
                          onPressed: () async {
                            if (!isDriveMod) {
                              await currentLocationController
                                  .subscribeUnsubscribeToLocationUpdates(true);
                            } else {
                              await currentLocationController
                                  .subscribeUnsubscribeToLocationUpdates(false);
                            }
                            setState(() {
                              isDriveMod = !isDriveMod;
                            });
                          },
                          child: Icon(isDriveMod
                              ? Icons.satellite_alt
                              : Icons.drive_eta),
                        )),
                    Positioned.fill(
                        bottom: 0,
                        child: NotificationListener<
                            DraggableScrollableNotification>(
                          onNotification: (notification) {
                            return true;
                          },
                          child: DraggableScrollableSheet(
                            expand: false,
                            maxChildSize: .6,
                            minChildSize: .2,
                            initialChildSize: .2,
                            builder: (ctx, scrollController) {
                              return Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    const Text('Where are you going'),
                                    Container(
                                      child: TextField(
                                        controller: _destinationTextController,
                                      ),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.find<DirectionsController>()
                                              .getDirections();
                                        },
                                        child: const Text('Go')),
                                    Expanded(
                                      child: ListView.builder(
                                          controller: scrollController,
                                          itemCount: 5,
                                          itemBuilder: (_, i) {
                                            return ListTile(
                                              title: Text('item $i'),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ))
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  _onLongPressAddMarker(LatLng latLng) async {
    const markerId = MarkerId(StringConstants.DESTINATION);
    final marker = Marker(
      markerId: markerId,
      position: latLng,
      infoWindow: const InfoWindow(
        title: 'Destination',
        snippet: 'Destination',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    Get.find<MarkersController>()
        .addOrUpdateMarkerWithId(marker: marker, markerId: markerId);
    Get.find<DirectionsController>().destination = latLng;
    Get.find<DirectionsController>().setDirections = null;
    final adress =
        await Get.find<DirectionsController>().getAddressFromLatLng(latLng);
    final addressComponents = adress.addressComponents;
    addressComponents.removeAt(0);

    _destinationTextController.text =
        addressComponents.map((e) => e.shortName).join(', ');
  }
}

class TopDroppableContainer extends StatefulWidget {
  const TopDroppableContainer({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;
  @override
  State<TopDroppableContainer> createState() => _TopDroppableContainerState();
}

class _TopDroppableContainerState extends State<TopDroppableContainer> {
  bool _opened = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: _opened ? 200 : 55,
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(30)),
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(widget.title)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _opened = !_opened;
                    });
                  },
                  icon: Icon(_opened ? Icons.minimize : Icons.add))
            ],
          ),
        ],
      ),
    );
  }
}
