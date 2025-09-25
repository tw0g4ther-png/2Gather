// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fiesta_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FiestaModel _$FiestaModelFromJson(Map<String, dynamic> json) {
  return _FiestaModel.fromJson(json);
}

/// @nodoc
mixin _$FiestaModel {
  String? get id => throw _privateConstructorUsedError;
  bool? get isEnd => throw _privateConstructorUsedError;
  AppUserModel? get host => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  double? get soundLevel => throw _privateConstructorUsedError;
  List<TagModel>? get tags => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool? get visibleAfter => throw _privateConstructorUsedError;
  List<String>? get pictures => throw _privateConstructorUsedError;
  @LocationConverters()
  LocationModel? get address => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get startAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get endAt => throw _privateConstructorUsedError;
  double? get numberOfParticipant => throw _privateConstructorUsedError;
  String? get logistic => throw _privateConstructorUsedError;
  List<TagModel>? get thingToBring => throw _privateConstructorUsedError;
  double? get visibilityRadius => throw _privateConstructorUsedError;
  bool? get visibleByFirstCircle => throw _privateConstructorUsedError;
  bool? get visibleByFiestar => throw _privateConstructorUsedError;
  bool? get visibleByConnexion => throw _privateConstructorUsedError;
  List<FiestaUserModel>? get participants => throw _privateConstructorUsedError;

  /// Serializes this FiestaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FiestaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FiestaModelCopyWith<FiestaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FiestaModelCopyWith<$Res> {
  factory $FiestaModelCopyWith(
    FiestaModel value,
    $Res Function(FiestaModel) then,
  ) = _$FiestaModelCopyWithImpl<$Res, FiestaModel>;
  @useResult
  $Res call({
    String? id,
    bool? isEnd,
    AppUserModel? host,
    String? title,
    String? category,
    double? soundLevel,
    List<TagModel>? tags,
    String? description,
    bool? visibleAfter,
    List<String>? pictures,
    @LocationConverters() LocationModel? address,
    @TimestampConverter() DateTime? startAt,
    @TimestampConverter() DateTime? endAt,
    double? numberOfParticipant,
    String? logistic,
    List<TagModel>? thingToBring,
    double? visibilityRadius,
    bool? visibleByFirstCircle,
    bool? visibleByFiestar,
    bool? visibleByConnexion,
    List<FiestaUserModel>? participants,
  });

  $AppUserModelCopyWith<$Res>? get host;
}

/// @nodoc
class _$FiestaModelCopyWithImpl<$Res, $Val extends FiestaModel>
    implements $FiestaModelCopyWith<$Res> {
  _$FiestaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FiestaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? isEnd = freezed,
    Object? host = freezed,
    Object? title = freezed,
    Object? category = freezed,
    Object? soundLevel = freezed,
    Object? tags = freezed,
    Object? description = freezed,
    Object? visibleAfter = freezed,
    Object? pictures = freezed,
    Object? address = freezed,
    Object? startAt = freezed,
    Object? endAt = freezed,
    Object? numberOfParticipant = freezed,
    Object? logistic = freezed,
    Object? thingToBring = freezed,
    Object? visibilityRadius = freezed,
    Object? visibleByFirstCircle = freezed,
    Object? visibleByFiestar = freezed,
    Object? visibleByConnexion = freezed,
    Object? participants = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            isEnd: freezed == isEnd
                ? _value.isEnd
                : isEnd // ignore: cast_nullable_to_non_nullable
                      as bool?,
            host: freezed == host
                ? _value.host
                : host // ignore: cast_nullable_to_non_nullable
                      as AppUserModel?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            soundLevel: freezed == soundLevel
                ? _value.soundLevel
                : soundLevel // ignore: cast_nullable_to_non_nullable
                      as double?,
            tags: freezed == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<TagModel>?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            visibleAfter: freezed == visibleAfter
                ? _value.visibleAfter
                : visibleAfter // ignore: cast_nullable_to_non_nullable
                      as bool?,
            pictures: freezed == pictures
                ? _value.pictures
                : pictures // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as LocationModel?,
            startAt: freezed == startAt
                ? _value.startAt
                : startAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endAt: freezed == endAt
                ? _value.endAt
                : endAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            numberOfParticipant: freezed == numberOfParticipant
                ? _value.numberOfParticipant
                : numberOfParticipant // ignore: cast_nullable_to_non_nullable
                      as double?,
            logistic: freezed == logistic
                ? _value.logistic
                : logistic // ignore: cast_nullable_to_non_nullable
                      as String?,
            thingToBring: freezed == thingToBring
                ? _value.thingToBring
                : thingToBring // ignore: cast_nullable_to_non_nullable
                      as List<TagModel>?,
            visibilityRadius: freezed == visibilityRadius
                ? _value.visibilityRadius
                : visibilityRadius // ignore: cast_nullable_to_non_nullable
                      as double?,
            visibleByFirstCircle: freezed == visibleByFirstCircle
                ? _value.visibleByFirstCircle
                : visibleByFirstCircle // ignore: cast_nullable_to_non_nullable
                      as bool?,
            visibleByFiestar: freezed == visibleByFiestar
                ? _value.visibleByFiestar
                : visibleByFiestar // ignore: cast_nullable_to_non_nullable
                      as bool?,
            visibleByConnexion: freezed == visibleByConnexion
                ? _value.visibleByConnexion
                : visibleByConnexion // ignore: cast_nullable_to_non_nullable
                      as bool?,
            participants: freezed == participants
                ? _value.participants
                : participants // ignore: cast_nullable_to_non_nullable
                      as List<FiestaUserModel>?,
          )
          as $Val,
    );
  }

  /// Create a copy of FiestaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppUserModelCopyWith<$Res>? get host {
    if (_value.host == null) {
      return null;
    }

    return $AppUserModelCopyWith<$Res>(_value.host!, (value) {
      return _then(_value.copyWith(host: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FiestaModelImplCopyWith<$Res>
    implements $FiestaModelCopyWith<$Res> {
  factory _$$FiestaModelImplCopyWith(
    _$FiestaModelImpl value,
    $Res Function(_$FiestaModelImpl) then,
  ) = __$$FiestaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    bool? isEnd,
    AppUserModel? host,
    String? title,
    String? category,
    double? soundLevel,
    List<TagModel>? tags,
    String? description,
    bool? visibleAfter,
    List<String>? pictures,
    @LocationConverters() LocationModel? address,
    @TimestampConverter() DateTime? startAt,
    @TimestampConverter() DateTime? endAt,
    double? numberOfParticipant,
    String? logistic,
    List<TagModel>? thingToBring,
    double? visibilityRadius,
    bool? visibleByFirstCircle,
    bool? visibleByFiestar,
    bool? visibleByConnexion,
    List<FiestaUserModel>? participants,
  });

  @override
  $AppUserModelCopyWith<$Res>? get host;
}

/// @nodoc
class __$$FiestaModelImplCopyWithImpl<$Res>
    extends _$FiestaModelCopyWithImpl<$Res, _$FiestaModelImpl>
    implements _$$FiestaModelImplCopyWith<$Res> {
  __$$FiestaModelImplCopyWithImpl(
    _$FiestaModelImpl _value,
    $Res Function(_$FiestaModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FiestaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? isEnd = freezed,
    Object? host = freezed,
    Object? title = freezed,
    Object? category = freezed,
    Object? soundLevel = freezed,
    Object? tags = freezed,
    Object? description = freezed,
    Object? visibleAfter = freezed,
    Object? pictures = freezed,
    Object? address = freezed,
    Object? startAt = freezed,
    Object? endAt = freezed,
    Object? numberOfParticipant = freezed,
    Object? logistic = freezed,
    Object? thingToBring = freezed,
    Object? visibilityRadius = freezed,
    Object? visibleByFirstCircle = freezed,
    Object? visibleByFiestar = freezed,
    Object? visibleByConnexion = freezed,
    Object? participants = freezed,
  }) {
    return _then(
      _$FiestaModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        isEnd: freezed == isEnd
            ? _value.isEnd
            : isEnd // ignore: cast_nullable_to_non_nullable
                  as bool?,
        host: freezed == host
            ? _value.host
            : host // ignore: cast_nullable_to_non_nullable
                  as AppUserModel?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        soundLevel: freezed == soundLevel
            ? _value.soundLevel
            : soundLevel // ignore: cast_nullable_to_non_nullable
                  as double?,
        tags: freezed == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<TagModel>?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        visibleAfter: freezed == visibleAfter
            ? _value.visibleAfter
            : visibleAfter // ignore: cast_nullable_to_non_nullable
                  as bool?,
        pictures: freezed == pictures
            ? _value._pictures
            : pictures // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as LocationModel?,
        startAt: freezed == startAt
            ? _value.startAt
            : startAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endAt: freezed == endAt
            ? _value.endAt
            : endAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        numberOfParticipant: freezed == numberOfParticipant
            ? _value.numberOfParticipant
            : numberOfParticipant // ignore: cast_nullable_to_non_nullable
                  as double?,
        logistic: freezed == logistic
            ? _value.logistic
            : logistic // ignore: cast_nullable_to_non_nullable
                  as String?,
        thingToBring: freezed == thingToBring
            ? _value._thingToBring
            : thingToBring // ignore: cast_nullable_to_non_nullable
                  as List<TagModel>?,
        visibilityRadius: freezed == visibilityRadius
            ? _value.visibilityRadius
            : visibilityRadius // ignore: cast_nullable_to_non_nullable
                  as double?,
        visibleByFirstCircle: freezed == visibleByFirstCircle
            ? _value.visibleByFirstCircle
            : visibleByFirstCircle // ignore: cast_nullable_to_non_nullable
                  as bool?,
        visibleByFiestar: freezed == visibleByFiestar
            ? _value.visibleByFiestar
            : visibleByFiestar // ignore: cast_nullable_to_non_nullable
                  as bool?,
        visibleByConnexion: freezed == visibleByConnexion
            ? _value.visibleByConnexion
            : visibleByConnexion // ignore: cast_nullable_to_non_nullable
                  as bool?,
        participants: freezed == participants
            ? _value._participants
            : participants // ignore: cast_nullable_to_non_nullable
                  as List<FiestaUserModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FiestaModelImpl implements _FiestaModel {
  const _$FiestaModelImpl({
    this.id,
    this.isEnd,
    this.host,
    this.title,
    this.category,
    this.soundLevel,
    final List<TagModel>? tags,
    this.description,
    this.visibleAfter,
    final List<String>? pictures,
    @LocationConverters() this.address,
    @TimestampConverter() this.startAt,
    @TimestampConverter() this.endAt,
    this.numberOfParticipant,
    this.logistic,
    final List<TagModel>? thingToBring,
    this.visibilityRadius,
    this.visibleByFirstCircle,
    this.visibleByFiestar,
    this.visibleByConnexion,
    final List<FiestaUserModel>? participants,
  }) : _tags = tags,
       _pictures = pictures,
       _thingToBring = thingToBring,
       _participants = participants;

  factory _$FiestaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FiestaModelImplFromJson(json);

  @override
  final String? id;
  @override
  final bool? isEnd;
  @override
  final AppUserModel? host;
  @override
  final String? title;
  @override
  final String? category;
  @override
  final double? soundLevel;
  final List<TagModel>? _tags;
  @override
  List<TagModel>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? description;
  @override
  final bool? visibleAfter;
  final List<String>? _pictures;
  @override
  List<String>? get pictures {
    final value = _pictures;
    if (value == null) return null;
    if (_pictures is EqualUnmodifiableListView) return _pictures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @LocationConverters()
  final LocationModel? address;
  @override
  @TimestampConverter()
  final DateTime? startAt;
  @override
  @TimestampConverter()
  final DateTime? endAt;
  @override
  final double? numberOfParticipant;
  @override
  final String? logistic;
  final List<TagModel>? _thingToBring;
  @override
  List<TagModel>? get thingToBring {
    final value = _thingToBring;
    if (value == null) return null;
    if (_thingToBring is EqualUnmodifiableListView) return _thingToBring;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final double? visibilityRadius;
  @override
  final bool? visibleByFirstCircle;
  @override
  final bool? visibleByFiestar;
  @override
  final bool? visibleByConnexion;
  final List<FiestaUserModel>? _participants;
  @override
  List<FiestaUserModel>? get participants {
    final value = _participants;
    if (value == null) return null;
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FiestaModel(id: $id, isEnd: $isEnd, host: $host, title: $title, category: $category, soundLevel: $soundLevel, tags: $tags, description: $description, visibleAfter: $visibleAfter, pictures: $pictures, address: $address, startAt: $startAt, endAt: $endAt, numberOfParticipant: $numberOfParticipant, logistic: $logistic, thingToBring: $thingToBring, visibilityRadius: $visibilityRadius, visibleByFirstCircle: $visibleByFirstCircle, visibleByFiestar: $visibleByFiestar, visibleByConnexion: $visibleByConnexion, participants: $participants)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FiestaModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isEnd, isEnd) || other.isEnd == isEnd) &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.soundLevel, soundLevel) ||
                other.soundLevel == soundLevel) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.visibleAfter, visibleAfter) ||
                other.visibleAfter == visibleAfter) &&
            const DeepCollectionEquality().equals(other._pictures, _pictures) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.numberOfParticipant, numberOfParticipant) ||
                other.numberOfParticipant == numberOfParticipant) &&
            (identical(other.logistic, logistic) ||
                other.logistic == logistic) &&
            const DeepCollectionEquality().equals(
              other._thingToBring,
              _thingToBring,
            ) &&
            (identical(other.visibilityRadius, visibilityRadius) ||
                other.visibilityRadius == visibilityRadius) &&
            (identical(other.visibleByFirstCircle, visibleByFirstCircle) ||
                other.visibleByFirstCircle == visibleByFirstCircle) &&
            (identical(other.visibleByFiestar, visibleByFiestar) ||
                other.visibleByFiestar == visibleByFiestar) &&
            (identical(other.visibleByConnexion, visibleByConnexion) ||
                other.visibleByConnexion == visibleByConnexion) &&
            const DeepCollectionEquality().equals(
              other._participants,
              _participants,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    isEnd,
    host,
    title,
    category,
    soundLevel,
    const DeepCollectionEquality().hash(_tags),
    description,
    visibleAfter,
    const DeepCollectionEquality().hash(_pictures),
    address,
    startAt,
    endAt,
    numberOfParticipant,
    logistic,
    const DeepCollectionEquality().hash(_thingToBring),
    visibilityRadius,
    visibleByFirstCircle,
    visibleByFiestar,
    visibleByConnexion,
    const DeepCollectionEquality().hash(_participants),
  ]);

  /// Create a copy of FiestaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FiestaModelImplCopyWith<_$FiestaModelImpl> get copyWith =>
      __$$FiestaModelImplCopyWithImpl<_$FiestaModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FiestaModelImplToJson(this);
  }
}

abstract class _FiestaModel implements FiestaModel {
  const factory _FiestaModel({
    final String? id,
    final bool? isEnd,
    final AppUserModel? host,
    final String? title,
    final String? category,
    final double? soundLevel,
    final List<TagModel>? tags,
    final String? description,
    final bool? visibleAfter,
    final List<String>? pictures,
    @LocationConverters() final LocationModel? address,
    @TimestampConverter() final DateTime? startAt,
    @TimestampConverter() final DateTime? endAt,
    final double? numberOfParticipant,
    final String? logistic,
    final List<TagModel>? thingToBring,
    final double? visibilityRadius,
    final bool? visibleByFirstCircle,
    final bool? visibleByFiestar,
    final bool? visibleByConnexion,
    final List<FiestaUserModel>? participants,
  }) = _$FiestaModelImpl;

  factory _FiestaModel.fromJson(Map<String, dynamic> json) =
      _$FiestaModelImpl.fromJson;

  @override
  String? get id;
  @override
  bool? get isEnd;
  @override
  AppUserModel? get host;
  @override
  String? get title;
  @override
  String? get category;
  @override
  double? get soundLevel;
  @override
  List<TagModel>? get tags;
  @override
  String? get description;
  @override
  bool? get visibleAfter;
  @override
  List<String>? get pictures;
  @override
  @LocationConverters()
  LocationModel? get address;
  @override
  @TimestampConverter()
  DateTime? get startAt;
  @override
  @TimestampConverter()
  DateTime? get endAt;
  @override
  double? get numberOfParticipant;
  @override
  String? get logistic;
  @override
  List<TagModel>? get thingToBring;
  @override
  double? get visibilityRadius;
  @override
  bool? get visibleByFirstCircle;
  @override
  bool? get visibleByFiestar;
  @override
  bool? get visibleByConnexion;
  @override
  List<FiestaUserModel>? get participants;

  /// Create a copy of FiestaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FiestaModelImplCopyWith<_$FiestaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FiestaUserModel _$FiestaUserModelFromJson(Map<String, dynamic> json) {
  return _FiestaUserModel.fromJson(json);
}

/// @nodoc
mixin _$FiestaUserModel {
  String? get fiestaRef => throw _privateConstructorUsedError;
  String? get duoRef => throw _privateConstructorUsedError;
  @FiestaUserStatusConverter()
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this FiestaUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FiestaUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FiestaUserModelCopyWith<FiestaUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FiestaUserModelCopyWith<$Res> {
  factory $FiestaUserModelCopyWith(
    FiestaUserModel value,
    $Res Function(FiestaUserModel) then,
  ) = _$FiestaUserModelCopyWithImpl<$Res, FiestaUserModel>;
  @useResult
  $Res call({
    String? fiestaRef,
    String? duoRef,
    @FiestaUserStatusConverter() String? status,
  });
}

/// @nodoc
class _$FiestaUserModelCopyWithImpl<$Res, $Val extends FiestaUserModel>
    implements $FiestaUserModelCopyWith<$Res> {
  _$FiestaUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FiestaUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fiestaRef = freezed,
    Object? duoRef = freezed,
    Object? status = freezed,
  }) {
    return _then(
      _value.copyWith(
            fiestaRef: freezed == fiestaRef
                ? _value.fiestaRef
                : fiestaRef // ignore: cast_nullable_to_non_nullable
                      as String?,
            duoRef: freezed == duoRef
                ? _value.duoRef
                : duoRef // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FiestaUserModelImplCopyWith<$Res>
    implements $FiestaUserModelCopyWith<$Res> {
  factory _$$FiestaUserModelImplCopyWith(
    _$FiestaUserModelImpl value,
    $Res Function(_$FiestaUserModelImpl) then,
  ) = __$$FiestaUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? fiestaRef,
    String? duoRef,
    @FiestaUserStatusConverter() String? status,
  });
}

/// @nodoc
class __$$FiestaUserModelImplCopyWithImpl<$Res>
    extends _$FiestaUserModelCopyWithImpl<$Res, _$FiestaUserModelImpl>
    implements _$$FiestaUserModelImplCopyWith<$Res> {
  __$$FiestaUserModelImplCopyWithImpl(
    _$FiestaUserModelImpl _value,
    $Res Function(_$FiestaUserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FiestaUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fiestaRef = freezed,
    Object? duoRef = freezed,
    Object? status = freezed,
  }) {
    return _then(
      _$FiestaUserModelImpl(
        fiestaRef: freezed == fiestaRef
            ? _value.fiestaRef
            : fiestaRef // ignore: cast_nullable_to_non_nullable
                  as String?,
        duoRef: freezed == duoRef
            ? _value.duoRef
            : duoRef // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FiestaUserModelImpl implements _FiestaUserModel {
  const _$FiestaUserModelImpl({
    this.fiestaRef,
    this.duoRef,
    @FiestaUserStatusConverter() this.status,
  });

  factory _$FiestaUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FiestaUserModelImplFromJson(json);

  @override
  final String? fiestaRef;
  @override
  final String? duoRef;
  @override
  @FiestaUserStatusConverter()
  final String? status;

  @override
  String toString() {
    return 'FiestaUserModel(fiestaRef: $fiestaRef, duoRef: $duoRef, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FiestaUserModelImpl &&
            (identical(other.fiestaRef, fiestaRef) ||
                other.fiestaRef == fiestaRef) &&
            (identical(other.duoRef, duoRef) || other.duoRef == duoRef) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fiestaRef, duoRef, status);

  /// Create a copy of FiestaUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FiestaUserModelImplCopyWith<_$FiestaUserModelImpl> get copyWith =>
      __$$FiestaUserModelImplCopyWithImpl<_$FiestaUserModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FiestaUserModelImplToJson(this);
  }
}

abstract class _FiestaUserModel implements FiestaUserModel {
  const factory _FiestaUserModel({
    final String? fiestaRef,
    final String? duoRef,
    @FiestaUserStatusConverter() final String? status,
  }) = _$FiestaUserModelImpl;

  factory _FiestaUserModel.fromJson(Map<String, dynamic> json) =
      _$FiestaUserModelImpl.fromJson;

  @override
  String? get fiestaRef;
  @override
  String? get duoRef;
  @override
  @FiestaUserStatusConverter()
  String? get status;

  /// Create a copy of FiestaUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FiestaUserModelImplCopyWith<_$FiestaUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
