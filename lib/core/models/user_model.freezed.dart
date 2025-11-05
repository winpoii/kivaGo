// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get uid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get photoUrl => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get fcmToken => throw _privateConstructorUsedError;
  SeekerProfileModel get seekerProfile => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String uid,
      String email,
      String displayName,
      String photoUrl,
      @TimestampConverter() DateTime createdAt,
      String fcmToken,
      SeekerProfileModel seekerProfile,
      String username,
      String country,
      String city,
      String firstName,
      String lastName});

  $SeekerProfileModelCopyWith<$Res> get seekerProfile;
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = null,
    Object? photoUrl = null,
    Object? createdAt = null,
    Object? fcmToken = null,
    Object? seekerProfile = null,
    Object? username = null,
    Object? country = null,
    Object? city = null,
    Object? firstName = null,
    Object? lastName = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: null == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      fcmToken: null == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String,
      seekerProfile: null == seekerProfile
          ? _value.seekerProfile
          : seekerProfile // ignore: cast_nullable_to_non_nullable
              as SeekerProfileModel,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SeekerProfileModelCopyWith<$Res> get seekerProfile {
    return $SeekerProfileModelCopyWith<$Res>(_value.seekerProfile, (value) {
      return _then(_value.copyWith(seekerProfile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String email,
      String displayName,
      String photoUrl,
      @TimestampConverter() DateTime createdAt,
      String fcmToken,
      SeekerProfileModel seekerProfile,
      String username,
      String country,
      String city,
      String firstName,
      String lastName});

  @override
  $SeekerProfileModelCopyWith<$Res> get seekerProfile;
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = null,
    Object? photoUrl = null,
    Object? createdAt = null,
    Object? fcmToken = null,
    Object? seekerProfile = null,
    Object? username = null,
    Object? country = null,
    Object? city = null,
    Object? firstName = null,
    Object? lastName = null,
  }) {
    return _then(_$UserModelImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: null == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      fcmToken: null == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String,
      seekerProfile: null == seekerProfile
          ? _value.seekerProfile
          : seekerProfile // ignore: cast_nullable_to_non_nullable
              as SeekerProfileModel,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl(
      {required this.uid,
      required this.email,
      required this.displayName,
      required this.photoUrl,
      @TimestampConverter() required this.createdAt,
      required this.fcmToken,
      required this.seekerProfile,
      this.username = '',
      this.country = '',
      this.city = '',
      this.firstName = '',
      this.lastName = ''});

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String uid;
  @override
  final String email;
  @override
  final String displayName;
  @override
  final String photoUrl;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  final String fcmToken;
  @override
  final SeekerProfileModel seekerProfile;
  @override
  @JsonKey()
  final String username;
  @override
  @JsonKey()
  final String country;
  @override
  @JsonKey()
  final String city;
  @override
  @JsonKey()
  final String firstName;
  @override
  @JsonKey()
  final String lastName;

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, displayName: $displayName, photoUrl: $photoUrl, createdAt: $createdAt, fcmToken: $fcmToken, seekerProfile: $seekerProfile, username: $username, country: $country, city: $city, firstName: $firstName, lastName: $lastName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            (identical(other.seekerProfile, seekerProfile) ||
                other.seekerProfile == seekerProfile) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      email,
      displayName,
      photoUrl,
      createdAt,
      fcmToken,
      seekerProfile,
      username,
      country,
      city,
      firstName,
      lastName);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
      {required final String uid,
      required final String email,
      required final String displayName,
      required final String photoUrl,
      @TimestampConverter() required final DateTime createdAt,
      required final String fcmToken,
      required final SeekerProfileModel seekerProfile,
      final String username,
      final String country,
      final String city,
      final String firstName,
      final String lastName}) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get uid;
  @override
  String get email;
  @override
  String get displayName;
  @override
  String get photoUrl;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  String get fcmToken;
  @override
  SeekerProfileModel get seekerProfile;
  @override
  String get username;
  @override
  String get country;
  @override
  String get city;
  @override
  String get firstName;
  @override
  String get lastName;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SeekerProfileModel _$SeekerProfileModelFromJson(Map<String, dynamic> json) {
  return _SeekerProfileModel.fromJson(json);
}

/// @nodoc
mixin _$SeekerProfileModel {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<int> get testAnswers => throw _privateConstructorUsedError;
  CalculatedScoresModel get calculatedScores =>
      throw _privateConstructorUsedError;

  /// Serializes this SeekerProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SeekerProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SeekerProfileModelCopyWith<SeekerProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SeekerProfileModelCopyWith<$Res> {
  factory $SeekerProfileModelCopyWith(
          SeekerProfileModel value, $Res Function(SeekerProfileModel) then) =
      _$SeekerProfileModelCopyWithImpl<$Res, SeekerProfileModel>;
  @useResult
  $Res call(
      {String title,
      String description,
      List<int> testAnswers,
      CalculatedScoresModel calculatedScores});

  $CalculatedScoresModelCopyWith<$Res> get calculatedScores;
}

/// @nodoc
class _$SeekerProfileModelCopyWithImpl<$Res, $Val extends SeekerProfileModel>
    implements $SeekerProfileModelCopyWith<$Res> {
  _$SeekerProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SeekerProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? testAnswers = null,
    Object? calculatedScores = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      testAnswers: null == testAnswers
          ? _value.testAnswers
          : testAnswers // ignore: cast_nullable_to_non_nullable
              as List<int>,
      calculatedScores: null == calculatedScores
          ? _value.calculatedScores
          : calculatedScores // ignore: cast_nullable_to_non_nullable
              as CalculatedScoresModel,
    ) as $Val);
  }

  /// Create a copy of SeekerProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CalculatedScoresModelCopyWith<$Res> get calculatedScores {
    return $CalculatedScoresModelCopyWith<$Res>(_value.calculatedScores,
        (value) {
      return _then(_value.copyWith(calculatedScores: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SeekerProfileModelImplCopyWith<$Res>
    implements $SeekerProfileModelCopyWith<$Res> {
  factory _$$SeekerProfileModelImplCopyWith(_$SeekerProfileModelImpl value,
          $Res Function(_$SeekerProfileModelImpl) then) =
      __$$SeekerProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String description,
      List<int> testAnswers,
      CalculatedScoresModel calculatedScores});

  @override
  $CalculatedScoresModelCopyWith<$Res> get calculatedScores;
}

/// @nodoc
class __$$SeekerProfileModelImplCopyWithImpl<$Res>
    extends _$SeekerProfileModelCopyWithImpl<$Res, _$SeekerProfileModelImpl>
    implements _$$SeekerProfileModelImplCopyWith<$Res> {
  __$$SeekerProfileModelImplCopyWithImpl(_$SeekerProfileModelImpl _value,
      $Res Function(_$SeekerProfileModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SeekerProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? testAnswers = null,
    Object? calculatedScores = null,
  }) {
    return _then(_$SeekerProfileModelImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      testAnswers: null == testAnswers
          ? _value._testAnswers
          : testAnswers // ignore: cast_nullable_to_non_nullable
              as List<int>,
      calculatedScores: null == calculatedScores
          ? _value.calculatedScores
          : calculatedScores // ignore: cast_nullable_to_non_nullable
              as CalculatedScoresModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SeekerProfileModelImpl implements _SeekerProfileModel {
  const _$SeekerProfileModelImpl(
      {required this.title,
      required this.description,
      required final List<int> testAnswers,
      required this.calculatedScores})
      : _testAnswers = testAnswers;

  factory _$SeekerProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SeekerProfileModelImplFromJson(json);

  @override
  final String title;
  @override
  final String description;
  final List<int> _testAnswers;
  @override
  List<int> get testAnswers {
    if (_testAnswers is EqualUnmodifiableListView) return _testAnswers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_testAnswers);
  }

  @override
  final CalculatedScoresModel calculatedScores;

  @override
  String toString() {
    return 'SeekerProfileModel(title: $title, description: $description, testAnswers: $testAnswers, calculatedScores: $calculatedScores)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SeekerProfileModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._testAnswers, _testAnswers) &&
            (identical(other.calculatedScores, calculatedScores) ||
                other.calculatedScores == calculatedScores));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, description,
      const DeepCollectionEquality().hash(_testAnswers), calculatedScores);

  /// Create a copy of SeekerProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SeekerProfileModelImplCopyWith<_$SeekerProfileModelImpl> get copyWith =>
      __$$SeekerProfileModelImplCopyWithImpl<_$SeekerProfileModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SeekerProfileModelImplToJson(
      this,
    );
  }
}

abstract class _SeekerProfileModel implements SeekerProfileModel {
  const factory _SeekerProfileModel(
          {required final String title,
          required final String description,
          required final List<int> testAnswers,
          required final CalculatedScoresModel calculatedScores}) =
      _$SeekerProfileModelImpl;

  factory _SeekerProfileModel.fromJson(Map<String, dynamic> json) =
      _$SeekerProfileModelImpl.fromJson;

  @override
  String get title;
  @override
  String get description;
  @override
  List<int> get testAnswers;
  @override
  CalculatedScoresModel get calculatedScores;

  /// Create a copy of SeekerProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SeekerProfileModelImplCopyWith<_$SeekerProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CalculatedScoresModel _$CalculatedScoresModelFromJson(
    Map<String, dynamic> json) {
  return _CalculatedScoresModel.fromJson(json);
}

/// @nodoc
mixin _$CalculatedScoresModel {
  double get adventure => throw _privateConstructorUsedError;
  double get serenity => throw _privateConstructorUsedError;
  double get culture => throw _privateConstructorUsedError;
  double get social => throw _privateConstructorUsedError;

  /// Serializes this CalculatedScoresModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CalculatedScoresModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalculatedScoresModelCopyWith<CalculatedScoresModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalculatedScoresModelCopyWith<$Res> {
  factory $CalculatedScoresModelCopyWith(CalculatedScoresModel value,
          $Res Function(CalculatedScoresModel) then) =
      _$CalculatedScoresModelCopyWithImpl<$Res, CalculatedScoresModel>;
  @useResult
  $Res call({double adventure, double serenity, double culture, double social});
}

/// @nodoc
class _$CalculatedScoresModelCopyWithImpl<$Res,
        $Val extends CalculatedScoresModel>
    implements $CalculatedScoresModelCopyWith<$Res> {
  _$CalculatedScoresModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalculatedScoresModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? adventure = null,
    Object? serenity = null,
    Object? culture = null,
    Object? social = null,
  }) {
    return _then(_value.copyWith(
      adventure: null == adventure
          ? _value.adventure
          : adventure // ignore: cast_nullable_to_non_nullable
              as double,
      serenity: null == serenity
          ? _value.serenity
          : serenity // ignore: cast_nullable_to_non_nullable
              as double,
      culture: null == culture
          ? _value.culture
          : culture // ignore: cast_nullable_to_non_nullable
              as double,
      social: null == social
          ? _value.social
          : social // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalculatedScoresModelImplCopyWith<$Res>
    implements $CalculatedScoresModelCopyWith<$Res> {
  factory _$$CalculatedScoresModelImplCopyWith(
          _$CalculatedScoresModelImpl value,
          $Res Function(_$CalculatedScoresModelImpl) then) =
      __$$CalculatedScoresModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double adventure, double serenity, double culture, double social});
}

/// @nodoc
class __$$CalculatedScoresModelImplCopyWithImpl<$Res>
    extends _$CalculatedScoresModelCopyWithImpl<$Res,
        _$CalculatedScoresModelImpl>
    implements _$$CalculatedScoresModelImplCopyWith<$Res> {
  __$$CalculatedScoresModelImplCopyWithImpl(_$CalculatedScoresModelImpl _value,
      $Res Function(_$CalculatedScoresModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CalculatedScoresModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? adventure = null,
    Object? serenity = null,
    Object? culture = null,
    Object? social = null,
  }) {
    return _then(_$CalculatedScoresModelImpl(
      adventure: null == adventure
          ? _value.adventure
          : adventure // ignore: cast_nullable_to_non_nullable
              as double,
      serenity: null == serenity
          ? _value.serenity
          : serenity // ignore: cast_nullable_to_non_nullable
              as double,
      culture: null == culture
          ? _value.culture
          : culture // ignore: cast_nullable_to_non_nullable
              as double,
      social: null == social
          ? _value.social
          : social // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CalculatedScoresModelImpl implements _CalculatedScoresModel {
  const _$CalculatedScoresModelImpl(
      {required this.adventure,
      required this.serenity,
      required this.culture,
      required this.social});

  factory _$CalculatedScoresModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CalculatedScoresModelImplFromJson(json);

  @override
  final double adventure;
  @override
  final double serenity;
  @override
  final double culture;
  @override
  final double social;

  @override
  String toString() {
    return 'CalculatedScoresModel(adventure: $adventure, serenity: $serenity, culture: $culture, social: $social)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalculatedScoresModelImpl &&
            (identical(other.adventure, adventure) ||
                other.adventure == adventure) &&
            (identical(other.serenity, serenity) ||
                other.serenity == serenity) &&
            (identical(other.culture, culture) || other.culture == culture) &&
            (identical(other.social, social) || other.social == social));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, adventure, serenity, culture, social);

  /// Create a copy of CalculatedScoresModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalculatedScoresModelImplCopyWith<_$CalculatedScoresModelImpl>
      get copyWith => __$$CalculatedScoresModelImplCopyWithImpl<
          _$CalculatedScoresModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CalculatedScoresModelImplToJson(
      this,
    );
  }
}

abstract class _CalculatedScoresModel implements CalculatedScoresModel {
  const factory _CalculatedScoresModel(
      {required final double adventure,
      required final double serenity,
      required final double culture,
      required final double social}) = _$CalculatedScoresModelImpl;

  factory _CalculatedScoresModel.fromJson(Map<String, dynamic> json) =
      _$CalculatedScoresModelImpl.fromJson;

  @override
  double get adventure;
  @override
  double get serenity;
  @override
  double get culture;
  @override
  double get social;

  /// Create a copy of CalculatedScoresModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalculatedScoresModelImplCopyWith<_$CalculatedScoresModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
