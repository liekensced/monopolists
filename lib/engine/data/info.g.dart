// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InfoAdapter extends TypeAdapter<Info> {
  @override
  final typeId = 7;

  @override
  Info read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Info(
      title: fields[0] as String,
      leading: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Info obj) {
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

Info _$InfoFromJson(Map<String, dynamic> json) {
  return Info(
    title: json['title'] as String,
    leading: json['leading'] as String,
  );
}

Map<String, dynamic> _$InfoToJson(Info instance) => <String, dynamic>{
      'title': instance.title,
      'leading': instance.leading,
    };
