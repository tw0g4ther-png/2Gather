import '../../freezed/userAction/userAction.dart';
import '../../freezed/userState/userState.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

UserAction getStateOfContactRow(Iterable<DataSnapshot> snap, String myUid) {
  if (snap.isEmpty) return UserAction.normal;

  Map<UserAction, List<ActionUser>> actionByUsers = getUsersAction(snap, myUid);

  if (actionByUsers.isEmpty) return UserAction.normal;
  debugPrint('No');
  return actionByUsers.values.first.first.action;
}

UserState? getStateOfUser(Iterable<DataSnapshot> snap, String myUid) {
  if (snap.isEmpty) {
    return null;
  } else {
    List<UserState> list = getUsersState(snap, myUid);

    return list.isNotEmpty ? list.first : null;
  }
}

List<UserState> getUsersState(Iterable<DataSnapshot> snap, String myUid) {
  List<UserState> states = [];
  for (var val in snap) {
    if (val.child("state").exists) {
      var element = val.child("state");
      if (DateTime.parse(element.child("lastUpdate").value as String)
              .difference(DateTime.now()) <
          const Duration(minutes: 2)) {
        if (val.key != myUid) {
          states.add(UserState(
              idUser: val.key!,
              state: element.child("state").value == "online"
                  ? StateOfUser.online
                  : StateOfUser.offline,
              lastUpdate:
                  DateTime.parse(element.child("lastUpdate").value as String)));
        }
      } else {
        if (val.key != myUid) {
          states.add(UserState(
              idUser: val.key!,
              state: StateOfUser.offline,
              lastUpdate:
                  DateTime.parse(element.child("lastUpdate").value as String)));
        }
      }
    }
  }
  return states;
}

Map<UserAction, List<ActionUser>> getUsersAction(
    Iterable<DataSnapshot> snap, String myUid) {
  Map<UserAction, List<ActionUser>> actionByUsers = {};
  for (var val in snap) {
    if (val.child("action").exists) {
      var element = val.child("action");
      if (DateTime.parse(element.child("dateTime").value as String)
              .difference(DateTime.now()) <
          const Duration(minutes: 113)) {
        if (element.child("action").value == "typing" && val.key != myUid) {
          actionByUsers[UserAction.typing] = [
            ...(actionByUsers[UserAction.typing] ?? []),
            ActionUser(
                action: UserAction.typing,
                idUser: val.key!,
                dateTime:
                    DateTime.parse(element.child("dateTime").value as String))
          ];
        } else if (element.child("action").value == "recording" &&
            val.key != myUid) {
          actionByUsers[UserAction.recording] = [
            ...(actionByUsers[UserAction.typing] ?? []),
            ActionUser(
                action: UserAction.recording,
                idUser: val.key!,
                dateTime:
                    DateTime.parse(element.child("dateTime").value as String))
          ];
        }
      }
    }
  }
  return actionByUsers;
}
