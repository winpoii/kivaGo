# n8n Workflow - Profesyonel Seyahat Planı Oluşturma Akışı

## 🎯 **Genel Bakış**

Bu workflow, kullanıcıların AI ile etkileşim kurarak seyahat planları oluşturmasını sağlar. Travel plan'lar **yalnızca kullanıcı AI önerisini kabul ettiğinde** Firestore'a kaydedilir.

---

## 🔄 **Veri Akışı Senaryoları**

### **Senaryo 1: İlk Mesaj (Yeni Konuşma)**

**Durum:** Kullanıcı ilk kez AI ile konuşuyor, henüz travel plan yok.

**Flutter'dan Gelen Veriler:**
```json
{
  "userId": "user-123",
  "messageContent": "İstanbul'a gitmek istiyorum"
}
```
*Not: `planId` yok*

**n8n Workflow:**

1. **Webhook Trigger** → Verileri al
2. **Firestore Node: Get User** → Kullanıcı profil bilgilerini çek
3. **Function Node: Prepare Conversation Context**
   - Conversation history yok (ilk mesaj)
   - Sadece kullanıcı profil bilgilerini hazırla
4. **AI Model Node** → Yanıt üret
5. **Temporary Storage (Memory/Session)** → Konuşmayı geçici olarak sakla
   - Firestore'a yazma!
   - Sadece workflow memory'de tut
6. **Response Node** → Flutter'a yanıt gönder

**Flutter'a Dönen Yanıt:**
```json
{
  "success": true,
  "planId": null,
  "aiResponse": "İstanbul harika bir seçim! ...",
  "conversationStage": "exploring" // veya "suggested", "accepted"
}
```

---

### **Senaryo 2: Devam Eden Konuşma (Henüz Plan Yok)**

**Durum:** Kullanıcı AI ile sohbet ediyor, ama henüz plan kabul edilmedi.

**Flutter'dan Gelen Veriler:**
```json
{
  "userId": "user-123",
  "messageContent": "Kültürel aktiviteler istiyorum"
}
```
*Not: `planId` hala yok*

**n8n Workflow:**

1. **Webhook Trigger** → Verileri al
2. **Firestore Node: Get User** → Kullanıcı profil bilgilerini çek
3. **Session/State Management** → Önceki konuşmaları çek
   - Eğer workflow state'i varsa, geçmiş konuşmaları al
   - Eğer yoksa, boş başla
4. **Function Node: Build Full Context**
   - User profile + conversation history
5. **AI Model Node** → Yanıt üret
6. **Update Temporary Storage** → Yeni mesajları ekle
7. **Response Node** → Flutter'a yanıt gönder

**Flutter'a Dönen Yanıt:**
```json
{
  "success": true,
  "planId": null,
  "aiResponse": "O halde size şu aktiviteleri öneririm: ...",
  "conversationStage": "exploring"
}
```

---

### **Senaryo 3: AI Plan Öneriyor (Kullanıcı Kabul Edene Kadar)**

**Durum:** AI konuşma sonrası bir seyahat planı önerdi, kullanıcı düşünüyor.

**AI Yanıtı:**
```json
{
  "success": true,
  "planId": null,
  "aiResponse": "... İşte size özel seyahat planım:\n\n1. Ayasofya (2 saat)\n2. Topkapı Sarayı (3 saat)\n...",
  "suggestedPlan": {
    "title": "İstanbul Kültür Rotası",
    "locations": [...],
    "activities": [...],
    "duration": "3 gün"
  },
  "conversationStage": "suggested"
}
```

**Flutter Arayüzü:**
- Mesaj göster
- "Planı Kabul Et" butonu göster
- "Farklı Bir Plan İste" butonu göster

---

### **Senaryo 4: Kullanıcı Planı Kabul Ediyor 🎉**

**Durum:** Kullanıcı "Planı Kabul Et" butonuna bastı.

**Flutter'dan Gelen Veriler:**
```json
{
  "userId": "user-123",
  "messageContent": "Evet, bu planı kabul ediyorum!",
  "action": "accept_plan",
  "suggestedPlanData": {
    "title": "İstanbul Kültür Rotası",
    "locations": [...],
    "activities": [...]
  }
}
```

**n8n Workflow:**

1. **Webhook Trigger** → Verileri al
2. **Firestore Node: Get User** → Kullanıcı profil bilgilerini çek
3. **Session/State Management** → Tüm conversation history'yi al
4. **Function Node: Prepare Travel Plan Data**
   ```javascript
   const userData = $input.item.json.userData;
   const conversationHistory = $input.item.json.conversationHistory;
   const suggestedPlan = $input.item.json.suggestedPlanData;

   return {
     planId: $firestore.generateId('travelPlans'),
     ownerId: userData.uid,
     title: suggestedPlan.title,
     status: 'planning',
     createdAt: $now,
     updatedAt: $now,
     experienceManifesto: extractManifesto(conversationHistory),
     moodKeywords: extractKeywords(conversationHistory),
     suggestedRoute: suggestedPlan.locations,
     aiConversationHistory: conversationHistory
   };
   ```
5. **Firestore Node: Create Travel Plan** ✅
   ```javascript
   Collection: travelPlans
   Document ID: {{ $json.planId }}
   Data: {{ $json }}
   ```
6. **Clear Temporary Storage** → Workflow state'i temizle
7. **Response Node** → Başarı mesajı gönder

**Flutter'a Dönen Yanıt:**
```json
{
  "success": true,
  "planId": "plan-abc123",
  "aiResponse": "Harika! Seyahat planınız kaydedildi. 'Seyahatlerim' bölümünden takip edebilirsiniz.",
  "conversationStage": "accepted",
  "travelPlan": { ... }
}
```

**Flutter Arayüzü:**
- "Plan başarıyla kaydedildi" mesajı
- "Seyahatlerim" sayfasına yönlendirme
- Travel plan TravelsPage'de görünür ✅

---

### **Senaryo 5: Kullanıcı Farklı Plan İstiyor**

**Durum:** Kullanıcı önerilen planı beğenmedi, farklı bir plan istiyor.

**Flutter'dan Gelen Veriler:**
```json
{
  "userId": "user-123",
  "messageContent": "Bu planı beğenmedim, daha maceralı bir şeyler öner",
  "action": "request_different_plan"
}
```

**n8n Workflow:**

1. **Webhook Trigger** → Verileri al
2. **Firestore Node: Get User** → Kullanıcı profil bilgilerini çek
3. **Session/State Management** → Geçmiş konuşmaları al
4. **Function Node: Build Context**
   - Önceki planı ignore et
   - Sadece yeni isteklere odaklan
5. **AI Model Node** → Yeni plan öner
6. **Update Temporary Storage** → Yeni planı sakla
7. **Response Node** → Yeni planı döndür

**Flutter'a Dönen Yanıt:**
```json
{
  "success": true,
  "planId": null,
  "aiResponse": "... Yeni bir plan hazırladım: ...",
  "suggestedPlan": { ... },
  "conversationStage": "suggested"
}
```

---

## 🏗️ **n8n Workflow Yapısı**

```
┌─────────────────────────────────────────────────────────────────┐
│ 1. Webhook (Trigger)                                            │
│    - userId, messageContent, planId?, action?                   │
└────────────────────┬────────────────────────────────────────────┘
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│ 2. Function: Parse Request                                      │
│    - Extract action type (new, continue, accept, reject)        │
│    - Determine workflow path                                    │
└────────────────────┬────────────────────────────────────────────┘
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│ 3. Firestore: Get User Data                                     │
│    - Collection: users                                          │
│    - Document ID: {{ userId }}                                  │
└────────────────────┬────────────────────────────────────────────┘
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│ 4. Switch Node: Action Type?                                    │
│                                                                  │
│  ├─ [NEW/CONTINUE] ──┐                                         │
│  │                    ▼                                         │
│  │  ┌──────────────────────────────────────────────────┐        │
│  │  │ 5a. Session: Get Conversation History            │        │
│  │  │     (Temporary storage - NOT Firestore)          │        │
│  │  └───────────────────┬──────────────────────────────┘        │
│  │                      ▼                                        │
│  │  ┌──────────────────────────────────────────────────┐        │
│  │  │ 6a. Function: Build AI Context                   │        │
│  │  └───────────────────┬──────────────────────────────┘        │
│  │                      ▼                                        │
│  │  ┌──────────────────────────────────────────────────┐        │
│  │  │ 7a. AI Model: Generate Response                  │        │
│  │  └───────────────────┬──────────────────────────────┘        │
│  │                      ▼                                        │
│  │  ┌──────────────────────────────────────────────────┐        │
│  │  │ 8a. Session: Update Conversation                 │        │
│  │  └───────────────────┬──────────────────────────────┘        │
│  │                      ▼                                        │
│  │  └───────────────────────────────────────────────────┘        │
│  │                                                                │
│  └─ [ACCEPT] ────────────┐                                      │
│                           ▼                                       │
│  ┌──────────────────────────────────────────────────┐            │
│  │ 5b. Session: Get Full Conversation History       │            │
│  └───────────────────┬──────────────────────────────┘            │
│                      ▼                                             │
│  ┌──────────────────────────────────────────────────┐            │
│  │ 6b. Function: Prepare Travel Plan Data           │            │
│  └───────────────────┬──────────────────────────────┘            │
│                      ▼                                             │
│  ┌──────────────────────────────────────────────────┐            │
│  │ 7b. Firestore: Create Travel Plan                │            │
│  │      - Collection: travelPlans                   │            │
│  │      - Generate new planId                       │            │
│  └───────────────────┬──────────────────────────────┘            │
│                      ▼                                             │
│  ┌──────────────────────────────────────────────────┐            │
│  │ 8b. Session: Clear Conversation                  │            │
│  └───────────────────┬──────────────────────────────┘            │
│                      ▼                                             │
│  └───────────────────────────────────────────────────┘            │
└────────────────────┬────────────────────────────────────────────┘
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│ 9. Response Node                                                │
│    - success, planId, aiResponse, conversationStage             │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔧 **n8n Node Konfigürasyonları**

### **Node 1: Webhook Trigger**
```javascript
{
  "method": "POST",
  "path": "chat-message",
  "responseMode": "responseNode"
}
```

### **Node 3: Firestore Get User**
```javascript
{
  "operation": "get",
  "collection": "users",
  "documentId": "={{ $json.userId }}"
}
```

### **Node 5a/5b: Session Management**

**Seçenek 1: n8n Workflow State (Önerilen)**
```javascript
// Get conversation
const userId = $input.item.json.userId;
const existingState = $workflow.getStaticData('user');
let conversationHistory = existingState[userId]?.history || [];

// Save conversation
$workflow.getStaticData('user')[userId] = {
  history: conversationHistory,
  lastUpdated: $now
};
```

**Seçenek 2: External Redis/Memory**
```javascript
// Dışarıdan state yönetimi
const conversationHistory = await getFromRedis(userId);
await saveToRedis(userId, conversationHistory);
```

### **Node 6a: Function - Build AI Context**
```javascript
const userData = $input.item.json.userData;
const conversationHistory = $input.item.json.history || [];
const userMessage = $input.item.json.messageContent;

// Build system prompt
const systemPrompt = `
Sen kivaGo'nun seyahat planlama asistanısın.

Kullanıcı Bilgileri:
- İsim: ${userData.displayName}
- Seyahat Kişiliği: ${userData.seekerProfile.title}
- Kişilik Açıklaması: ${userData.seekerProfile.description}

${conversationHistory.length > 0 ? `
Geçmiş Konuşmalar:
${conversationHistory.map(msg => 
  `${msg.role === 'user' ? 'Kullanıcı' : 'AI'}: ${msg.content}`
).join('\n')}
` : 'Bu yeni bir konuşma.'}

Kullanıcının yeni mesajı: "${userMessage}"

Lütfen kişiselleştirilmiş, samimi ve detaylı bir yanıt ver. 
Eğer kullanıcı bir seyahat planı istiyorsa, detaylı bir plan öner.
`;

return {
  systemPrompt,
  userMessage,
  userId: $input.item.json.userId
};
```

### **Node 7a: AI Model (OpenAI/Groq)**
```javascript
{
  "model": "gpt-4-turbo-preview",
  "messages": [
    {
      "role": "system",
      "content": "={{ $json.systemPrompt }}"
    },
    {
      "role": "user",
      "content": "={{ $json.userMessage }}"
    }
  ],
  "temperature": 0.7,
  "max_tokens": 1000
}
```

### **Node 7b: Firestore Create Travel Plan**
```javascript
{
  "operation": "create",
  "collection": "travelPlans",
  "documentId": "={{ $json.planId }}",
  "fields": {
    "planId": "={{ $json.planId }}",
    "ownerId": "={{ $json.ownerId }}",
    "title": "={{ $json.title }}",
    "status": "planning",
    "createdAt": "={{ $now }}",
    "updatedAt": "={{ $now }}",
    "experienceManifesto": "={{ $json.experienceManifesto }}",
    "moodKeywords": "={{ $json.moodKeywords }}",
    "suggestedRoute": "={{ $json.suggestedRoute }}",
    "aiConversationHistory": "={{ $json.aiConversationHistory }}"
  }
}
```

---

## 📱 **Flutter Entegrasyonu**

### **ChatPage'de Plan Kabul Etme**

```dart
// AI mesajında "Planı Kabul Et" butonu göster
void _handlePlanAcceptance(Map<String, dynamic> planData) async {
  setState(() {
    _isSending = true;
  });

  try {
    // Plan acceptance action'ını n8n'e gönder
    final response = await _chatService.sendMessage(
      userId: _currentUser!.uid,
      messageContent: "Planı kabul ediyorum",
      planId: null,
      action: "accept_plan",
      suggestedPlanData: planData,
    );

    // Response'dan planId'yi al
    final planId = response['planId'];
    
    // Seyahatlerim sayfasına yönlendir
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TravelsPage(),
      ),
    );
  } catch (e) {
    _showErrorSnackBar('Plan kaydedilemedi: $e');
  } finally {
    setState(() {
      _isSending = false;
    });
  }
}
```

---

## 🎯 **Özet: Ana Farklar**

| Özellik | Eski Yöntem ❌ | Yeni Yöntem ✅ |
|---------|---------------|---------------|
| **Plan Oluşturma** | Kayıt sırasında otomatik | AI önerisi sonrası kullanıcı kabul ettiğinde |
| **Firestore Kaydı** | Anında kaydedilir | Sadece kabul edildiğinde |
| **Arayüzde Görünürlük** | Boş planlar listelenir | Sadece kabul edilmiş planlar listelenir |
| **Conversation History** | Her şey Firestore'da | Önce geçici saklama, sonra kayıt |
| **Kullanıcı Deneyimi** | Kafa karıştırıcı | Net ve profesyonel |

---

## ✅ **Test Senaryoları**

1. ✅ Yeni kullanıcı kayıt → Travel plan oluşmamalı
2. ✅ Kullanıcı AI ile konuşuyor → Geçici tutulmalı
3. ✅ AI plan öneriyor → Sadece arayüzde gösterilmeli
4. ✅ Kullanıcı planı kabul ediyor → Firestore'a kayıt
5. ✅ Kullanıcı farklı plan istiyor → Yeni plan öner
6. ✅ TravelsPage'de sadece kabul edilmiş planlar görünmeli

---

Bu yapıyla kullanıcı deneyimi daha profesyonel ve mantıklı olacak! 🚀
