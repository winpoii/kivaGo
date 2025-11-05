import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../core/models/user_model.dart';
import '../quiz/quiz_intro_page.dart';
import '../settings/account_detail.dart';

/// Profile page
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  String _travelPersonalityTitle = 'Yeni Gezgin';
  bool _hasCompletedQuiz = false;
  bool _isLoading = true;
  int _totalTravelPlans = 0;
  int _completedTravels = 0;
  int _totalCountries = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Load current user data from Firestore
      final user = await _authService.getCurrentUserFromFirestore();
      final hasCompleted = await _authService.hasUserCompletedQuiz();
      final title = await _authService.getUserTravelPersonalityTitle();
      
      // Load travel statistics
      if (user != null) {
        final travelPlans = await FirestoreService.getTravelPlansByUser(user.uid);
        final completedTravels = travelPlans.where((plan) => plan.status == 'completed').length;
        
        // Count unique countries from completed travels
        final Set<String> uniqueCountries = {};
        for (final plan in travelPlans) {
          if (plan.status == 'completed') {
            for (final route in plan.suggestedRoute) {
              uniqueCountries.add(route.locationName);
            }
          }
        }

        if (mounted) {
          setState(() {
            _currentUser = user;
            _hasCompletedQuiz = hasCompleted;
            _travelPersonalityTitle = title;
            _totalTravelPlans = travelPlans.length;
            _completedTravels = completedTravels;
            _totalCountries = uniqueCountries.length;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Error loading user data: $e');
    }
  }


  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFC11336).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFFC11336).withOpacity(0.7),
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFDEB89A),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Avatar
                    Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDEB89A),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: _currentUser?.photoUrl.isNotEmpty == true
                                ? DecorationImage(
                                    image: NetworkImage(_currentUser!.photoUrl),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: NetworkImage(
                                      'https://ui-avatars.com/api/?name=${Uri.encodeComponent(_currentUser?.displayName ?? 'User')}&size=200&background=DEB89A&color=fff',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Name
                    Text(
                      _currentUser?.displayName ?? 'User',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Travel Personality Type (Dynamic from database)
                    if (_isLoading)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Yükleniyor...',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (_hasCompletedQuiz)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCF3F6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '🗺️',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _travelPersonalityTitle,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFFC11336),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const QuizIntroPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC11336).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFC11336).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                '🧭',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Testi Çöz',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFFC11336),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: const Color(0xFFC11336).withOpacity(0.7),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Edit Profile Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AccountDetailPage(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFFCF3F6),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Profili Düzenle',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // About Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hakkında',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Dünyayı keşfetmeyi seven bir gezgin. Yeni kültürler, lezzetler ve deneyimler peşinde koşan bir maceraperest. Seyahat etmek benim için sadece bir hobi değil, yaşam tarzı! ✈️🌍',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Travel Statistics
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF8F9FA), Color(0xFFFCF3F6)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFC11336).withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC11336).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.analytics_outlined,
                                  color: Color(0xFFC11336),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Seyahat İstatistikleri',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C2C2C),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Toplam Plan',
                                  _totalTravelPlans.toString(),
                                  Icons.travel_explore_outlined,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  'Tamamlanan',
                                  _completedTravels.toString(),
                                  Icons.check_circle_outline,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  'Ziyaret Edilen',
                                  _totalCountries.toString(),
                                  Icons.public_outlined,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
