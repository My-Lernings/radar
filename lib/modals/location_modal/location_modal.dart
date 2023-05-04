// To parse this JSON data, do
//
//     final location = locationFromJson(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
part 'location_modal.g.dart';

LocationModal locationFromJson(String str) =>
    LocationModal.fromJson(json.decode(str));

String locationToJson(LocationModal data) => json.encode(data.toJson());

@HiveType(typeId: 1)
class LocationModal {
  LocationModal({
    required this.dbId,
    required this.district,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.systemType,
  });
  @HiveField(0)
  String dbId;
  @HiveField(1)
  String district;
  @HiveField(2)
  String locationName;
  @HiveField(3)
  double latitude;
  @HiveField(4)
  double longitude;
  @HiveField(5)
  String systemType;

  factory LocationModal.fromJson(Map<String, dynamic> json) => LocationModal(
        dbId: json["db_id"],
        district: json["district"],
        locationName: json["location_name"],
        latitude: double.parse('${json["latitude"]}'),
        longitude: double.parse('${json["longitude"]}'),
        systemType: json["system_type"],
      );

  Map<String, dynamic> toJson() => {
        "db_id": dbId,
        "district": district,
        "location_name": locationName,
        "latitude": latitude,
        "longitude": longitude,
        "system_type": systemType,
      };
}


// double.parse('${value['latitude']}'),
//             double.parse('${value['longitude']}')