import '../enum/enumMessage.dart';
import '../freezed/message/messageModel.dart';
import 'me_notifier.dart';
import 'salon_river.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BottomBarState { normal, locked }

enum DeleteMessagesType { onlyMe, all }

class SalonMessagesNotifier with ChangeNotifier {
  //----------------------------------------------------Tapped-message-----------------------------------------------------------------/
  final List<String> _listMessageSelectedMessage = [];
  List<String> get listMessageSelectedMessage => _listMessageSelectedMessage;
  void tapOnMessage(String messageId) {
    if (_listMessageSelectedMessage.contains(messageId)) {
      _listMessageSelectedMessage.remove(messageId);
    } else {
      _listMessageSelectedMessage.add(messageId);
    }
    notifyListeners();
  }

  void deleteSelectedMessage(DeleteMessagesType type, String id) {
    switch (type) {
      case DeleteMessagesType.all:
        for (var msgId in _listMessageSelectedMessage) {
          FirebaseFirestore.instance
              .collection("Salons")
              .doc(providerRef.read(messageFirestoreRiver).idSalon)
              .collection("Messages")
              .doc(msgId)
              .delete();
        }
        break;
      case DeleteMessagesType.onlyMe:
        for (var msgId in _listMessageSelectedMessage) {
          FirebaseFirestore.instance
              .collection("Salons")
              .doc(providerRef.read(messageFirestoreRiver).idSalon)
              .collection("Messages")
              .doc(msgId)
              .update({
                "userDeleteMessage": FieldValue.arrayUnion([id]),
              });
        }

        break;
    }
    _listMessageSelectedMessage.clear();
    notifyListeners();
  }
  //-------------------------------------------------------------------------------------------------------------------------------------/

  Map<String, MessageModel> _mapMessageToShow = {};
  Map<String, MessageModel> get mapMessageToShow => _mapMessageToShow;
  Ref providerRef;
  SalonMessagesNotifier({required this.providerRef});
  BottomBarState _bottomBarState = BottomBarState.normal;
  BottomBarState get bottomBarState => _bottomBarState;
  MessageModel? _repliedMessage;
  MessageModel? get repliedMessage => _repliedMessage;
  void setRepliedMessage(MessageModel? messageModel) {
    _repliedMessage = messageModel;
    notifyListeners();
  }

  void setBottomBarState(BottomBarState bottomBarState) {
    _bottomBarState = bottomBarState;
    notifyListeners();
  }

  void init() {
    _mapMessageToShow = {};
    notifyListeners();
  }

  /// Nettoie complètement toutes les données du notifier
  void clear() {
    debugPrint("[SalonMessagesNotifier] Début du nettoyage...");

    _mapMessageToShow.clear();
    _listMessageSelectedMessage.clear();
    _bottomBarState = BottomBarState.normal;
    _repliedMessage = null;

    debugPrint(
      "[SalonMessagesNotifier] ✓ Toutes les données ont été nettoyées",
    );
    notifyListeners();
  }

  void addMessage({required MessageModel messageModel}) {
    switch (messageModel.type) {
      case MessageContentType.textMessage:
        addTextMessage(messageModel: messageModel);
        break;
      case MessageContentType.videoMessage:
        addVideoMessage(messageModel: messageModel);
        break;
      case MessageContentType.imageMessage:
        addImageMessage(messageModel: messageModel);
        break;
      case MessageContentType.lockDemandMessage:
        addLockedMessage(messageModel: messageModel);
        break;
    }
    if (messageModel.sender != providerRef.read(meModelChangeNotifier).myUid &&
        !(messageModel.seenBy?.contains(
              providerRef.read(meModelChangeNotifier).myUid,
            ) ??
            false)) {
      FirebaseFirestore.instance
          .collection("Salons")
          .doc(providerRef.read(messageFirestoreRiver).idSalon!)
          .collection("Messages")
          .doc(messageModel.id!)
          .update({
            "seenBy": FieldValue.arrayUnion([
              providerRef.read(meModelChangeNotifier).myUid,
            ]),
          });
    }
  }

  void deleteMessage({required String messageModelID}) {
    _mapMessageToShow.remove(messageModelID);
    notifyListeners();
  }

  void addTextMessage({required MessageModel messageModel}) {
    if (messageModel.id != null) {
      _mapMessageToShow[messageModel.id!] = messageModel;
      notifyListeners();
    }
  }

  void addLockedMessage({required MessageModel messageModel}) {
    if (messageModel.id != null) {
      _mapMessageToShow[messageModel.id!] = messageModel;
      notifyListeners();
    }
  }

  void addImageMessage({required MessageModel messageModel}) {
    if (messageModel.id != null) {
      if (!_mapMessageToShow.containsKey(messageModel.id)) {
        _mapMessageToShow[messageModel.id!] = messageModel;
        notifyListeners();
      } else {
        if (_mapMessageToShow[messageModel.id!]?.temporaryPath != null) {
          MessageModel msg = messageModel.copyWith(
            temporaryPath: _mapMessageToShow[messageModel.id!]!.temporaryPath!,
          );
          _mapMessageToShow[messageModel.id!] = msg;
          notifyListeners();
        }
      }
    }
  }

  void addAudioMessage({required MessageModel messageModel}) {
    if (messageModel.id != null) {
      if (!_mapMessageToShow.containsKey(messageModel.id)) {
        _mapMessageToShow[messageModel.id!] = messageModel;
        notifyListeners();
      } else {
        MessageModel msg = messageModel.copyWith(
          relative_path: _mapMessageToShow[messageModel.id!]!.relative_path!,
        );
        _mapMessageToShow[messageModel.id!] = msg;
        notifyListeners();
      }
    }
  }

  void addVideoMessage({required MessageModel messageModel}) {
    if (messageModel.id != null) {
      if (!_mapMessageToShow.containsKey(messageModel.id)) {
        _mapMessageToShow[messageModel.id!] = messageModel;
        notifyListeners();
      } else {
        if (_mapMessageToShow[messageModel.id!]?.temporaryPath != null) {
          MessageModel msg = messageModel.copyWith(
            temporaryPath: _mapMessageToShow[messageModel.id!]!.temporaryPath!,
          );
          _mapMessageToShow[messageModel.id!] = msg;
          notifyListeners();
        }
      }
    }
  }

  List<MessageModel> getMessages() {
    List<MessageModel> list = _mapMessageToShow.values
        .where(
          (element) =>
              !((element.userDeleteMessage?.contains(
                    providerRef.read(meModelChangeNotifier).myUid,
                  ) ??
                  false)) &&
              element.createdAt.compareTo(
                    providerRef
                            .read(messageFirestoreRiver)
                            .lastDeleteCompos
                            ?.lastDateDelete ??
                        DateTime(1970),
                  ) >
                  0,
        )
        .toList();

    list.sort(((a, b) {
      if (a.timeStamp == null) return -1;
      if (b.timeStamp == null) return 1;

      return (b.timeStamp!).compareTo(a.timeStamp!);
    }));
    return list;
  }
}
