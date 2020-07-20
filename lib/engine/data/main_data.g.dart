// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameDataAdapter extends TypeAdapter<GameData> {
  @override
  final typeId = 0;

  @override
  GameData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameData()
      ..running = fields[0] as bool
      ..players = (fields[1] as List)?.cast<Player>()
      ..currentPlayer = fields[2] as int
      ..turn = fields[3] as int
      ..currentDices = (fields[4] as List)?.cast<int>()
      ..doublesThrown = fields[5] as int
      ..pot = fields[6] as double
      ..gmap = (fields[7] as List)?.cast<Tile>()
      ..settings = fields[8] as Settings
      ..extensions = (fields[9] as List)?.cast<Extension>()
      ..ui = fields[10] as UIActionsData
      ..rentPayed = fields[11] as bool
      ..findingsIndex = fields[12] as int
      ..eventIndex = fields[13] as int
      ..mapConfiguration = fields[14] as String
      ..dealData = fields[15] as DealData
      ..bankData = fields[16] as BankData
      ..version = fields[17] as String
      ..lostPlayers = (fields[18] as List)?.cast<Player>()
      ..bot = fields[19] as bool
      ..transported = fields[20] as bool
      ..preset = fields[21] as String
      ..currency = fields[22] as String
      ..placeCurrencyInFront = fields[23] as bool
      ..levelId = fields[25] as String
      ..tableColor = fields[26] as int;
  }

  @override
  void write(BinaryWriter writer, GameData obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.running)
      ..writeByte(1)
      ..write(obj.players)
      ..writeByte(2)
      ..write(obj.currentPlayer)
      ..writeByte(3)
      ..write(obj.turn)
      ..writeByte(4)
      ..write(obj.currentDices)
      ..writeByte(5)
      ..write(obj.doublesThrown)
      ..writeByte(6)
      ..write(obj.pot)
      ..writeByte(7)
      ..write(obj.gmap)
      ..writeByte(8)
      ..write(obj.settings)
      ..writeByte(9)
      ..write(obj.extensions)
      ..writeByte(10)
      ..write(obj.ui)
      ..writeByte(11)
      ..write(obj.rentPayed)
      ..writeByte(12)
      ..write(obj.findingsIndex)
      ..writeByte(13)
      ..write(obj.eventIndex)
      ..writeByte(14)
      ..write(obj.mapConfiguration)
      ..writeByte(15)
      ..write(obj.dealData)
      ..writeByte(16)
      ..write(obj.bankData)
      ..writeByte(17)
      ..write(obj.version)
      ..writeByte(18)
      ..write(obj.lostPlayers)
      ..writeByte(19)
      ..write(obj.bot)
      ..writeByte(20)
      ..write(obj.transported)
      ..writeByte(21)
      ..write(obj.preset)
      ..writeByte(22)
      ..write(obj.currency)
      ..writeByte(23)
      ..write(obj.placeCurrencyInFront)
      ..writeByte(25)
      ..write(obj.levelId)
      ..writeByte(26)
      ..write(obj.tableColor);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameData _$GameDataFromJson(Map json) {
  return GameData()
    ..running = json['running'] as bool
    ..players = (json['players'] as List)
        ?.map((e) => e == null ? null : Player.fromJson(e as Map))
        ?.toList()
    ..currentPlayer = json['currentPlayer'] as int
    ..turn = json['turn'] as int
    ..currentDices =
        (json['currentDices'] as List)?.map((e) => e as int)?.toList()
    ..doublesThrown = json['doublesThrown'] as int
    ..pot = (json['pot'] as num)?.toDouble()
    ..gmap = (json['gmap'] as List)
        ?.map((e) => e == null ? null : Tile.fromJson(e as Map))
        ?.toList()
    ..settings = json['settings'] == null
        ? null
        : Settings.fromJson(json['settings'] as Map)
    ..extensions = (json['extensions'] as List)
        ?.map((e) => _$enumDecodeNullable(_$ExtensionEnumMap, e))
        ?.toList()
    ..ui = json['ui'] == null ? null : UIActionsData.fromJson(json['ui'] as Map)
    ..rentPayed = json['rentPayed'] as bool
    ..findingsIndex = json['findingsIndex'] as int
    ..eventIndex = json['eventIndex'] as int
    ..mapConfiguration = json['mapConfiguration'] as String
    ..dealData = json['dealData'] == null
        ? null
        : DealData.fromJson(json['dealData'] as Map)
    ..bankData = json['bankData'] == null
        ? null
        : BankData.fromJson(json['bankData'] as Map)
    ..version = json['version'] as String
    ..lostPlayers = (json['lostPlayers'] as List)
        ?.map((e) => e == null ? null : Player.fromJson(e as Map))
        ?.toList()
    ..bot = json['bot'] as bool
    ..transported = json['transported'] as bool ?? false
    ..preset = json['preset'] as String
    ..currency = json['currency'] as String
    ..placeCurrencyInFront = json['placeCurrencyInFront'] as bool
    ..levelId = json['levelId'] as String
    ..tableColor = json['tableColor'] as int;
}

Map<String, dynamic> _$GameDataToJson(GameData instance) {
  final val = <String, dynamic>{
    'running': instance.running,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('players', instance.players?.map((e) => e?.toJson())?.toList());
  writeNotNull('currentPlayer', instance.currentPlayer);
  writeNotNull('turn', instance.turn);
  writeNotNull('currentDices', instance.currentDices);
  writeNotNull('doublesThrown', instance.doublesThrown);
  writeNotNull('pot', instance.pot);
  writeNotNull('gmap', instance.gmap?.map((e) => e?.toJson())?.toList());
  writeNotNull('settings', instance.settings?.toJson());
  writeNotNull('extensions',
      instance.extensions?.map((e) => _$ExtensionEnumMap[e])?.toList());
  writeNotNull('ui', instance.ui?.toJson());
  writeNotNull('rentPayed', instance.rentPayed);
  writeNotNull('findingsIndex', instance.findingsIndex);
  writeNotNull('eventIndex', instance.eventIndex);
  writeNotNull('mapConfiguration', instance.mapConfiguration);
  val['dealData'] = instance.dealData?.toJson();
  writeNotNull('bankData', instance.bankData?.toJson());
  writeNotNull('version', instance.version);
  writeNotNull(
      'lostPlayers', instance.lostPlayers?.map((e) => e?.toJson())?.toList());
  writeNotNull('bot', instance.bot);
  writeNotNull('transported', instance.transported);
  writeNotNull('preset', instance.preset);
  writeNotNull('currency', instance.currency);
  writeNotNull('placeCurrencyInFront', instance.placeCurrencyInFront);
  writeNotNull('levelId', instance.levelId);
  writeNotNull('tableColor', instance.tableColor);
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ExtensionEnumMap = {
  Extension.bank: 'bank',
  Extension.transportation: 'transportation',
  Extension.legislation: 'legislation',
  Extension.stock: 'stock',
  Extension.drainTheLake: 'drainTheLake',
};
