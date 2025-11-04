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
  /// Returns AI response text
  Future<String> sendMessage({
    required String userId,
    required String messageContent,
  }) async {
    try {
      print('🚀 Sending message to n8n webhook...');
      print('📡 Webhook URL: ${AppConfig.webhookUrl}');
      print('💬 Message: $messageContent');
      print('👤 User ID: $userId');

      // Prepare request body for POST request (no planId)
      final requestData = <String, dynamic>{
        'userId': userId,
        'messageContent': messageContent,
      };

      print('📤 Request body: $requestData');
      print('📋 Headers: ${AppConfig.webhookHeaders}');
      print('🌐 Webhook URL: ${AppConfig.webhookUrl}');
      print('📡 Sending POST request to n8n webhook...');
      print('   - Method: POST');
      print('   - URL: ${AppConfig.webhookUrl}');
      print('   - Body: ${requestData.toString()}');

      // Send HTTP POST request to n8n webhook
      final response = await _dio.post(
        AppConfig.webhookUrl,
        data: requestData,
        options: Options(
          headers: AppConfig.webhookHeaders,
          sendTimeout: Duration(seconds: AppConfig.apiTimeoutSeconds),
          receiveTimeout: Duration(seconds: AppConfig.apiTimeoutSeconds),
          // Validate status codes - allow 200, 201, 202
          validateStatus: (status) =>
              status != null && status >= 200 && status < 300,
        ),
      );

      print('✅ n8n webhook response: ${response.statusCode}');
      print('📥 Response data (RAW): ${response.data}');
      print('📥 Response data type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        // Extract AI response from n8n
        final responseData = response.data;

        // Try different possible response formats
        String aiResponse = '';

        if (responseData is Map) {
          // Try common n8n response formats
          if (responseData.containsKey('output')) {
            aiResponse = responseData['output'].toString();
            print('📝 Found AI response in "output" field');
          } else if (responseData.containsKey('aiResponse')) {
            aiResponse = responseData['aiResponse'].toString();
            print('📝 Found AI response in "aiResponse" field');
          } else if (responseData.containsKey('text')) {
            aiResponse = responseData['text'].toString();
            print('📝 Found AI response in "text" field');
          } else if (responseData.containsKey('message')) {
            aiResponse = responseData['message'].toString();
            print('📝 Found AI response in "message" field');
          } else {
            // If no known field, try to get any text value
            aiResponse = responseData.values.first.toString();
            print('⚠️ Using first value as AI response');
          }
        } else if (responseData is String) {
          aiResponse = responseData;
          print('📝 Response is direct string');
        }

        if (aiResponse.isEmpty) {
          print('⚠️ AI response is empty! Full response: $responseData');
          aiResponse = 'AI yanıtı alındı ancak içerik boş.';
        }

        print('🎉 AI Response extracted: $aiResponse');
        return aiResponse;
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Dio error: ${e.message}');
      print('❌ Error type: ${e.type}');
      if (e.response != null) {
        print('❌ Response status: ${e.response?.statusCode}');
        print('❌ Response data: ${e.response?.data}');
        print('❌ Response headers: ${e.response?.headers}');
      }
      print('❌ Request URL: ${e.requestOptions.uri}');
      print('❌ Request method: ${e.requestOptions.method}');
      print('❌ Request headers: ${e.requestOptions.headers}');

      // Daha açıklayıcı hata mesajı
      String errorMessage = 'Network error: ${e.message}';

      if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Bağlantı hatası: n8n sunucusuna ulaşılamıyor.\n'
            'Lütfen kontrol edin:\n'
            '1. n8n çalışıyor mu? (http://localhost:5678)\n'
            '2. Android emulator kullanıyorsanız localhost yerine 10.0.2.2 kullanın\n'
            '3. Webhook aktif mi?\n'
            '4. Firewall engelliyor mu?';
      } else if (e.response != null && e.response!.statusCode == 404) {
        errorMessage = 'Webhook bulunamadı (404).\n'
            'Lütfen n8n webhook URL\'sinin doğru olduğundan ve webhook\'un aktif olduğundan emin olun.';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Bağlantı zaman aşımı. n8n sunucusu yanıt vermiyor.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Yanıt zaman aşımı. n8n sunucusu yanıt vermiyor.';
      }

      throw Exception(errorMessage);
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
