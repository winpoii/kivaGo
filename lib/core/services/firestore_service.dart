import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/travel_plan_model.dart';
import '../models/match_model.dart';

/// Firestore service for database operations
class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  static const String _usersCollection = 'users';
  static const String _travelPlansCollection = 'travelPlans';
  static const String _matchesCollection = 'matches';

  /// User Operations
  /// ===============

  /// Create a new user document
  static Future<void> createUser(UserModel user) async {
    try {
      print('🔥 Firestore: Creating user document for ${user.uid}');
      
      // Manually serialize nested models for Firestore compatibility
      final userJson = user.toJson();
      
      // Calculate scores'i manuel olarak Map'e çeviriyoruz
      final calculatedScoresJson = <String, dynamic>{
        'adventure': user.seekerProfile.calculatedScores.adventure,
        'serenity': user.seekerProfile.calculatedScores.serenity,
        'culture': user.seekerProfile.calculatedScores.culture,
        'social': user.seekerProfile.calculatedScores.social,
      };
      
      // SeekerProfile'i manuel olarak oluşturuyoruz
      final seekerProfileJson = <String, dynamic>{
        'title': user.seekerProfile.title,
        'description': user.seekerProfile.description,
        'testAnswers': user.seekerProfile.testAnswers,
        'calculatedScores': calculatedScoresJson,
      };
      
      // User JSON'a seekerProfile'i ekliyoruz
      userJson['seekerProfile'] = seekerProfileJson;
      
      print('🔥 Firestore: User data keys: ${userJson.keys.toList()}');
      print('🔥 Firestore: SeekerProfile is Map: ${userJson['seekerProfile'] is Map}');
      print('🔥 Firestore: CalculatedScores is Map: ${seekerProfileJson['calculatedScores'] is Map}');

      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .set(userJson);

      print('🔥 Firestore: User document created successfully');
    } catch (e) {
      print('🔥 Firestore: Error creating user: $e');
      print('🔥 Firestore: Error type: ${e.runtimeType}');
      print('🔥 Firestore: Stack trace: ${StackTrace.current}');
      throw Exception('Failed to create user: $e');
    }
  }

  /// Get user by UID
  static Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// Update user document
  static Future<void> updateUser(String uid, UserModel user) async {
    try {
      // Manually serialize nested models for Firestore compatibility
      final userJson = user.toJson();
      
      // Calculate scores'i manuel olarak Map'e çeviriyoruz
      final calculatedScoresJson = <String, dynamic>{
        'adventure': user.seekerProfile.calculatedScores.adventure,
        'serenity': user.seekerProfile.calculatedScores.serenity,
        'culture': user.seekerProfile.calculatedScores.culture,
        'social': user.seekerProfile.calculatedScores.social,
      };
      
      // SeekerProfile'i manuel olarak oluşturuyoruz
      final seekerProfileJson = <String, dynamic>{
        'title': user.seekerProfile.title,
        'description': user.seekerProfile.description,
        'testAnswers': user.seekerProfile.testAnswers,
        'calculatedScores': calculatedScoresJson,
      };
      
      // User JSON'a seekerProfile'i ekliyoruz
      userJson['seekerProfile'] = seekerProfileJson;
      
      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .set(userJson, SetOptions(merge: true));
    } catch (e) {
      print('🔥 Firestore: Error updating user: $e');
      throw Exception('Failed to update user: $e');
    }
  }

  /// Update specific user fields (doesn't touch nested objects like seekerProfile)
  static Future<void> updateUserFields(String uid, Map<String, dynamic> fields) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .update(fields);
    } catch (e) {
      throw Exception('Failed to update user fields: $e');
    }
  }

  /// Update user's seeker profile
  static Future<void> updateUserProfile(
      String uid, SeekerProfileModel profile) async {
    try {
      print('🔥 Firestore: Updating seeker profile for user: $uid');
      print('🔥 Firestore: Profile calculatedScores type: ${profile.calculatedScores.runtimeType}');
      
      // Manually serialize nested models for Firestore compatibility
      // Build the profile JSON manually to ensure all nested models are serialized
      // Calculate scores'i manuel olarak Map'e çeviriyoruz
      final calculatedScoresJson = <String, dynamic>{
        'adventure': profile.calculatedScores.adventure,
        'serenity': profile.calculatedScores.serenity,
        'culture': profile.calculatedScores.culture,
        'social': profile.calculatedScores.social,
      };
      
      final profileJson = <String, dynamic>{
        'title': profile.title,
        'description': profile.description,
        'testAnswers': profile.testAnswers,
        'calculatedScores': calculatedScoresJson, // Manuel olarak oluşturulmuş Map
      };
      
      print('🔥 Firestore: Profile keys: ${profileJson.keys.toList()}');
      print('🔥 Firestore: CalculatedScores is Map: ${profileJson['calculatedScores'] is Map}');
      print('🔥 Firestore: CalculatedScores values: ${calculatedScoresJson}');
      
      await _firestore.collection(_usersCollection).doc(uid).update({
        'seekerProfile': profileJson,
      });
      
      print('🔥 Firestore: Seeker profile updated successfully');
    } catch (e) {
      print('🔥 Firestore: Error updating seeker profile: $e');
      print('🔥 Firestore: Error type: ${e.runtimeType}');
      print('🔥 Firestore: Stack trace: ${StackTrace.current}');
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Delete user document
  static Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  /// Travel Plan Operations
  /// ======================

  /// Create a new travel plan
  static Future<String> createTravelPlan(TravelPlanModel travelPlan) async {
    try {
      print('🔥 Firestore: Starting createTravelPlan process...');

      // Generate a new document ID if planId is empty
      final planId = travelPlan.planId.isEmpty
          ? _firestore.collection(_travelPlansCollection).doc().id
          : travelPlan.planId;

      print('🔥 Firestore: Generated planId: $planId');
      print('🔥 Firestore: Collection name: $_travelPlansCollection');

      // Update the travel plan with the generated ID
      print('🔥 Firestore: Creating copyWith planId...');
      final travelPlanWithId = travelPlan.copyWith(planId: planId);

      print('🔥 Firestore: Converting to JSON...');
      final travelPlanJson = travelPlanWithId.toJson();

      print('🔥 Firestore: JSON conversion successful');
      print(
          '🔥 Firestore: Travel plan data keys: ${travelPlanJson.keys.toList()}');
      print(
          '🔥 Firestore: Suggested route type: ${travelPlanJson['suggestedRoute'].runtimeType}');

      print('🔥 Firestore: Writing to Firestore...');
      await _firestore
          .collection(_travelPlansCollection)
          .doc(planId)
          .set(travelPlanJson);

      print('🔥 Firestore: Travel plan document created successfully');
      return planId;
    } catch (e) {
      print('🔥 Firestore: Error creating travel plan: $e');
      print('🔥 Firestore: Error type: ${e.runtimeType}');
      print('🔥 Firestore: Stack trace: ${StackTrace.current}');
      throw Exception('Failed to create travel plan: $e');
    }
  }

  /// Get travel plan by ID
  static Future<TravelPlanModel?> getTravelPlan(String planId) async {
    try {
      final doc =
          await _firestore.collection(_travelPlansCollection).doc(planId).get();

      if (doc.exists && doc.data() != null) {
        return TravelPlanModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get travel plan: $e');
    }
  }

  /// Get travel plans by user ID
  static Future<List<TravelPlanModel>> getTravelPlansByUser(
      String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_travelPlansCollection)
          .where('ownerId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => TravelPlanModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('🔥 Firestore: Error getting travel plans by user: $e');
      return [];
    }
  }

  /// Get all travel plans for a user
  static Future<List<TravelPlanModel>> getUserTravelPlans(
      String ownerId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_travelPlansCollection)
          .where('ownerId', isEqualTo: ownerId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => TravelPlanModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user travel plans: $e');
    }
  }

  /// Update travel plan
  static Future<void> updateTravelPlan(
      String planId, TravelPlanModel travelPlan) async {
    try {
      await _firestore
          .collection(_travelPlansCollection)
          .doc(planId)
          .set(travelPlan.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update travel plan: $e');
    }
  }

  /// Add conversation to travel plan
  static Future<void> addConversationToTravelPlan(
    String planId,
    AiConversationItemModel conversation,
  ) async {
    try {
      final doc =
          await _firestore.collection(_travelPlansCollection).doc(planId).get();

      if (doc.exists && doc.data() != null) {
        final travelPlan = TravelPlanModel.fromJson(doc.data()!);
        final updatedConversations = [
          ...travelPlan.aiConversationHistory,
          conversation
        ];

        final updatedPlan = travelPlan.copyWith(
          aiConversationHistory: updatedConversations,
          updatedAt: DateTime.now(),
        );

        await _firestore
            .collection(_travelPlansCollection)
            .doc(planId)
            .set(updatedPlan.toJson());
      }
    } catch (e) {
      throw Exception('Failed to add conversation: $e');
    }
  }

  /// Delete travel plan
  static Future<void> deleteTravelPlan(String planId) async {
    try {
      await _firestore.collection(_travelPlansCollection).doc(planId).delete();
    } catch (e) {
      throw Exception('Failed to delete travel plan: $e');
    }
  }

  /// Match Operations
  /// ================

  /// Create a new match
  static Future<void> createMatch(MatchModel match) async {
    try {
      print('🔥 Firestore: Creating match document for ${match.matchId}');
      final matchJson = match.toJson();
      print('🔥 Firestore: Match data keys: ${matchJson.keys.toList()}');

      await _firestore
          .collection(_matchesCollection)
          .doc(match.matchId)
          .set(matchJson);

      print('🔥 Firestore: Match document created successfully');
    } catch (e) {
      print('🔥 Firestore: Error creating match: $e');
      throw Exception('Failed to create match: $e');
    }
  }

  /// Get match by ID
  static Future<MatchModel?> getMatch(String matchId) async {
    try {
      final doc =
          await _firestore.collection(_matchesCollection).doc(matchId).get();

      if (doc.exists && doc.data() != null) {
        return MatchModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get match: $e');
    }
  }

  /// Get matches for a user
  static Future<List<MatchModel>> getUserMatches(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_matchesCollection)
          .where('users', arrayContains: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => MatchModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user matches: $e');
    }
  }

  /// Update match status
  static Future<void> updateMatchStatus(String matchId, String status) async {
    try {
      await _firestore.collection(_matchesCollection).doc(matchId).update({
        'status': status,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Failed to update match status: $e');
    }
  }

  /// Delete match
  static Future<void> deleteMatch(String matchId) async {
    try {
      await _firestore.collection(_matchesCollection).doc(matchId).delete();
    } catch (e) {
      throw Exception('Failed to delete match: $e');
    }
  }

  /// Utility Methods
  /// ===============

  /// Check if user exists
  static Future<bool> userExists(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();
      return doc.exists;
    } catch (e) {
      throw Exception('Failed to check user existence: $e');
    }
  }

  /// Get real-time user stream
  static Stream<UserModel?> getUserStream(String uid) {
    return _firestore
        .collection(_usersCollection)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    });
  }

  /// Get real-time travel plans stream for user
  static Stream<List<TravelPlanModel>> getUserTravelPlansStream(
      String ownerId) {
    return _firestore
        .collection(_travelPlansCollection)
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => TravelPlanModel.fromJson(doc.data()))
            .toList());
  }

  /// Batch operations
  static Future<void> batchWrite(List<Map<String, dynamic>> operations) async {
    try {
      final batch = _firestore.batch();

      for (final operation in operations) {
        final type = operation['type'] as String;
        final collection = operation['collection'] as String;
        final docId = operation['docId'] as String;
        final data = operation['data'] as Map<String, dynamic>?;

        final docRef = _firestore.collection(collection).doc(docId);

        switch (type) {
          case 'set':
            batch.set(docRef, data!);
            break;
          case 'update':
            batch.update(docRef, data!);
            break;
          case 'delete':
            batch.delete(docRef);
            break;
        }
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to execute batch write: $e');
    }
  }
}
