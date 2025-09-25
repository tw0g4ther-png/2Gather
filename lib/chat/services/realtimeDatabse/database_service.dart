import '../../freezed/userAction/userAction.dart';
import '../../freezed/userState/userState.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseDatabase _databseInstance = FirebaseDatabase.instance;

abstract class RealtimeDatabaseQuery {
  static void updateStatus({
    required String idSalon,
    required ActionUser actionUser,
  }) async {
    _databseInstance
        .ref()
        .child("Salons/$idSalon/${actionUser.idUser}/action")
        .set(actionUser.toJson());
  }

  static void updateOnlineOfflineStatus({
    required String idSalon,
    required UserState userState,
  }) async {
    _databseInstance
        .ref()
        .child("Salons/$idSalon/${userState.idUser}/state")
        .set(userState.toJson());
  }

  static Stream<DatabaseEvent> streamSalon({required String idSalon}) {
    return _databseInstance.ref().child("Salons/$idSalon").onValue;
  }
}
