/// Travel profile types
enum TravelProfileType {
  adventureSeeker,
  relaxedTraveler,
  explorer,
  luxuryTraveler,
  natureLover,
  socialTraveler,
  budgetBackpacker,
}

/// Extension to get display information for each profile type
extension TravelProfileTypeExtension on TravelProfileType {
  String get title {
    switch (this) {
      case TravelProfileType.adventureSeeker:
        return 'Maceraperest';
      case TravelProfileType.relaxedTraveler:
        return 'Dingin Gezgin';
      case TravelProfileType.explorer:
        return 'Keşifçi';
      case TravelProfileType.luxuryTraveler:
        return 'Lüks Gezgin';
      case TravelProfileType.natureLover:
        return 'Doğa Sever';
      case TravelProfileType.socialTraveler:
        return 'Sosyal Kelebek';
      case TravelProfileType.budgetBackpacker:
        return 'Sırt Çantalı';
    }
  }

  String get description {
    switch (this) {
      case TravelProfileType.adventureSeeker:
        return 'Adrenalin tutkunusun! Ekstrem sporlar, yeni deneyimler ve sınırları zorlamak senin için seyahatin özü.';
      case TravelProfileType.relaxedTraveler:
        return 'Huzur arayan bir ruha sahipsin. Sakin plajlar, spa deneyimleri ve yavaş tempolu keşifler seni mutlu eder.';
      case TravelProfileType.explorer:
        return 'Bilinmeyeni keşfetmeyi seversin. Yeni yerler, gizli köşeler ve benzersiz deneyimler peşindesin.';
      case TravelProfileType.luxuryTraveler:
        return 'Konfor ve kalite senin önceliğin. Lüks oteller, fine dining ve premium deneyimler tercih edersin.';
      case TravelProfileType.natureLover:
        return 'Doğayla iç içe olmayı seversin. Trekking, kampçılık ve vahşi yaşam seyahatlerinin olmazsa olmazı.';
      case TravelProfileType.socialTraveler:
        return 'İnsanlarla tanışmak ve sosyalleşmek seni mutlu eder. Gece hayatı, festivaller ve grup aktiviteleri favorin.';
      case TravelProfileType.budgetBackpacker:
        return 'Pratik ve ekonomik seyahat edersin. Yerel ulaşım, hostel konaklama ve otantik deneyimler tercih edersin.';
    }
  }

  String get emoji {
    switch (this) {
      case TravelProfileType.adventureSeeker:
        return '🏔️';
      case TravelProfileType.relaxedTraveler:
        return '🌴';
      case TravelProfileType.explorer:
        return '🧭';
      case TravelProfileType.luxuryTraveler:
        return '💎';
      case TravelProfileType.natureLover:
        return '🌲';
      case TravelProfileType.socialTraveler:
        return '🎭';
      case TravelProfileType.budgetBackpacker:
        return '🎒';
    }
  }

  String get imageUrl {
    switch (this) {
      case TravelProfileType.adventureSeeker:
        return 'https://images.unsplash.com/photo-1718472507745-ff60974a7cba?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
      case TravelProfileType.relaxedTraveler:
        return 'https://plus.unsplash.com/premium_photo-1684917944838-30fe85aa6059?q=80&w=1169&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
      case TravelProfileType.explorer:
        return 'https://plus.unsplash.com/premium_photo-1661337053802-320722486314?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
      case TravelProfileType.luxuryTraveler:
        return 'https://plus.unsplash.com/premium_photo-1664302528539-ea19c3a75fe3?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
      case TravelProfileType.natureLover:
        return 'https://images.unsplash.com/photo-1654127654058-20748de1f7e5?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
      case TravelProfileType.socialTraveler:
        return 'https://plus.unsplash.com/premium_photo-1723478475281-95075826aeb0?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
      case TravelProfileType.budgetBackpacker:
        return 'https://images.unsplash.com/photo-1623497717224-9ccb164e7666?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
    }
  }

  List<String> get traits {
    switch (this) {
      case TravelProfileType.adventureSeeker:
        return ['Cesur', 'Heyecan Arayan', 'Aktif', 'Risk Alan'];
      case TravelProfileType.relaxedTraveler:
        return ['Sakin', 'Huzur Arayan', 'Rahat', 'Yavaş Tempolu'];
      case TravelProfileType.explorer:
        return ['Maceraperest', 'Keşfetmeyi Seven', 'Bağımsız', 'Cesur'];
      case TravelProfileType.luxuryTraveler:
        return ['Konforcu', 'Kalite Odaklı', 'Seçici', 'Premium'];
      case TravelProfileType.natureLover:
        return ['Doğa Dostu', 'Aktif', 'Çevreci', 'Özgür Ruhlu'];
      case TravelProfileType.socialTraveler:
        return ['Sosyal', 'Eğlenceli', 'Dışa Dönük', 'Enerji Dolu'];
      case TravelProfileType.budgetBackpacker:
        return ['Pratik', 'Esnek', 'Maceracı', 'Özgür'];
    }
  }

  List<String> get suggestedActivities {
    switch (this) {
      case TravelProfileType.adventureSeeker:
        return [
          'Paraşüt Atlayışı',
          'Dağ Tırmanışı',
          'Dalış Turu',
          'Rafting',
          'Zipline'
        ];
      case TravelProfileType.relaxedTraveler:
        return [
          'Yoga Seansı',
          'Spa Günü',
          'Plaj Günü',
          'Meditasyon',
          'Sunset Cruise'
        ];
      case TravelProfileType.explorer:
        return [
          'Şehir Keşfi',
          'Gizli Mekanlar Turu',
          'Yerel Pazar Gezisi',
          'Foto Safari',
          'Walking Tour'
        ];
      case TravelProfileType.luxuryTraveler:
        return [
          'Fine Dining',
          'Private Tour',
          'Yacht Gezisi',
          'Helicopter Tour',
          'Golf'
        ];
      case TravelProfileType.natureLover:
        return [
          'Trekking',
          'Camping',
          'Wildlife Safari',
          'Bisiklet Turu',
          'Kuş Gözlem'
        ];
      case TravelProfileType.socialTraveler:
        return [
          'Pub Crawl',
          'Festival',
          'Beach Party',
          'Grup Yemeği',
          'Karaoke'
        ];
      case TravelProfileType.budgetBackpacker:
        return [
          'Hostel Buluşması',
          'Free Walking Tour',
          'Sokak Yemeği Turu',
          'Hitchhiking',
          'Kamp'
        ];
    }
  }

  String get personalBenefit {
    switch (this) {
      case TravelProfileType.adventureSeeker:
        return 'Adrenalin dolu maceralar ve ekstrem sporlar için ideal destinasyonlar!';
      case TravelProfileType.relaxedTraveler:
        return 'Huzurlu ve sakin atmosferlerde dinlenme ve rahatlama deneyimleri!';
      case TravelProfileType.explorer:
        return 'Keşfedilmemiş yerler ve gizli hazineler için mükemmel rotalar!';
      case TravelProfileType.luxuryTraveler:
        return 'Lüks ve konfor odaklı premium seyahat deneyimleri!';
      case TravelProfileType.natureLover:
        return 'Doğanın kalbinde trekking ve doğa sporları için ideal lokasyonlar!';
      case TravelProfileType.socialTraveler:
        return 'Festivaller, etkinlikler ve sosyal aktiviteler için harika destinasyonlar!';
      case TravelProfileType.budgetBackpacker:
        return 'Ekonomik ve macera dolu sırt çantalı seyahat deneyimleri!';
    }
  }

  String get affirmationText {
    switch (this) {
      case TravelProfileType.adventureSeeker:
        return 'Kalabalıkların yürüdüğü yollardan sıkıldın. Senin için seyahat, konfor alanının bittiği yerde başlar. Bilinmeyene duyduğun merak, en büyük rehberin.';
      case TravelProfileType.relaxedTraveler:
        return 'Hızın ve gürültünün olduğu yerlerde kaybolmuş hissediyorsun. Senin için seyahat, içindeki sakinliği bulmak ve yeniden doğmak demek. Huzur, senin en değerli hazinen.';
      case TravelProfileType.explorer:
        return 'Bilinmeyen köşeler seni çağırıyor. Her yeni gün, yeni bir keşif fırsatı. Senin için seyahat, dünyanın gizli hikayelerini bulmak ve kendi hikayeni yazmak demek.';
      case TravelProfileType.luxuryTraveler:
        return 'Hayatın en güzel anlarını yaşamayı hak ediyorsun. Kalite ve konfor senin doğal hakkın. Senin için seyahat, kendini şımartmak ve en iyisini deneyimlemek demek.';
      case TravelProfileType.natureLover:
        return 'Betondan uzaklaşıp doğanın kucağına dönmek istiyorsun. Ağaçların hışırtısı, kuşların sesi senin müziğin. Senin için seyahat, doğayla yeniden bağ kurmak demek.';
      case TravelProfileType.socialTraveler:
        return 'İnsanlarla tanışmak ve yeni dostluklar kurmak senin enerjin. Her yeni yüz, yeni bir hikaye demek. Senin için seyahat, kalbi genişletmek ve dünyayı daha sıcak bir yer haline getirmek.';
      case TravelProfileType.budgetBackpacker:
        return 'Para değil, deneyim önemli senin için. Her kuruşun değerini biliyorsun ve gerçek maceraları önceliyorsun. Senin için seyahat, özgürlüğü keşfetmek ve hayatı dolu dolu yaşamak demek.';
    }
  }
}

/// Travel profile result model
class TravelProfile {
  final TravelProfileType type;
  final Map<TravelProfileType, double> scores;
  final DateTime completedAt;

  TravelProfile({
    required this.type,
    required this.scores,
    required this.completedAt,
  });

  factory TravelProfile.fromJson(Map<String, dynamic> json) {
    return TravelProfile(
      type: TravelProfileType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TravelProfileType.explorer,
      ),
      scores: Map<String, double>.from(json['scores'] ?? {})
          .map((key, value) => MapEntry(
                TravelProfileType.values.firstWhere(
                  (e) => e.name == key,
                  orElse: () => TravelProfileType.explorer,
                ),
                value,
              )),
      completedAt: DateTime.parse(json['completedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'scores': scores.map((key, value) => MapEntry(key.name, value)),
      'completedAt': completedAt.toIso8601String(),
    };
  }
}
