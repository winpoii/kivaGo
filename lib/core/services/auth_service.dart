import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';
import 'quiz_check_service.dart';

/// Authentication service for handling Google Sign-In and Firebase Auth
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late final QuizCheckService _quizCheckService;

  AuthService() {
    _quizCheckService = QuizCheckService(this);
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential = await _auth.signInWithCredential(credential);

      // Create or update user in Firestore
      if (userCredential.user != null) {
        await _createOrUpdateUserInFirestore(userCredential.user!);
      }

      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  /// Sign up with email and password
  Future<UserCredential> signUpWithEmailPassword(
    String email,
    String password, {
    String? firstName,
    String? lastName,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update Firebase Auth user profile with displayName
      if (userCredential.user != null && firstName != null && lastName != null) {
        final displayName = '$firstName $lastName'.trim();
        if (displayName.isNotEmpty) {
          await userCredential.user!.updateDisplayName(displayName);
          await userCredential.user!.reload();
        }
      }

      // Create user in Firestore
      if (userCredential.user != null) {
        await _createOrUpdateUserInFirestore(
          userCredential.user!,
          firstName: firstName,
          lastName: lastName,
        );
      }

      return userCredential;
    } catch (e) {
      print('Error signing up with email/password: $e');
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<UserCredential> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user in Firestore (for FCM token, last login, etc.)
      if (userCredential.user != null) {
        await _createOrUpdateUserInFirestore(userCredential.user!);
      }

      return userCredential;
    } catch (e) {
      print('Error signing in with email/password: $e');
      rethrow;
    }
  }

  /// Create or update user in Firestore
  Future<void> _createOrUpdateUserInFirestore(
    User firebaseUser, {
    String? firstName,
    String? lastName,
  }) async {
    try {
      // Check if user already exists in Firestore
      final existingUser = await FirestoreService.getUser(firebaseUser.uid);

      if (existingUser != null) {
        // Update existing user with latest info
        print('🔄 Updating existing user in Firestore: ${firebaseUser.uid}');
        final updatedUser = existingUser.copyWith(
          email: firebaseUser.email ?? existingUser.email,
          displayName: firebaseUser.displayName ?? existingUser.displayName,
          photoUrl: firebaseUser.photoURL ?? existingUser.photoUrl,
          firstName: firstName ?? existingUser.firstName,
          lastName: lastName ?? existingUser.lastName,
        );
        await FirestoreService.updateUser(firebaseUser.uid, updatedUser);
        print('✅ User updated successfully in Firestore');
      } else {
        // Create new user
        // Build displayName from firstName and lastName if provided
        String displayName = firebaseUser.displayName ?? '';
        if (displayName.isEmpty && firstName != null && lastName != null) {
          displayName = '$firstName $lastName'.trim();
        }
        if (displayName.isEmpty) {
          displayName = 'User';
        }

        final newUser = UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: displayName,
          photoUrl: firebaseUser.photoURL ?? '',
          createdAt: DateTime.now(),
          fcmToken: '', // Will be updated when FCM token is available
          username: '', // Will be set by user
          country: '', // Will be set by user
          city: '', // Will be set by user
          firstName: firstName ?? '',
          lastName: lastName ?? '',
          seekerProfile: SeekerProfileModel(
            title: 'Yeni Gezgin',
            description: 'Seyahat kişiliğini keşfetmeye hazır!',
            testAnswers: [],
            calculatedScores: CalculatedScoresModel(
              adventure: 0.0,
              serenity: 0.0,
              culture: 0.0,
              social: 0.0,
            ),
          ),
        );
        print('🔄 Creating new user in Firestore: ${firebaseUser.uid}');
        print('🔄 User data: firstName=$firstName, lastName=$lastName, displayName=$displayName');
        await FirestoreService.createUser(newUser);
        print('✅ User created successfully in Firestore');
        // Note: Travel plans will be created when AI suggests a plan and user accepts it
      }
    } catch (e, stackTrace) {
      print('❌ Error creating/updating user in Firestore: $e');
      print('❌ Stack trace: $stackTrace');
      // Rethrow to make errors visible - user should know if Firestore save fails
      rethrow;
    }
  }

  /// Get current user from Firestore
  Future<UserModel?> getCurrentUserFromFirestore() async {
    final firebaseUser = currentUser;
    if (firebaseUser == null) return null;

    try {
      return await FirestoreService.getUser(firebaseUser.uid);
    } catch (e) {
      print('Error getting user from Firestore: $e');
      return null;
    }
  }

  /// Update user's seeker profile
  Future<void> updateSeekerProfile(SeekerProfileModel profile) async {
    final firebaseUser = currentUser;
    if (firebaseUser == null) throw Exception('User not authenticated');

    try {
      await FirestoreService.updateUserProfile(firebaseUser.uid, profile);
    } catch (e) {
      print('Error updating seeker profile: $e');
      rethrow;
    }
  }

  /// Update FCM token
  Future<void> updateFcmToken(String fcmToken) async {
    final firebaseUser = currentUser;
    if (firebaseUser == null) return;

    try {
      final user = await FirestoreService.getUser(firebaseUser.uid);
      if (user != null) {
        final updatedUser = user.copyWith(fcmToken: fcmToken);
        await FirestoreService.updateUser(firebaseUser.uid, updatedUser);
      }
    } catch (e) {
      print('Error updating FCM token: $e');
      // Don't rethrow - FCM token update is not critical
    }
  }

  /// Update user account information
  Future<void> updateUserAccountInfo({
    String? displayName,
    String? username,
    String? country,
    String? city,
  }) async {
    final firebaseUser = currentUser;
    if (firebaseUser == null) throw Exception('User not authenticated');

    try {
      // Build update map with only the fields that need to be updated
      final updateData = <String, dynamic>{};
      
      if (displayName != null) {
        updateData['displayName'] = displayName;
      }
      if (username != null) {
        updateData['username'] = username;
      }
      if (country != null) {
        updateData['country'] = country;
      }
      if (city != null) {
        updateData['city'] = city;
      }

      if (updateData.isEmpty) {
        return; // Nothing to update
      }

      // Use update() instead of set() to only update specific fields
      await FirestoreService.updateUserFields(firebaseUser.uid, updateData);
    } catch (e) {
      print('Error updating user account info: $e');
      rethrow;
    }
  }

  /// Check if current user has completed quiz
  Future<bool> hasUserCompletedQuiz() async {
    return await _quizCheckService.hasUserCompletedQuiz();
  }

  /// Get user's travel personality title
  Future<String> getUserTravelPersonalityTitle() async {
    return await _quizCheckService.getUserTravelPersonalityTitle();
  }

  /// Get user's travel personality description
  Future<String> getUserTravelPersonalityDescription() async {
    return await _quizCheckService.getUserTravelPersonalityDescription();
  }

}
