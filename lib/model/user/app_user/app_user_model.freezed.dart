// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppUserModel _$AppUserModelFromJson(Map<String, dynamic> json) {
  return _AppUserModel.fromJson(json);
}

/// @nodoc
mixin _$AppUserModel {
  String? get id => throw _privateConstructorUsedError;
  String? get firstname => throw _privateConstructorUsedError;
  String? get lastname => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  double? get reportPoint => throw _privateConstructorUsedError;
  double? get level => throw _privateConstructorUsedError;
  List<String>? get nationality => throw _privateConstructorUsedError;
  List<String>? get languages => throw _privateConstructorUsedError;
  List<String>? get pictures => throw _privateConstructorUsedError;
  String? get profilImage =>
      throw _privateConstructorUsedError; // Image de profil principale
  String? get description => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  double? get note => throw _privateConstructorUsedError;
  double? get numberNote => throw _privateConstructorUsedError;
  double? get numberRecommandations => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get birthday => throw _privateConstructorUsedError;
  @GeoPointConverters()
  GeoPoint? get position => throw _privateConstructorUsedError;
  String? get locality => throw _privateConstructorUsedError;
  PassionListing? get tags => throw _privateConstructorUsedError;
  bool? get isLock => throw _privateConstructorUsedError;

  /// Serializes this AppUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppUserModelCopyWith<AppUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUserModelCopyWith<$Res> {
  factory $AppUserModelCopyWith(
    AppUserModel value,
    $Res Function(AppUserModel) then,
  ) = _$AppUserModelCopyWithImpl<$Res, AppUserModel>;
  @useResult
  $Res call({
    String? id,
    String? firstname,
    String? lastname,
    String? gender,
    double? reportPoint,
    double? level,
    List<String>? nationality,
    List<String>? languages,
    List<String>? pictures,
    String? profilImage,
    String? description,
    double? rating,
    double? note,
    double? numberNote,
    double? numberRecommandations,
    String? country,
    @TimestampConverter() DateTime? birthday,
    @GeoPointConverters() GeoPoint? position,
    String? locality,
    PassionListing? tags,
    bool? isLock,
  });

  $PassionListingCopyWith<$Res>? get tags;
}

/// @nodoc
class _$AppUserModelCopyWithImpl<$Res, $Val extends AppUserModel>
    implements $AppUserModelCopyWith<$Res> {
  _$AppUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstname = freezed,
    Object? lastname = freezed,
    Object? gender = freezed,
    Object? reportPoint = freezed,
    Object? level = freezed,
    Object? nationality = freezed,
    Object? languages = freezed,
    Object? pictures = freezed,
    Object? profilImage = freezed,
    Object? description = freezed,
    Object? rating = freezed,
    Object? note = freezed,
    Object? numberNote = freezed,
    Object? numberRecommandations = freezed,
    Object? country = freezed,
    Object? birthday = freezed,
    Object? position = freezed,
    Object? locality = freezed,
    Object? tags = freezed,
    Object? isLock = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            firstname: freezed == firstname
                ? _value.firstname
                : firstname // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastname: freezed == lastname
                ? _value.lastname
                : lastname // ignore: cast_nullable_to_non_nullable
                      as String?,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String?,
            reportPoint: freezed == reportPoint
                ? _value.reportPoint
                : reportPoint // ignore: cast_nullable_to_non_nullable
                      as double?,
            level: freezed == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as double?,
            nationality: freezed == nationality
                ? _value.nationality
                : nationality // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            languages: freezed == languages
                ? _value.languages
                : languages // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            pictures: freezed == pictures
                ? _value.pictures
                : pictures // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            profilImage: freezed == profilImage
                ? _value.profilImage
                : profilImage // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as double?,
            numberNote: freezed == numberNote
                ? _value.numberNote
                : numberNote // ignore: cast_nullable_to_non_nullable
                      as double?,
            numberRecommandations: freezed == numberRecommandations
                ? _value.numberRecommandations
                : numberRecommandations // ignore: cast_nullable_to_non_nullable
                      as double?,
            country: freezed == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as String?,
            birthday: freezed == birthday
                ? _value.birthday
                : birthday // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            position: freezed == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as GeoPoint?,
            locality: freezed == locality
                ? _value.locality
                : locality // ignore: cast_nullable_to_non_nullable
                      as String?,
            tags: freezed == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as PassionListing?,
            isLock: freezed == isLock
                ? _value.isLock
                : isLock // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }

  /// Create a copy of AppUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PassionListingCopyWith<$Res>? get tags {
    if (_value.tags == null) {
      return null;
    }

    return $PassionListingCopyWith<$Res>(_value.tags!, (value) {
      return _then(_value.copyWith(tags: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppUserModelImplCopyWith<$Res>
    implements $AppUserModelCopyWith<$Res> {
  factory _$$AppUserModelImplCopyWith(
    _$AppUserModelImpl value,
    $Res Function(_$AppUserModelImpl) then,
  ) = __$$AppUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String? firstname,
    String? lastname,
    String? gender,
    double? reportPoint,
    double? level,
    List<String>? nationality,
    List<String>? languages,
    List<String>? pictures,
    String? profilImage,
    String? description,
    double? rating,
    double? note,
    double? numberNote,
    double? numberRecommandations,
    String? country,
    @TimestampConverter() DateTime? birthday,
    @GeoPointConverters() GeoPoint? position,
    String? locality,
    PassionListing? tags,
    bool? isLock,
  });

  @override
  $PassionListingCopyWith<$Res>? get tags;
}

/// @nodoc
class __$$AppUserModelImplCopyWithImpl<$Res>
    extends _$AppUserModelCopyWithImpl<$Res, _$AppUserModelImpl>
    implements _$$AppUserModelImplCopyWith<$Res> {
  __$$AppUserModelImplCopyWithImpl(
    _$AppUserModelImpl _value,
    $Res Function(_$AppUserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstname = freezed,
    Object? lastname = freezed,
    Object? gender = freezed,
    Object? reportPoint = freezed,
    Object? level = freezed,
    Object? nationality = freezed,
    Object? languages = freezed,
    Object? pictures = freezed,
    Object? profilImage = freezed,
    Object? description = freezed,
    Object? rating = freezed,
    Object? note = freezed,
    Object? numberNote = freezed,
    Object? numberRecommandations = freezed,
    Object? country = freezed,
    Object? birthday = freezed,
    Object? position = freezed,
    Object? locality = freezed,
    Object? tags = freezed,
    Object? isLock = freezed,
  }) {
    return _then(
      _$AppUserModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        firstname: freezed == firstname
            ? _value.firstname
            : firstname // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastname: freezed == lastname
            ? _value.lastname
            : lastname // ignore: cast_nullable_to_non_nullable
                  as String?,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String?,
        reportPoint: freezed == reportPoint
            ? _value.reportPoint
            : reportPoint // ignore: cast_nullable_to_non_nullable
                  as double?,
        level: freezed == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as double?,
        nationality: freezed == nationality
            ? _value._nationality
            : nationality // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        languages: freezed == languages
            ? _value._languages
            : languages // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        pictures: freezed == pictures
            ? _value._pictures
            : pictures // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        profilImage: freezed == profilImage
            ? _value.profilImage
            : profilImage // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as double?,
        numberNote: freezed == numberNote
            ? _value.numberNote
            : numberNote // ignore: cast_nullable_to_non_nullable
                  as double?,
        numberRecommandations: freezed == numberRecommandations
            ? _value.numberRecommandations
            : numberRecommandations // ignore: cast_nullable_to_non_nullable
                  as double?,
        country: freezed == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String?,
        birthday: freezed == birthday
            ? _value.birthday
            : birthday // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        position: freezed == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as GeoPoint?,
        locality: freezed == locality
            ? _value.locality
            : locality // ignore: cast_nullable_to_non_nullable
                  as String?,
        tags: freezed == tags
            ? _value.tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as PassionListing?,
        isLock: freezed == isLock
            ? _value.isLock
            : isLock // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppUserModelImpl implements _AppUserModel {
  const _$AppUserModelImpl({
    this.id,
    this.firstname,
    this.lastname,
    this.gender,
    this.reportPoint,
    this.level,
    final List<String>? nationality,
    final List<String>? languages,
    final List<String>? pictures,
    this.profilImage,
    this.description,
    this.rating,
    this.note,
    this.numberNote,
    this.numberRecommandations,
    this.country,
    @TimestampConverter() this.birthday,
    @GeoPointConverters() this.position,
    this.locality,
    this.tags,
    this.isLock,
  }) : _nationality = nationality,
       _languages = languages,
       _pictures = pictures;

  factory _$AppUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppUserModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String? firstname;
  @override
  final String? lastname;
  @override
  final String? gender;
  @override
  final double? reportPoint;
  @override
  final double? level;
  final List<String>? _nationality;
  @override
  List<String>? get nationality {
    final value = _nationality;
    if (value == null) return null;
    if (_nationality is EqualUnmodifiableListView) return _nationality;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _languages;
  @override
  List<String>? get languages {
    final value = _languages;
    if (value == null) return null;
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
  final String? profilImage;
  // Image de profil principale
  @override
  final String? description;
  @override
  final double? rating;
  @override
  final double? note;
  @override
  final double? numberNote;
  @override
  final double? numberRecommandations;
  @override
  final String? country;
  @override
  @TimestampConverter()
  final DateTime? birthday;
  @override
  @GeoPointConverters()
  final GeoPoint? position;
  @override
  final String? locality;
  @override
  final PassionListing? tags;
  @override
  final bool? isLock;

  @override
  String toString() {
    return 'AppUserModel(id: $id, firstname: $firstname, lastname: $lastname, gender: $gender, reportPoint: $reportPoint, level: $level, nationality: $nationality, languages: $languages, pictures: $pictures, profilImage: $profilImage, description: $description, rating: $rating, note: $note, numberNote: $numberNote, numberRecommandations: $numberRecommandations, country: $country, birthday: $birthday, position: $position, locality: $locality, tags: $tags, isLock: $isLock)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstname, firstname) ||
                other.firstname == firstname) &&
            (identical(other.lastname, lastname) ||
                other.lastname == lastname) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.reportPoint, reportPoint) ||
                other.reportPoint == reportPoint) &&
            (identical(other.level, level) || other.level == level) &&
            const DeepCollectionEquality().equals(
              other._nationality,
              _nationality,
            ) &&
            const DeepCollectionEquality().equals(
              other._languages,
              _languages,
            ) &&
            const DeepCollectionEquality().equals(other._pictures, _pictures) &&
            (identical(other.profilImage, profilImage) ||
                other.profilImage == profilImage) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.numberNote, numberNote) ||
                other.numberNote == numberNote) &&
            (identical(other.numberRecommandations, numberRecommandations) ||
                other.numberRecommandations == numberRecommandations) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.birthday, birthday) ||
                other.birthday == birthday) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.locality, locality) ||
                other.locality == locality) &&
            (identical(other.tags, tags) || other.tags == tags) &&
            (identical(other.isLock, isLock) || other.isLock == isLock));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    firstname,
    lastname,
    gender,
    reportPoint,
    level,
    const DeepCollectionEquality().hash(_nationality),
    const DeepCollectionEquality().hash(_languages),
    const DeepCollectionEquality().hash(_pictures),
    profilImage,
    description,
    rating,
    note,
    numberNote,
    numberRecommandations,
    country,
    birthday,
    position,
    locality,
    tags,
    isLock,
  ]);

  /// Create a copy of AppUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUserModelImplCopyWith<_$AppUserModelImpl> get copyWith =>
      __$$AppUserModelImplCopyWithImpl<_$AppUserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppUserModelImplToJson(this);
  }
}

abstract class _AppUserModel implements AppUserModel {
  const factory _AppUserModel({
    final String? id,
    final String? firstname,
    final String? lastname,
    final String? gender,
    final double? reportPoint,
    final double? level,
    final List<String>? nationality,
    final List<String>? languages,
    final List<String>? pictures,
    final String? profilImage,
    final String? description,
    final double? rating,
    final double? note,
    final double? numberNote,
    final double? numberRecommandations,
    final String? country,
    @TimestampConverter() final DateTime? birthday,
    @GeoPointConverters() final GeoPoint? position,
    final String? locality,
    final PassionListing? tags,
    final bool? isLock,
  }) = _$AppUserModelImpl;

  factory _AppUserModel.fromJson(Map<String, dynamic> json) =
      _$AppUserModelImpl.fromJson;

  @override
  String? get id;
  @override
  String? get firstname;
  @override
  String? get lastname;
  @override
  String? get gender;
  @override
  double? get reportPoint;
  @override
  double? get level;
  @override
  List<String>? get nationality;
  @override
  List<String>? get languages;
  @override
  List<String>? get pictures;
  @override
  String? get profilImage; // Image de profil principale
  @override
  String? get description;
  @override
  double? get rating;
  @override
  double? get note;
  @override
  double? get numberNote;
  @override
  double? get numberRecommandations;
  @override
  String? get country;
  @override
  @TimestampConverter()
  DateTime? get birthday;
  @override
  @GeoPointConverters()
  GeoPoint? get position;
  @override
  String? get locality;
  @override
  PassionListing? get tags;
  @override
  bool? get isLock;

  /// Create a copy of AppUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUserModelImplCopyWith<_$AppUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
