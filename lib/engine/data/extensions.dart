import 'package:hive/hive.dart';
part 'extensions.g.dart';

@HiveType(typeId: 6)
enum Extension {
  @HiveField(0)
  bank,
  @HiveField(1)
  bank2,
  @HiveField(2)
  jurisdiction
}

//This is an example extension:
/* 
  class GameExtension {
   static bool get enabled =>
       Game.data.extensions.contains(Extension.gameExtension);
   static List<Info> getInfo() {
     return [];
   }
   static Widget icon(double size) {
     return Container(
       height: size,
       width: size,
     );
   }
   static get available => false;
  }
*/
