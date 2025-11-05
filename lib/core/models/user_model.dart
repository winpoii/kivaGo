import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/timestamp_converter.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User model for Firestore users collection
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String email,
    required String displayName,
    required String photoUrl,
    @TimestampConverter() required DateTime createdAt,
    required String fcmToken,
    required SeekerProfileModel seekerProfile,
    @Default('') String username,
    @Default('') String country,
    @Default('') String city,
    @Default('') String firstName,
    @Default('') String lastName,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

/// Seeker profile model for user's travel personality
@freezed
class SeekerProfileModel with _$SeekerProfileModel {
  const factory SeekerProfileModel({
    required String title,
    required String description,
    required List<int> testAnswers,
    required CalculatedScoresModel calculatedScores,
  }) = _SeekerProfileModel;

  factory SeekerProfileModel.fromJson(Map<String, dynamic> json) =>
      _$SeekerProfileModelFromJson(json);
}

/// Calculated scores from personality test
@freezed
class CalculatedScoresModel with _$CalculatedScoresModel {
  const factory CalculatedScoresModel({
    required double adventure,
    required double serenity,
    required double culture,
    required double social,
  }) = _CalculatedScoresModel;

  factory CalculatedScoresModel.fromJson(Map<String, dynamic> json) =>
      _$CalculatedScoresModelFromJson(json);
}
