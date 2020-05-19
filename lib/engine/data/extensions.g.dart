// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extensions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExtensionAdapter extends TypeAdapter<Extension> {
  @override
  final typeId = 6;

  @override
  Extension read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Extension.bank;
      case 1:
        return Extension.transportation;
      case 2:
        return Extension.legislation;
      case 3:
        return Extension.stock;
      case 4:
        return Extension.drainTheLake;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, Extension obj) {
    switch (obj) {
      case Extension.bank:
        writer.writeByte(0);
        break;
      case Extension.transportation:
        writer.writeByte(1);
        break;
      case Extension.legislation:
        writer.writeByte(2);
        break;
      case Extension.stock:
        writer.writeByte(3);
        break;
      case Extension.drainTheLake:
        writer.writeByte(4);
        break;
    }
  }
}
