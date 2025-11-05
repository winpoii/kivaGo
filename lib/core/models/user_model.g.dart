// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      fcmToken: json['fcmToken'] as String,
      seekerProfile: SeekerProfileModel.fromJson(
          json['seekerProfile'] as Map<String, dynamic>),
      username: json['username'] as String? ?? '',
      country: json['country'] as String? ?? '',
      city: json['city'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'fcmToken': instance.fcmToken,
      'seekerProfile': instance.seekerProfile,
      'username': instance.username,
      'country': instance.country,
      'city': instance.city,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

_$SeekerProfileModelImpl _$$SeekerProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SeekerProfileModelImpl(
      title: json['title'] as String,
      description: json['description'] as String,
      testAnswers: (json['testAnswers'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      calculatedScores: CalculatedScoresModel.fromJson(
          json['calculatedScores'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SeekerProfileModelImplToJson(
        _$SeekerProfileModelImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'testAnswers': instance.testAnswers,
      'calculatedScores': instance.calculatedScores,
    };

_$CalculatedScoresModelImpl _$$CalculatedScoresModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CalculatedScoresModelImpl(
      adventure: (json['adventure'] as num).toDouble(),
      serenity: (json['serenity'] as num).toDouble(),
      culture: (json['culture'] as num).toDouble(),
      social: (json['social'] as num).toDouble(),
    );

Map<String, dynamic> _$$CalculatedScoresModelImplToJson(
        _$CalculatedScoresModelImpl instance) =>
    <String, dynamic>{
      'adventure': instance.adventure,
      'serenity': instance.serenity,
      'culture': instance.culture,
      'social': instance.social,
    };
