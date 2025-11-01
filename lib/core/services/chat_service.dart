import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/app_config.dart';
import '../models/travel_plan_model.dart';
import 'firestore_service.dart';

/// Service for handling AI chat interactions via n8n webhook
class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final Dio _dio = Dio();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Send message to AI via n8n webhook
  /// Returns the planId (either existing or newly created)
  Future<String> sendMessage({
    required String userId,
    required String messageContent,
    String? planId, // Optional - null for new conversations
  }) async {
    try {
      print('🚀 Sending message to n8n webhook...');
      print('📡 Webhook URL: ${AppConfig.webhookUrl}');
      print('💬 Message: $messageContent');
      print('👤 User ID: $userId');
      print('📋 Plan ID: ${planId ?? "NEW CONVERSATION"}');

      // Prepare request data based on conversation type
      final requestData = <String, dynamic>{
        'userId': userId,
        'messageContent': messageContent,
      };

      // Add planId only if it exists (continuing conversation)
      // If null, n8n will handle creating a new conversation
      if (planId != null && planId.isNotEmpty) {
        requestData['planId'] = planId;
        print('🔄 Continuing existing conversation');
      } else {
        print('🆕 Starting new conversation - no planId');
      }

      print('📤 Request data: $requestData');
      print('📋 Headers: ${AppConfig.webhookHeaders}');

      // Send HTTP POST request to n8n webhook
      final response = await _dio.post(
        AppConfig.webhookUrl,
        data: requestData,
        options: Options(
          headers: AppConfig.webhookHeaders,
          sendTimeout: Duration(seconds: AppConfig.apiTimeoutSeconds),
          receiveTimeout: Duration(seconds: AppConfig.apiTimeoutSeconds),
        ),
      );

      print('✅ n8n webhook response: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      if (response.statusCode == 200) {
        // Extract planId from response
        final responseData = response.data;
        final returnedPlanId = responseData['planId'] as String?;

        if (returnedPlanId != null && returnedPlanId.isNotEmpty) {
          print('🎉 Message sent successfully! Plan ID: $returnedPlanId');
          return returnedPlanId;
        } else {
          throw Exception('No planId returned from n8n');
        }
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Dio error: ${e.message}');
      if (e.response != null) {
        print('❌ Response data: ${e.response?.data}');
        print('❌ Response status: ${e.response?.statusCode}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('❌ Unexpected error: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  /// Create a new travel plan conversation
  Future<String> createNewTravelPlan({
    required String userId,
    required String title,
    required String experienceManifesto,
    required List<String> moodKeywords,
  }) async {
    try {
      print('🚀 Creating new travel plan...');

      // Create new travel plan document
      final travelPlan = TravelPlanModel(
        planId: '', // Will be set by Firestore
        ownerId: userId,
        title: title,
        status: 'planning',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        experienceManifesto: experienceManifesto,
        moodKeywords: moodKeywords,
        suggestedRoute: [],
        aiConversationHistory: [
          AiConversationItemModel(
            role: 'ai',
            content:
                'Merhaba! Seninle birlikte harika bir seyahat planı oluşturalım. Nasıl hissetmek istersin bu seyahatte?',
          ),
        ],
      );

      final planId = await FirestoreService.createTravelPlan(travelPlan);
      print('✅ Travel plan created with ID: $planId');
      return planId;
    } catch (e) {
      print('❌ Error creating travel plan: $e');
      throw Exception('Failed to create travel plan: $e');
    }
  }

  /// Get travel plan conversation stream
  Stream<TravelPlanModel?> getTravelPlanStream(String planId) {
    return _firestore
        .collection('travelPlans')
        .doc(planId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        data['planId'] = snapshot.id;
        return TravelPlanModel.fromJson(data);
      }
      return null;
    });
  }

  /// Get user's travel plans
  Future<List<TravelPlanModel>> getUserTravelPlans(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('travelPlans')
          .where('ownerId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['planId'] = doc.id;
        return TravelPlanModel.fromJson(data);
      }).toList();
    } catch (e) {
      print('❌ Error getting user travel plans: $e');
      return [];
    }
  }

  /// Delete travel plan
  Future<void> deleteTravelPlan(String planId) async {
    try {
      await _firestore.collection('travelPlans').doc(planId).delete();
      print('✅ Travel plan deleted: $planId');
    } catch (e) {
      print('❌ Error deleting travel plan: $e');
      throw Exception('Failed to delete travel plan: $e');
    }
  }
}
