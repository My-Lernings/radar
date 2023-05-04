// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationAdapter extends TypeAdapter<LocationModal> {
  @override
  final int typeId = 1;

  @override
  LocationModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationModal(
      dbId: fields[0] as String,
      district: fields[1] as String,
      locationName: fields[2] as String,
      latitude: fields[3] as double,
      longitude: fields[4] as double,
      systemType: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocationModal obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.dbId)
      ..writeByte(1)
      ..write(obj.district)
      ..writeByte(2)
      ..write(obj.locationName)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude)
      ..writeByte(5)
      ..write(obj.systemType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
