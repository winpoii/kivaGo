// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TravelPlanModelImpl _$$TravelPlanModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TravelPlanModelImpl(
      planId: json['planId'] as String,
      ownerId: json['ownerId'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp),
      experienceManifesto: json['experienceManifesto'] as String,
      moodKeywords: (json['moodKeywords'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      suggestedRoute: (json['suggestedRoute'] as List<dynamic>)
          .map((e) =>
              SuggestedRouteItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      aiConversationHistory: (json['aiConversationHistory'] as List<dynamic>)
          .map((e) =>
              AiConversationItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TravelPlanModelImplToJson(
        _$TravelPlanModelImpl instance) =>
    <String, dynamic>{
      'planId': instance.planId,
      'ownerId': instance.ownerId,
      'title': instance.title,
      'status': instance.status,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'experienceManifesto': instance.experienceManifesto,
      'moodKeywords': instance.moodKeywords,
      'suggestedRoute': instance.suggestedRoute,
      'aiConversationHistory': instance.aiConversationHistory,
    };

_$SuggestedRouteItemModelImpl _$$SuggestedRouteItemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SuggestedRouteItemModelImpl(
      locationName: json['locationName'] as String,
      durationDays: (json['durationDays'] as num).toInt(),
      reasoning: json['reasoning'] as String,
      activities: (json['activities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$SuggestedRouteItemModelImplToJson(
        _$SuggestedRouteItemModelImpl instance) =>
    <String, dynamic>{
      'locationName': instance.locationName,
      'durationDays': instance.durationDays,
      'reasoning': instance.reasoning,
      'activities': instance.activities,
    };

_$AiConversationItemModelImpl _$$AiConversationItemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AiConversationItemModelImpl(
      role: json['role'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$$AiConversationItemModelImplToJson(
        _$AiConversationItemModelImpl instance) =>
    <String, dynamic>{
      'role': instance.role,
      'content': instance.content,
    };
