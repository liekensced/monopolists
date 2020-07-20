import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:plutopoly/store/preset.dart';

class FileHelper {
  static Future<String> get presetsDir async {
    String rootPath = (await getExternalStorageDirectory()).path;
    String path = rootPath + "/presets/";
    await Directory(path).create(recursive: true);
    return path;
  }

  static Future<List<Preset>> getPresets() async {
    String filePath = await presetsDir;
    List<Preset> presets = [];
    Directory(filePath).listSync(recursive: false).forEach((fileEntity) {
      try {
        if (fileEntity is File) {
          String content = fileEntity.readAsStringSync();
          try {
            Preset preset = Preset.fromJson(jsonDecode(content));
            preset.place = fileEntity.path;
            presets.add(preset);
          } catch (e) {
            print("parsing file failed");
            print(e);
          }
        }
      } catch (e) {
        print("Failed to open file");
      }
    });
    return presets;
  }

  static Future<String> savePreset(Preset preset) async {
    String filePath = (await presetsDir) + preset.projectName + '.json';
    File file = File(filePath);
    if (!(await file.exists())) {
      file.create();
    }
    preset.dataCache = preset.data;
    file.writeAsString(jsonEncode(preset.toJson()), mode: FileMode.write);
    print(filePath);
    return filePath;
  }
}
