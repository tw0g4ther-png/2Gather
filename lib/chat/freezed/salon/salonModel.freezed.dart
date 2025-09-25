// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'salonModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SalonModel _$SalonModelFromJson(Map<String, dynamic> json) {
  return _SalonModel.fromJson(json);
}

/// @nodoc
mixin _$SalonModel {
  String? get nom => throw _privateConstructorUsedError;
  String? get lastMessageId => throw _privateConstructorUsedError;
  MessageModel? get lastMessageContent => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  String? get lastLockedDemand => throw _privateConstructorUsedError;
  String? get salonPicture => throw _privateConstructorUsedError;
  LockState? get lock => throw _privateConstructorUsedError;
  bool? get allowAllUserToUpdateInformation =>
      throw _privateConstructorUsedError;
  String? get adminId => throw _privateConstructorUsedError;
  List<String>? get bloquedUser => throw _privateConstructorUsedError;
  SalonType get type => throw _privateConstructorUsedError;
  MessageContentType? get lastMessageType => throw _privateConstructorUsedError;
  List<String?> get users => throw _privateConstructorUsedError;

  /// Serializes this SalonModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalonModelCopyWith<SalonModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalonModelCopyWith<$Res> {
  factory $SalonModelCopyWith(
    SalonModel value,
    $Res Function(SalonModel) then,
  ) = _$SalonModelCopyWithImpl<$Res, SalonModel>;
  @useResult
  $Res call({
    String? nom,
    String? lastMessageId,
    MessageModel? lastMessageContent,
    String? id,
    String? lastLockedDemand,
    String? salonPicture,
    LockState? lock,
    bool? allowAllUserToUpdateInformation,
    String? adminId,
    List<String>? bloquedUser,
    SalonType type,
    MessageContentType? lastMessageType,
    List<String?> users,
  });

  $MessageModelCopyWith<$Res>? get lastMessageContent;
}

/// @nodoc
class _$SalonModelCopyWithImpl<$Res, $Val extends SalonModel>
    implements $SalonModelCopyWith<$Res> {
  _$SalonModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nom = freezed,
    Object? lastMessageId = freezed,
    Object? lastMessageContent = freezed,
    Object? id = freezed,
    Object? lastLockedDemand = freezed,
    Object? salonPicture = freezed,
    Object? lock = freezed,
    Object? allowAllUserToUpdateInformation = freezed,
    Object? adminId = freezed,
    Object? bloquedUser = freezed,
    Object? type = null,
    Object? lastMessageType = freezed,
    Object? users = null,
  }) {
    return _then(
      _value.copyWith(
            nom: freezed == nom
                ? _value.nom
                : nom // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastMessageId: freezed == lastMessageId
                ? _value.lastMessageId
                : lastMessageId // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastMessageContent: freezed == lastMessageContent
                ? _value.lastMessageContent
                : lastMessageContent // ignore: cast_nullable_to_non_nullable
                      as MessageModel?,
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastLockedDemand: freezed == lastLockedDemand
                ? _value.lastLockedDemand
                : lastLockedDemand // ignore: cast_nullable_to_non_nullable
                      as String?,
            salonPicture: freezed == salonPicture
                ? _value.salonPicture
                : salonPicture // ignore: cast_nullable_to_non_nullable
                      as String?,
            lock: freezed == lock
                ? _value.lock
                : lock // ignore: cast_nullable_to_non_nullable
                      as LockState?,
            allowAllUserToUpdateInformation:
                freezed == allowAllUserToUpdateInformation
                ? _value.allowAllUserToUpdateInformation
                : allowAllUserToUpdateInformation // ignore: cast_nullable_to_non_nullable
                      as bool?,
            adminId: freezed == adminId
                ? _value.adminId
                : adminId // ignore: cast_nullable_to_non_nullable
                      as String?,
            bloquedUser: freezed == bloquedUser
                ? _value.bloquedUser
                : bloquedUser // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as SalonType,
            lastMessageType: freezed == lastMessageType
                ? _value.lastMessageType
                : lastMessageType // ignore: cast_nullable_to_non_nullable
                      as MessageContentType?,
            users: null == users
                ? _value.users
                : users // ignore: cast_nullable_to_non_nullable
                      as List<String?>,
          )
          as $Val,
    );
  }

  /// Create a copy of SalonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageModelCopyWith<$Res>? get lastMessageContent {
    if (_value.lastMessageContent == null) {
      return null;
    }

    return $MessageModelCopyWith<$Res>(_value.lastMessageContent!, (value) {
      return _then(_value.copyWith(lastMessageContent: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SalonModelImplCopyWith<$Res>
    implements $SalonModelCopyWith<$Res> {
  factory _$$SalonModelImplCopyWith(
    _$SalonModelImpl value,
    $Res Function(_$SalonModelImpl) then,
  ) = __$$SalonModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? nom,
    String? lastMessageId,
    MessageModel? lastMessageContent,
    String? id,
    String? lastLockedDemand,
    String? salonPicture,
    LockState? lock,
    bool? allowAllUserToUpdateInformation,
    String? adminId,
    List<String>? bloquedUser,
    SalonType type,
    MessageContentType? lastMessageType,
    List<String?> users,
  });

  @override
  $MessageModelCopyWith<$Res>? get lastMessageContent;
}

/// @nodoc
class __$$SalonModelImplCopyWithImpl<$Res>
    extends _$SalonModelCopyWithImpl<$Res, _$SalonModelImpl>
    implements _$$SalonModelImplCopyWith<$Res> {
  __$$SalonModelImplCopyWithImpl(
    _$SalonModelImpl _value,
    $Res Function(_$SalonModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nom = freezed,
    Object? lastMessageId = freezed,
    Object? lastMessageContent = freezed,
    Object? id = freezed,
    Object? lastLockedDemand = freezed,
    Object? salonPicture = freezed,
    Object? lock = freezed,
    Object? allowAllUserToUpdateInformation = freezed,
    Object? adminId = freezed,
    Object? bloquedUser = freezed,
    Object? type = null,
    Object? lastMessageType = freezed,
    Object? users = null,
  }) {
    return _then(
      _$SalonModelImpl(
        nom: freezed == nom
            ? _value.nom
            : nom // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastMessageId: freezed == lastMessageId
            ? _value.lastMessageId
            : lastMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastMessageContent: freezed == lastMessageContent
            ? _value.lastMessageContent
            : lastMessageContent // ignore: cast_nullable_to_non_nullable
                  as MessageModel?,
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastLockedDemand: freezed == lastLockedDemand
            ? _value.lastLockedDemand
            : lastLockedDemand // ignore: cast_nullable_to_non_nullable
                  as String?,
        salonPicture: freezed == salonPicture
            ? _value.salonPicture
            : salonPicture // ignore: cast_nullable_to_non_nullable
                  as String?,
        lock: freezed == lock
            ? _value.lock
            : lock // ignore: cast_nullable_to_non_nullable
                  as LockState?,
        allowAllUserToUpdateInformation:
            freezed == allowAllUserToUpdateInformation
            ? _value.allowAllUserToUpdateInformation
            : allowAllUserToUpdateInformation // ignore: cast_nullable_to_non_nullable
                  as bool?,
        adminId: freezed == adminId
            ? _value.adminId
            : adminId // ignore: cast_nullable_to_non_nullable
                  as String?,
        bloquedUser: freezed == bloquedUser
            ? _value._bloquedUser
            : bloquedUser // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as SalonType,
        lastMessageType: freezed == lastMessageType
            ? _value.lastMessageType
            : lastMessageType // ignore: cast_nullable_to_non_nullable
                  as MessageContentType?,
        users: null == users
            ? _value._users
            : users // ignore: cast_nullable_to_non_nullable
                  as List<String?>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SalonModelImpl implements _SalonModel {
  const _$SalonModelImpl({
    this.nom,
    this.lastMessageId,
    this.lastMessageContent,
    this.id,
    this.lastLockedDemand,
    this.salonPicture,
    this.lock = LockState.notYet,
    this.allowAllUserToUpdateInformation,
    this.adminId,
    final List<String>? bloquedUser,
    required this.type,
    this.lastMessageType,
    required final List<String?> users,
  }) : _bloquedUser = bloquedUser,
       _users = users;

  factory _$SalonModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalonModelImplFromJson(json);

  @override
  final String? nom;
  @override
  final String? lastMessageId;
  @override
  final MessageModel? lastMessageContent;
  @override
  final String? id;
  @override
  final String? lastLockedDemand;
  @override
  final String? salonPicture;
  @override
  @JsonKey()
  final LockState? lock;
  @override
  final bool? allowAllUserToUpdateInformation;
  @override
  final String? adminId;
  final List<String>? _bloquedUser;
  @override
  List<String>? get bloquedUser {
    final value = _bloquedUser;
    if (value == null) return null;
    if (_bloquedUser is EqualUnmodifiableListView) return _bloquedUser;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final SalonType type;
  @override
  final MessageContentType? lastMessageType;
  final List<String?> _users;
  @override
  List<String?> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  String toString() {
    return 'SalonModel(nom: $nom, lastMessageId: $lastMessageId, lastMessageContent: $lastMessageContent, id: $id, lastLockedDemand: $lastLockedDemand, salonPicture: $salonPicture, lock: $lock, allowAllUserToUpdateInformation: $allowAllUserToUpdateInformation, adminId: $adminId, bloquedUser: $bloquedUser, type: $type, lastMessageType: $lastMessageType, users: $users)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalonModelImpl &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.lastMessageId, lastMessageId) ||
                other.lastMessageId == lastMessageId) &&
            (identical(other.lastMessageContent, lastMessageContent) ||
                other.lastMessageContent == lastMessageContent) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lastLockedDemand, lastLockedDemand) ||
                other.lastLockedDemand == lastLockedDemand) &&
            (identical(other.salonPicture, salonPicture) ||
                other.salonPicture == salonPicture) &&
            (identical(other.lock, lock) || other.lock == lock) &&
            (identical(
                  other.allowAllUserToUpdateInformation,
                  allowAllUserToUpdateInformation,
                ) ||
                other.allowAllUserToUpdateInformation ==
                    allowAllUserToUpdateInformation) &&
            (identical(other.adminId, adminId) || other.adminId == adminId) &&
            const DeepCollectionEquality().equals(
              other._bloquedUser,
              _bloquedUser,
            ) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.lastMessageType, lastMessageType) ||
                other.lastMessageType == lastMessageType) &&
            const DeepCollectionEquality().equals(other._users, _users));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    nom,
    lastMessageId,
    lastMessageContent,
    id,
    lastLockedDemand,
    salonPicture,
    lock,
    allowAllUserToUpdateInformation,
    adminId,
    const DeepCollectionEquality().hash(_bloquedUser),
    type,
    lastMessageType,
    const DeepCollectionEquality().hash(_users),
  );

  /// Create a copy of SalonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalonModelImplCopyWith<_$SalonModelImpl> get copyWith =>
      __$$SalonModelImplCopyWithImpl<_$SalonModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalonModelImplToJson(this);
  }
}

abstract class _SalonModel implements SalonModel {
  const factory _SalonModel({
    final String? nom,
    final String? lastMessageId,
    final MessageModel? lastMessageContent,
    final String? id,
    final String? lastLockedDemand,
    final String? salonPicture,
    final LockState? lock,
    final bool? allowAllUserToUpdateInformation,
    final String? adminId,
    final List<String>? bloquedUser,
    required final SalonType type,
    final MessageContentType? lastMessageType,
    required final List<String?> users,
  }) = _$SalonModelImpl;

  factory _SalonModel.fromJson(Map<String, dynamic> json) =
      _$SalonModelImpl.fromJson;

  @override
  String? get nom;
  @override
  String? get lastMessageId;
  @override
  MessageModel? get lastMessageContent;
  @override
  String? get id;
  @override
  String? get lastLockedDemand;
  @override
  String? get salonPicture;
  @override
  LockState? get lock;
  @override
  bool? get allowAllUserToUpdateInformation;
  @override
  String? get adminId;
  @override
  List<String>? get bloquedUser;
  @override
  SalonType get type;
  @override
  MessageContentType? get lastMessageType;
  @override
  List<String?> get users;

  /// Create a copy of SalonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalonModelImplCopyWith<_$SalonModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
