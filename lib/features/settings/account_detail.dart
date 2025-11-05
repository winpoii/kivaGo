import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import '../../core/services/auth_service.dart';
import '../../core/models/user_model.dart';

/// Account details page
class AccountDetailPage extends StatefulWidget {
  const AccountDetailPage({super.key});

  @override
  State<AccountDetailPage> createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends State<AccountDetailPage> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();

  UserModel? _user;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isEditing = false;
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _authService.getCurrentUserFromFirestore();
      setState(() {
        _user = user;
        if (user != null) {
          _displayNameController.text = user.displayName;
          _usernameController.text = user.username.isEmpty
              ? user.email.split('@')[0]
              : user.username;
          _cityController.text = user.city;
          
          // Set country from saved value
          if (user.country.isNotEmpty) {
            _countryController.text = user.country;
            // Try to find country by ISO code (e.g., "TR" for Turkey)
            // If country is stored as name, we'll just show the name without flag
            try {
              // Try common country codes first
              final countryCode = _getCountryCodeFromName(user.country);
              if (countryCode != null) {
                _selectedCountry = Country.tryParse(countryCode);
              } else {
                _selectedCountry = null;
              }
            } catch (e) {
              _selectedCountry = null;
            }
          } else {
            _countryController.text = '';
            _selectedCountry = null;
          }
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kullanıcı bilgileri yüklenemedi: ${e.toString()}'),
            backgroundColor: const Color(0xFFC11336),
          ),
        );
      }
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _authService.updateUserAccountInfo(
        displayName: _displayNameController.text.trim(),
        username: _usernameController.text.trim(),
        country: _selectedCountry?.name ?? _countryController.text.trim(),
        city: _cityController.text.trim(),
      );

      // Reload user data to get updated information
      await _loadUserData();

      setState(() {
        _isEditing = false;
        _isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bilgiler başarıyla güncellendi'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Güncelleme başarısız: ${e.toString()}'),
            backgroundColor: const Color(0xFFC11336),
          ),
        );
      }
    }
  }

  void _cancelEdit() {
    // Reset to original values
    if (_user != null) {
      _displayNameController.text = _user!.displayName;
      _usernameController.text = _user!.username.isEmpty
          ? _user!.email.split('@')[0]
          : _user!.username;
      _cityController.text = _user!.city;
      _countryController.text = _user!.country;
      
      // Reset country selection
      if (_user!.country.isNotEmpty) {
        _countryController.text = _user!.country;
        try {
          final countryCode = _getCountryCodeFromName(_user!.country);
          if (countryCode != null) {
            _selectedCountry = Country.tryParse(countryCode);
          } else {
            _selectedCountry = null;
          }
        } catch (e) {
          _selectedCountry = null;
        }
      } else {
        _countryController.text = '';
        _selectedCountry = null;
      }
    }
    setState(() => _isEditing = false);
  }

  String? _getCountryCodeFromName(String countryName) {
    // Common country name to code mapping
    final countryMap = {
      'Turkey': 'TR',
      'Türkiye': 'TR',
      'United States': 'US',
      'United Kingdom': 'GB',
      'Germany': 'DE',
      'France': 'FR',
      'Italy': 'IT',
      'Spain': 'ES',
      'Netherlands': 'NL',
      'Belgium': 'BE',
      'Switzerland': 'CH',
      'Austria': 'AT',
      'Sweden': 'SE',
      'Norway': 'NO',
      'Denmark': 'DK',
      'Finland': 'FI',
      'Poland': 'PL',
      'Greece': 'GR',
      'Portugal': 'PT',
      'Ireland': 'IE',
      'Russia': 'RU',
      'China': 'CN',
      'Japan': 'JP',
      'South Korea': 'KR',
      'India': 'IN',
      'Australia': 'AU',
      'Canada': 'CA',
      'Mexico': 'MX',
      'Brazil': 'BR',
      'Argentina': 'AR',
      'Chile': 'CL',
      'South Africa': 'ZA',
      'Egypt': 'EG',
      'Saudi Arabia': 'SA',
      'United Arab Emirates': 'AE',
      'Israel': 'IL',
      'New Zealand': 'NZ',
    };
    
    // Try exact match first
    if (countryMap.containsKey(countryName)) {
      return countryMap[countryName];
    }
    
    // Try case-insensitive match
    for (final entry in countryMap.entries) {
      if (entry.key.toLowerCase() == countryName.toLowerCase()) {
        return entry.value;
      }
    }
    
    return null;
  }

  // All countries list (ISO 3166-1 alpha-2 codes)
  static List<Country> get _allCountries {
    final countries = <Country>[];
    // All ISO 3166-1 alpha-2 country codes
    final codes = [
      'AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR',
      'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE',
      'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ',
      'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD',
      'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR',
      'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM',
      'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI',
      'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF',
      'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS',
      'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU',
      'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT',
      'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN',
      'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK',
      'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME',
      'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ',
      'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA',
      'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU',
      'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM',
      'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS',
      'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI',
      'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV',
      'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK',
      'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA',
      'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI',
      'VN', 'VU', 'WF', 'WS', 'XK', 'YE', 'YT', 'ZA', 'ZM', 'ZW'
    ];
    for (final code in codes) {
      final country = Country.tryParse(code);
      if (country != null) {
        countries.add(country);
      }
    }
    return countries;
  }

  void _showCountryCityDialog() {
    String? selectedCountryCode;
    String selectedCountryName = _countryController.text;
    String selectedCity = _cityController.text;
    final cityController = TextEditingController(text: selectedCity);
    final searchController = TextEditingController();
    
    List<Country> filteredCountries = _allCountries;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          // Initialize selected country code if country is already selected
          if (selectedCountryCode == null && _selectedCountry != null) {
            selectedCountryCode = _selectedCountry!.countryCode;
          }

          // Filter countries based on search
          void filterCountries(String query) {
            setDialogState(() {
              if (query.isEmpty) {
                filteredCountries = _allCountries;
              } else {
                filteredCountries = _allCountries.where((country) {
                  return country.name
                      .toLowerCase()
                      .contains(query.toLowerCase());
                }).toList();
              }
            });
          }

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFF5F5F5),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Ülke ve Şehir Seçin',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Country Search
                          TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              labelText: 'Ülke ara',
                              hintText: 'Ülke adı girin',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: const Color(0xFFF5F5F5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFC11336),
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: filterCountries,
                          ),
                          const SizedBox(height: 16),
                          // Country List
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * 0.3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: filteredCountries.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Center(
                                      child: Text(
                                        'Ülke bulunamadı',
                                        style: TextStyle(
                                          color: Color(0xFF999999),
                                        ),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: filteredCountries.length,
                                    itemBuilder: (context, index) {
                                      final country = filteredCountries[index];
                                      final isSelected =
                                          selectedCountryCode == country.countryCode;
                                      return InkWell(
                                        onTap: () {
                                          setDialogState(() {
                                            selectedCountryCode = country.countryCode;
                                            selectedCountryName = country.name;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? const Color(0xFFFCF3F6)
                                                : Colors.transparent,
                                            border: isSelected
                                                ? Border.all(
                                                    color: const Color(0xFFC11336),
                                                    width: 1,
                                                  )
                                                : null,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                country.flagEmoji,
                                                style: const TextStyle(fontSize: 24),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  country.name,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: isSelected
                                                        ? FontWeight.w600
                                                        : FontWeight.normal,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              if (isSelected)
                                                const Icon(
                                                  Icons.check_circle,
                                                  color: Color(0xFFC11336),
                                                  size: 20,
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          // City Input
                          if (selectedCountryCode != null) ...[
                            const SizedBox(height: 24),
                            const Text(
                              'Şehir',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: cityController,
                              decoration: InputDecoration(
                                hintText: 'Şehir adı girin',
                                filled: true,
                                fillColor: const Color(0xFFF5F5F5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFC11336),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                              onChanged: (value) {
                                selectedCity = value;
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  // Footer
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Color(0xFFF5F5F5),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'İptal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF999999),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: selectedCountryCode != null
                                ? () {
                                    try {
                                      final country =
                                          Country.tryParse(selectedCountryCode!);
                                      setState(() {
                                        _selectedCountry = country;
                                        _countryController.text =
                                            selectedCountryName;
                                        _cityController.text =
                                            cityController.text.trim();
                                      });
                                      Navigator.of(context).pop();
                                    } catch (e) {
                                      setState(() {
                                        _countryController.text =
                                            selectedCountryName;
                                        _cityController.text =
                                            cityController.text.trim();
                                      });
                                      Navigator.of(context).pop();
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC11336),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              disabledBackgroundColor: const Color(0xFFE0E0E0),
                            ),
                            child: const Text(
                              'Kaydet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Hesap Detayları',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_user != null && !_isLoading)
            IconButton(
              icon: Icon(
                _isEditing ? Icons.close : Icons.edit,
                color: Colors.black,
              ),
              onPressed: _isEditing ? _cancelEdit : () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFC11336),
              ),
            )
          : _user == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Color(0xFF999999),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Kullanıcı bilgileri bulunamadı',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF999999),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadUserData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC11336),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Yeniden Dene'),
                      ),
                    ],
                  ),
                )
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Profile Section
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFFCF3F6),
                                      width: 4,
                                    ),
                                    color: const Color(0xFFFCF3F6),
                                  ),
                                  child: ClipOval(
                                    child: _user!.photoUrl.isNotEmpty
                                        ? Image.network(
                                            _user!.photoUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.person,
                                                size: 60,
                                                color: Color(0xFF999999),
                                              );
                                            },
                                          )
                                        : const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Color(0xFF999999),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _displayNameController.text.isEmpty
                                      ? _user!.displayName
                                      : _displayNameController.text,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _user!.email,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF999999),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Account Information Section
                          const Text(
                            'Hesap Bilgileri',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),

                          _buildEditableField(
                            icon: Icons.person_outline,
                            label: 'Kullanıcı Adı',
                            controller: _usernameController,
                            enabled: _isEditing,
                            validator: (value) {
                              if (_isEditing && value != null && value.trim().isEmpty) {
                                return 'Kullanıcı adı boş olamaz';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 12),

                          _buildEditableField(
                            icon: Icons.badge_outlined,
                            label: 'Tam Ad',
                            controller: _displayNameController,
                            enabled: _isEditing,
                            validator: (value) {
                              if (_isEditing && value != null && value.trim().isEmpty) {
                                return 'Tam ad boş olamaz';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 12),

                          _buildCountryCityPickerField(),

                          const SizedBox(height: 32),

                          // Save Button
                          if (_isEditing)
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isSaving ? null : _saveChanges,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC11336),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: _isSaving
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
                                          Icon(Icons.save, size: 20),
                                          SizedBox(width: 8),
                                          Text(
                                            'Değişiklikleri Kaydet',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildEditableField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool enabled,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF3F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            child: enabled
                ? TextFormField(
                    controller: controller,
                    enabled: enabled,
                    validator: validator,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: label,
                      labelStyle: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF999999),
                        fontWeight: FontWeight.w500,
                      ),
                      floatingLabelStyle: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF999999),
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      isDense: false,
                      alignLabelWithHint: false,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF999999),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.text.isEmpty ? 'Belirtilmemiş' : controller.text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: controller.text.isEmpty
                              ? const Color(0xFF999999)
                              : Colors.black,
                          fontStyle: controller.text.isEmpty
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryCityPickerField() {
    return Container(
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
            child: const Icon(Icons.location_on_outlined, color: Colors.black, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _isEditing
                ? InkWell(
                    onTap: _showCountryCityDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ülke / Şehir',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF999999),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (_selectedCountry != null) ...[
                                Text(
                                  _selectedCountry!.flagEmoji,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _countryController.text.isEmpty
                                          ? 'Ülke seçin'
                                          : _countryController.text,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: _countryController.text.isEmpty
                                            ? const Color(0xFF999999)
                                            : Colors.black,
                                        fontStyle: _countryController.text.isEmpty
                                            ? FontStyle.italic
                                            : FontStyle.normal,
                                      ),
                                    ),
                                    if (_cityController.text.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        _cityController.text,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF999999),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFF999999),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ülke / Şehir',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF999999),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (_selectedCountry != null) ...[
                            Text(
                              _selectedCountry!.flagEmoji,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _countryController.text.isEmpty
                                      ? 'Belirtilmemiş'
                                      : _countryController.text,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: _countryController.text.isEmpty
                                        ? const Color(0xFF999999)
                                        : Colors.black,
                                    fontStyle: _countryController.text.isEmpty
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
                                if (_cityController.text.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    _cityController.text,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF999999),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
