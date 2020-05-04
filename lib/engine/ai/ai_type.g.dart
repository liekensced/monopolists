// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AITypeAdapter extends TypeAdapter<AIType> {
  @override
  final typeId = 15;

  @override
  AIType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AIType.player;
      case 1:
        return AIType.normal;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, AIType obj) {
    switch (obj) {
      case AIType.player:
        writer.writeByte(0);
        break;
      case AIType.normal:
        writer.writeByte(1);
        break;
    }
  }
}
