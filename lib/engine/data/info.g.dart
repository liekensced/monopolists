// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UpdateInfoAdapter extends TypeAdapter<UpdateInfo> {
  @override
  final typeId = 7;

  @override
  UpdateInfo read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UpdateInfo(
      title: fields[0] as String,
      leading: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UpdateInfo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.leading);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateInfo _$UpdateInfoFromJson(Map<String, dynamic> json) {
  return UpdateInfo(
    title: json['title'] as String,
    leading: json['leading'] as String,
  );
}

Map<String, dynamic> _$UpdateInfoToJson(UpdateInfo instance) =>
    <String, dynamic>{
      'title': instance.title,
      'leading': instance.leading,
    };
