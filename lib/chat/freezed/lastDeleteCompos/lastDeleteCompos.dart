import 'package:freezed_annotation/freezed_annotation.dart';
part 'lastDeleteCompos.freezed.dart';
part 'lastDeleteCompos.g.dart';

@freezed
class LastDeleteCompos with _$LastDeleteCompos {
  const factory LastDeleteCompos({
    required String idUser,
    required String idSalon,
    required DateTime lastDateDelete,
  }) = _LastDeleteCompos;
  factory LastDeleteCompos.fromJson(Map<String, dynamic> json) => _$LastDeleteComposFromJson(json);
}
