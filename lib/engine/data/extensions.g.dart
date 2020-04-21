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
        return Extension.bank2;
      case 2:
        return Extension.jurisdiction;
      case 3:
        return Extension.stock;
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
      case Extension.bank2:
        writer.writeByte(1);
        break;
      case Extension.jurisdiction:
        writer.writeByte(2);
        break;
      case Extension.stock:
        writer.writeByte(3);
        break;
    }
  }
}
