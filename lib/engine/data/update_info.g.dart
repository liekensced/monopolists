// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_info.dart';

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
      subtitle: fields[2] as String,
      trailing: fields[3] as String,
      show: fields[4] as bool,
      color: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UpdateInfo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.leading)
      ..writeByte(2)
      ..write(obj.subtitle)
      ..writeByte(3)
      ..write(obj.trailing)
      ..writeByte(4)
      ..write(obj.show)
      ..writeByte(5)
      ..write(obj.color);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateInfo _$UpdateInfoFromJson(Map json) {
  return UpdateInfo(
    title: json['title'] as String,
    leading: json['leading'] as String,
    subtitle: json['subtitle'] as String,
    trailing: json['trailing'] as String,
    show: json['show'] as bool,
    color: json['color'] as int,
  );
}

Map<String, dynamic> _$UpdateInfoToJson(UpdateInfo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('leading', instance.leading);
  writeNotNull('subtitle', instance.subtitle);
  writeNotNull('trailing', instance.trailing);
  writeNotNull('show', instance.show);
  writeNotNull('color', instance.color);
  return val;
}
