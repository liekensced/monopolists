import 'package:hive/hive.dart';
import 'package:plutopoly/helpers/progress_helper.dart';
import 'main_bloc.dart';

class DailyBloc {
  static DateTime getDayDate(date) {
    if (date is String) {
      DateTime tmp = DateTime?.tryParse(date ?? "") ?? DateTime.now();
      return DateTime(tmp.year, tmp.month, tmp.day);
    } else if (date is DateTime) {
      return DateTime(date.year, date.month, date.day);
    }
    print("?? No string or datetime");
    return DateTime.now();
  }

  static void checkNewDay() {
    Box box = Hive.box(MainBloc.METABOX);

    DateTime now = DateTime.now();
    final today = getDayDate(now);

    DateTime lastOpenedDateDay = getDayDate(box.get("lastDate"));

    // Ran on a new day

    if (lastOpenedDateDay != today) {
      if (MainBloc.isPro) {
        int proDays = box.get("intProDays", defaultValue: -1) + 1;
        if (proDays >= 7) {
          box.put("intAdDays", box.get("intAdDays", defaultValue: -1) + 1);
          proDays = 0;
        }
        box.put("intProDays", proDays);
      } else {
        box.put("intAdDays", box.get("intAdDays", defaultValue: -1) + 1);
      }
      Box statBox = Hive.box(MainBloc.STATBOX);
      Map stat = statBox.get("expStat", defaultValue: {});
      stat.putIfAbsent(today.toString(), () => ProgressHelper.exp);
      statBox.put("expStat", stat);
      box.put("lastDate", today.toString());
    }
  }
}
