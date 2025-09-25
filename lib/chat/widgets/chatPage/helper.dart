import 'package:intl/intl.dart';

String stickerDate(DateTime time) {
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  final DateTime now = DateTime.now();

  if ([0, 1, 2].contains(now.difference(time).inDays)) {
    if (now.day == time.day) {
      return "Aujourd'hui";
    }
    else if (now.day == time.day + 1) {
      return "Hier";
    }
    else if (now.day == time.day + 2) {
      return "Avant-hier";
    }
    else {
      return dateFormat.format(time);
    }
  }
  return dateFormat.format(time);
}

String lastOnline(DateTime time) {
  final DateTime now = DateTime.now();

  if ([0, 1, 2].contains(now.difference(time).inDays)) {
    if (now.day == time.day) {
      return " Vu aujourd'hui à ${time.hour}:${time.minute}";
    } else if (now.day == time.day + 1) {
      return "Vu Hier  à ${time.hour}:${time.minute}";
    }
    else if (now.day == time.day + 2) {
      return " Vu Avant-hier  à ${time.hour}:${time.minute}";
    }
    else {
      return "Vu le ${time.day}/${time.month}";
    }
  }
  return "";
}
