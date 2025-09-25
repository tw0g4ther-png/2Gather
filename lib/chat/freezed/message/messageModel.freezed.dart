// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'messageModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return _MessageModel.fromJson(json);
}

/// @nodoc
mixin _$MessageModel {
  String get sender => throw _privateConstructorUsedError;
  String? get relative_path => throw _privateConstructorUsedError;
  String? get blur_hash => throw _privateConstructorUsedError;
  String? get duration => throw _privateConstructorUsedError;
  String? get temporaryPath => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  String? get thumbnail_relative_path => throw _privateConstructorUsedError;
  String? get thumbnail_temporary_path => throw _privateConstructorUsedError;
  String? get urlMediaContent => throw _privateConstructorUsedError;
  List<String?>? get seenBy => throw _privateConstructorUsedError;
  List<String?>? get readedBy => throw _privateConstructorUsedError;
  bool? get sended => throw _privateConstructorUsedError;
  List<String?>? get userDeleteMessage => throw _privateConstructorUsedError;
  String? get lastMessageId => throw _privateConstructorUsedError;
  MessageLockButtonState? get state => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  MessageModel? get replyTo => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampServerConverter()
  DateTime? get timeStamp => throw _privateConstructorUsedError;
  MessageContentType get type => throw _privateConstructorUsedError;

  /// Serializes this MessageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageModelCopyWith<MessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageModelCopyWith<$Res> {
  factory $MessageModelCopyWith(
    MessageModel value,
    $Res Function(MessageModel) then,
  ) = _$MessageModelCopyWithImpl<$Res, MessageModel>;
  @useResult
  $Res call({
    String sender,
    String? relative_path,
    String? blur_hash,
    String? duration,
    String? temporaryPath,
    String? message,
    String? thumbnail,
    String? thumbnail_relative_path,
    String? thumbnail_temporary_path,
    String? urlMediaContent,
    List<String?>? seenBy,
    List<String?>? readedBy,
    bool? sended,
    List<String?>? userDeleteMessage,
    String? lastMessageId,
    MessageLockButtonState? state,
    String? id,
    MessageModel? replyTo,
    @TimestampConverter() DateTime createdAt,
    @TimestampServerConverter() DateTime? timeStamp,
    MessageContentType type,
  });

  $MessageModelCopyWith<$Res>? get replyTo;
}

/// @nodoc
class _$MessageModelCopyWithImpl<$Res, $Val extends MessageModel>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sender = null,
    Object? relative_path = freezed,
    Object? blur_hash = freezed,
    Object? duration = freezed,
    Object? temporaryPath = freezed,
    Object? message = freezed,
    Object? thumbnail = freezed,
    Object? thumbnail_relative_path = freezed,
    Object? thumbnail_temporary_path = freezed,
    Object? urlMediaContent = freezed,
    Object? seenBy = freezed,
    Object? readedBy = freezed,
    Object? sended = freezed,
    Object? userDeleteMessage = freezed,
    Object? lastMessageId = freezed,
    Object? state = freezed,
    Object? id = freezed,
    Object? replyTo = freezed,
    Object? createdAt = null,
    Object? timeStamp = freezed,
    Object? type = null,
  }) {
    return _then(
      _value.copyWith(
            sender: null == sender
                ? _value.sender
                : sender // ignore: cast_nullable_to_non_nullable
                      as String,
            relative_path: freezed == relative_path
                ? _value.relative_path
                : relative_path // ignore: cast_nullable_to_non_nullable
                      as String?,
            blur_hash: freezed == blur_hash
                ? _value.blur_hash
                : blur_hash // ignore: cast_nullable_to_non_nullable
                      as String?,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as String?,
            temporaryPath: freezed == temporaryPath
                ? _value.temporaryPath
                : temporaryPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            thumbnail: freezed == thumbnail
                ? _value.thumbnail
                : thumbnail // ignore: cast_nullable_to_non_nullable
                      as String?,
            thumbnail_relative_path: freezed == thumbnail_relative_path
                ? _value.thumbnail_relative_path
                : thumbnail_relative_path // ignore: cast_nullable_to_non_nullable
                      as String?,
            thumbnail_temporary_path: freezed == thumbnail_temporary_path
                ? _value.thumbnail_temporary_path
                : thumbnail_temporary_path // ignore: cast_nullable_to_non_nullable
                      as String?,
            urlMediaContent: freezed == urlMediaContent
                ? _value.urlMediaContent
                : urlMediaContent // ignore: cast_nullable_to_non_nullable
                      as String?,
            seenBy: freezed == seenBy
                ? _value.seenBy
                : seenBy // ignore: cast_nullable_to_non_nullable
                      as List<String?>?,
            readedBy: freezed == readedBy
                ? _value.readedBy
                : readedBy // ignore: cast_nullable_to_non_nullable
                      as List<String?>?,
            sended: freezed == sended
                ? _value.sended
                : sended // ignore: cast_nullable_to_non_nullable
                      as bool?,
            userDeleteMessage: freezed == userDeleteMessage
                ? _value.userDeleteMessage
                : userDeleteMessage // ignore: cast_nullable_to_non_nullable
                      as List<String?>?,
            lastMessageId: freezed == lastMessageId
                ? _value.lastMessageId
                : lastMessageId // ignore: cast_nullable_to_non_nullable
                      as String?,
            state: freezed == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as MessageLockButtonState?,
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            replyTo: freezed == replyTo
                ? _value.replyTo
                : replyTo // ignore: cast_nullable_to_non_nullable
                      as MessageModel?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            timeStamp: freezed == timeStamp
                ? _value.timeStamp
                : timeStamp // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as MessageContentType,
          )
          as $Val,
    );
  }

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageModelCopyWith<$Res>? get replyTo {
    if (_value.replyTo == null) {
      return null;
    }

    return $MessageModelCopyWith<$Res>(_value.replyTo!, (value) {
      return _then(_value.copyWith(replyTo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageModelImplCopyWith<$Res>
    implements $MessageModelCopyWith<$Res> {
  factory _$$MessageModelImplCopyWith(
    _$MessageModelImpl value,
    $Res Function(_$MessageModelImpl) then,
  ) = __$$MessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String sender,
    String? relative_path,
    String? blur_hash,
    String? duration,
    String? temporaryPath,
    String? message,
    String? thumbnail,
    String? thumbnail_relative_path,
    String? thumbnail_temporary_path,
    String? urlMediaContent,
    List<String?>? seenBy,
    List<String?>? readedBy,
    bool? sended,
    List<String?>? userDeleteMessage,
    String? lastMessageId,
    MessageLockButtonState? state,
    String? id,
    MessageModel? replyTo,
    @TimestampConverter() DateTime createdAt,
    @TimestampServerConverter() DateTime? timeStamp,
    MessageContentType type,
  });

  @override
  $MessageModelCopyWith<$Res>? get replyTo;
}

/// @nodoc
class __$$MessageModelImplCopyWithImpl<$Res>
    extends _$MessageModelCopyWithImpl<$Res, _$MessageModelImpl>
    implements _$$MessageModelImplCopyWith<$Res> {
  __$$MessageModelImplCopyWithImpl(
    _$MessageModelImpl _value,
    $Res Function(_$MessageModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sender = null,
    Object? relative_path = freezed,
    Object? blur_hash = freezed,
    Object? duration = freezed,
    Object? temporaryPath = freezed,
    Object? message = freezed,
    Object? thumbnail = freezed,
    Object? thumbnail_relative_path = freezed,
    Object? thumbnail_temporary_path = freezed,
    Object? urlMediaContent = freezed,
    Object? seenBy = freezed,
    Object? readedBy = freezed,
    Object? sended = freezed,
    Object? userDeleteMessage = freezed,
    Object? lastMessageId = freezed,
    Object? state = freezed,
    Object? id = freezed,
    Object? replyTo = freezed,
    Object? createdAt = null,
    Object? timeStamp = freezed,
    Object? type = null,
  }) {
    return _then(
      _$MessageModelImpl(
        sender: null == sender
            ? _value.sender
            : sender // ignore: cast_nullable_to_non_nullable
                  as String,
        relative_path: freezed == relative_path
            ? _value.relative_path
            : relative_path // ignore: cast_nullable_to_non_nullable
                  as String?,
        blur_hash: freezed == blur_hash
            ? _value.blur_hash
            : blur_hash // ignore: cast_nullable_to_non_nullable
                  as String?,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String?,
        temporaryPath: freezed == temporaryPath
            ? _value.temporaryPath
            : temporaryPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        thumbnail: freezed == thumbnail
            ? _value.thumbnail
            : thumbnail // ignore: cast_nullable_to_non_nullable
                  as String?,
        thumbnail_relative_path: freezed == thumbnail_relative_path
            ? _value.thumbnail_relative_path
            : thumbnail_relative_path // ignore: cast_nullable_to_non_nullable
                  as String?,
        thumbnail_temporary_path: freezed == thumbnail_temporary_path
            ? _value.thumbnail_temporary_path
            : thumbnail_temporary_path // ignore: cast_nullable_to_non_nullable
                  as String?,
        urlMediaContent: freezed == urlMediaContent
            ? _value.urlMediaContent
            : urlMediaContent // ignore: cast_nullable_to_non_nullable
                  as String?,
        seenBy: freezed == seenBy
            ? _value._seenBy
            : seenBy // ignore: cast_nullable_to_non_nullable
                  as List<String?>?,
        readedBy: freezed == readedBy
            ? _value._readedBy
            : readedBy // ignore: cast_nullable_to_non_nullable
                  as List<String?>?,
        sended: freezed == sended
            ? _value.sended
            : sended // ignore: cast_nullable_to_non_nullable
                  as bool?,
        userDeleteMessage: freezed == userDeleteMessage
            ? _value._userDeleteMessage
            : userDeleteMessage // ignore: cast_nullable_to_non_nullable
                  as List<String?>?,
        lastMessageId: freezed == lastMessageId
            ? _value.lastMessageId
            : lastMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        state: freezed == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as MessageLockButtonState?,
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        replyTo: freezed == replyTo
            ? _value.replyTo
            : replyTo // ignore: cast_nullable_to_non_nullable
                  as MessageModel?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        timeStamp: freezed == timeStamp
            ? _value.timeStamp
            : timeStamp // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as MessageContentType,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageModelImpl implements _MessageModel {
  const _$MessageModelImpl({
    required this.sender,
    this.relative_path,
    this.blur_hash,
    this.duration,
    this.temporaryPath,
    this.message,
    this.thumbnail,
    this.thumbnail_relative_path,
    this.thumbnail_temporary_path,
    this.urlMediaContent,
    final List<String?>? seenBy,
    final List<String?>? readedBy,
    this.sended,
    final List<String?>? userDeleteMessage,
    this.lastMessageId,
    this.state = MessageLockButtonState.notYet,
    this.id,
    this.replyTo,
    @TimestampConverter() required this.createdAt,
    @TimestampServerConverter() this.timeStamp,
    required this.type,
  }) : _seenBy = seenBy,
       _readedBy = readedBy,
       _userDeleteMessage = userDeleteMessage;

  factory _$MessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageModelImplFromJson(json);

  @override
  final String sender;
  @override
  final String? relative_path;
  @override
  final String? blur_hash;
  @override
  final String? duration;
  @override
  final String? temporaryPath;
  @override
  final String? message;
  @override
  final String? thumbnail;
  @override
  final String? thumbnail_relative_path;
  @override
  final String? thumbnail_temporary_path;
  @override
  final String? urlMediaContent;
  final List<String?>? _seenBy;
  @override
  List<String?>? get seenBy {
    final value = _seenBy;
    if (value == null) return null;
    if (_seenBy is EqualUnmodifiableListView) return _seenBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String?>? _readedBy;
  @override
  List<String?>? get readedBy {
    final value = _readedBy;
    if (value == null) return null;
    if (_readedBy is EqualUnmodifiableListView) return _readedBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool? sended;
  final List<String?>? _userDeleteMessage;
  @override
  List<String?>? get userDeleteMessage {
    final value = _userDeleteMessage;
    if (value == null) return null;
    if (_userDeleteMessage is EqualUnmodifiableListView)
      return _userDeleteMessage;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? lastMessageId;
  @override
  @JsonKey()
  final MessageLockButtonState? state;
  @override
  final String? id;
  @override
  final MessageModel? replyTo;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampServerConverter()
  final DateTime? timeStamp;
  @override
  final MessageContentType type;

  @override
  String toString() {
    return 'MessageModel(sender: $sender, relative_path: $relative_path, blur_hash: $blur_hash, duration: $duration, temporaryPath: $temporaryPath, message: $message, thumbnail: $thumbnail, thumbnail_relative_path: $thumbnail_relative_path, thumbnail_temporary_path: $thumbnail_temporary_path, urlMediaContent: $urlMediaContent, seenBy: $seenBy, readedBy: $readedBy, sended: $sended, userDeleteMessage: $userDeleteMessage, lastMessageId: $lastMessageId, state: $state, id: $id, replyTo: $replyTo, createdAt: $createdAt, timeStamp: $timeStamp, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageModelImpl &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.relative_path, relative_path) ||
                other.relative_path == relative_path) &&
            (identical(other.blur_hash, blur_hash) ||
                other.blur_hash == blur_hash) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.temporaryPath, temporaryPath) ||
                other.temporaryPath == temporaryPath) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(
                  other.thumbnail_relative_path,
                  thumbnail_relative_path,
                ) ||
                other.thumbnail_relative_path == thumbnail_relative_path) &&
            (identical(
                  other.thumbnail_temporary_path,
                  thumbnail_temporary_path,
                ) ||
                other.thumbnail_temporary_path == thumbnail_temporary_path) &&
            (identical(other.urlMediaContent, urlMediaContent) ||
                other.urlMediaContent == urlMediaContent) &&
            const DeepCollectionEquality().equals(other._seenBy, _seenBy) &&
            const DeepCollectionEquality().equals(other._readedBy, _readedBy) &&
            (identical(other.sended, sended) || other.sended == sended) &&
            const DeepCollectionEquality().equals(
              other._userDeleteMessage,
              _userDeleteMessage,
            ) &&
            (identical(other.lastMessageId, lastMessageId) ||
                other.lastMessageId == lastMessageId) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.replyTo, replyTo) || other.replyTo == replyTo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.timeStamp, timeStamp) ||
                other.timeStamp == timeStamp) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    sender,
    relative_path,
    blur_hash,
    duration,
    temporaryPath,
    message,
    thumbnail,
    thumbnail_relative_path,
    thumbnail_temporary_path,
    urlMediaContent,
    const DeepCollectionEquality().hash(_seenBy),
    const DeepCollectionEquality().hash(_readedBy),
    sended,
    const DeepCollectionEquality().hash(_userDeleteMessage),
    lastMessageId,
    state,
    id,
    replyTo,
    createdAt,
    timeStamp,
    type,
  ]);

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      __$$MessageModelImplCopyWithImpl<_$MessageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageModelImplToJson(this);
  }
}

abstract class _MessageModel implements MessageModel {
  const factory _MessageModel({
    required final String sender,
    final String? relative_path,
    final String? blur_hash,
    final String? duration,
    final String? temporaryPath,
    final String? message,
    final String? thumbnail,
    final String? thumbnail_relative_path,
    final String? thumbnail_temporary_path,
    final String? urlMediaContent,
    final List<String?>? seenBy,
    final List<String?>? readedBy,
    final bool? sended,
    final List<String?>? userDeleteMessage,
    final String? lastMessageId,
    final MessageLockButtonState? state,
    final String? id,
    final MessageModel? replyTo,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampServerConverter() final DateTime? timeStamp,
    required final MessageContentType type,
  }) = _$MessageModelImpl;

  factory _MessageModel.fromJson(Map<String, dynamic> json) =
      _$MessageModelImpl.fromJson;

  @override
  String get sender;
  @override
  String? get relative_path;
  @override
  String? get blur_hash;
  @override
  String? get duration;
  @override
  String? get temporaryPath;
  @override
  String? get message;
  @override
  String? get thumbnail;
  @override
  String? get thumbnail_relative_path;
  @override
  String? get thumbnail_temporary_path;
  @override
  String? get urlMediaContent;
  @override
  List<String?>? get seenBy;
  @override
  List<String?>? get readedBy;
  @override
  bool? get sended;
  @override
  List<String?>? get userDeleteMessage;
  @override
  String? get lastMessageId;
  @override
  MessageLockButtonState? get state;
  @override
  String? get id;
  @override
  MessageModel? get replyTo;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampServerConverter()
  DateTime? get timeStamp;
  @override
  MessageContentType get type;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
