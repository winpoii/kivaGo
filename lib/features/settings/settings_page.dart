import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../auth/signup_page.dart';
import 'account_detail.dart';

/// Settings page
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _showSignOutDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Sign Out',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF999999)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC11336),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (result == true) {
      _signOut();
    }
  }

  Future<void> _signOut() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignUpPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign out failed: ${e.toString()}'),
            backgroundColor: const Color(0xFFC11336),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
          'Ayarlar',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Section
              const Text(
                'Hesap',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              _buildSettingsItem(
                icon: Icons.person_outline,
                title: 'Hesap Detayları',
                subtitle: 'Hesap bilgilerinizi yönetin',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AccountDetailPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              _buildSettingsItem(
                icon: Icons.lock_outline,
                title: 'Şifre Değiştir',
                subtitle: 'Şifrenizi değiştirin',
                onTap: () {},
              ),

              const SizedBox(height: 32),

              // Debug Section - Currently disabled
              // if (kDebugMode) // Only show in debug mode
              //   Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const Text(
              //         'Geliştirici Araçları',
              //         style: TextStyle(
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.black,
              //         ),
              //       ),
              //       const SizedBox(height: 16),
              //       _buildSettingsItem(
              //         icon: Icons.bug_report_outlined,
              //         title: 'Firestore Test (Users)',
              //         subtitle: 'Kullanıcı veritabanı bağlantısını test et',
              //         onTap: () {
              //           Navigator.of(context).push(
              //             MaterialPageRoute(
              //               builder: (context) => const FirestoreTestPage(),
              //             ),
              //           );
              //         },
              //       ),
              //       const SizedBox(height: 32),
              //     ],
              //   ),

              // Preferences Section
              const Text(
                'Tercihler',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              _buildSettingsItem(
                icon: Icons.settings_outlined,
                title: 'Uygulama Tercihleri',
                subtitle: 'Deneyiminizi özelleştirin',
                onTap: () {},
              ),

              const SizedBox(height: 12),

              _buildSettingsItem(
                icon: Icons.notifications_outlined,
                title: 'Bildirimler',
                subtitle: 'Bildirimlerinizi yönetin',
                onTap: () {},
              ),

              const SizedBox(height: 32),

              // Support Section
              const Text(
                'Destek',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              _buildSettingsItem(
                icon: Icons.help_outline,
                title: 'Yardım Merkezi',
                subtitle: 'Yardım ve destek alın',
                onTap: () {},
              ),

              const SizedBox(height: 12),

              _buildSettingsItem(
                icon: Icons.email_outlined,
                title: 'Bize Ulaşın',
                subtitle: 'Yardım için bize ulaşın',
                onTap: () {},
              ),

              const SizedBox(height: 40),

              // Sign Out Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _showSignOutDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC11336),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Sign Out',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFCF3F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.black, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
