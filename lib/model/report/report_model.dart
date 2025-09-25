import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

@freezed
class ReportModel with _$ReportModel {
  const factory ReportModel({
    String? tag,
    String? desc,
    int? value,
    Duration? duration,
  }) = _ReportModel;

  factory ReportModel.fromJson(Map<String, dynamic> json) => _$ReportModelFromJson(json);
}
