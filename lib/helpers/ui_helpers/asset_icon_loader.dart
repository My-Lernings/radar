// create a new class named AssetIconLoader
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AssetIconLoader {
  Future<BitmapDescriptor> getMarkerIcon(String assetName) async {
    final Uint8List markerIconPvds =
        await getBytesFromAsset('assets/images/$assetName.png');

    final BitmapDescriptor cameraIcon =
        BitmapDescriptor.fromBytes(markerIconPvds);
    return cameraIcon;
  }

  Future<Uint8List> getBytesFromAsset(
    String path,
  ) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: 60);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
