# n8n Workflow - Firestore Entegrasyonu

## 🎯 Hedef
Flutter'dan gelen planId ile Firestore'da travelPlans belgesi oluştur/kullan

---

## 🏗️ Workflow Yapısı

```
┌─────────────────────────────────────────────┐
│ 1. Webhook (Trigger)                        │
│    Method: POST                              │
│    Path: /webhook/c04a7380...               │
│    Input: {userId, messageContent, planId}  │
└────────────────┬────────────────────────────┘
                 ▼
┌─────────────────────────────────────────────┐
│ 2. Code: Validate Input                     │
│    → userId, messageContent, planId kontrol │
└────────────────┬────────────────────────────┘
                 ▼
┌─────────────────────────────────────────────┐
│ 3. Firestore: Get Document                  │
│    Collection: travelPlans                   │
│    Document ID: {{ $json.planId }}          │
│    ⚠️ Continue on Fail: TRUE                │
└────────┬────────────────────────────────────┘
         │
         ├─ Belge VAR ─────────┐
         │                      │
         └─ Belge YOK ────┐    │
                          ▼    │
    ┌─────────────────────────────────┐
    │ 4. Firestore: Create Document   │
    │    Collection: travelPlans       │
    │    Document ID: {{ $json.planId }}│
    │    Data:                          │
    │    {                              │
    │      planId: {{ $json.planId }}, │
    │      ownerId: {{ $json.userId }},│
    │      title: "Yeni Seyahat",      │
    │      status: "planning",          │
    │      createdAt: {{ $now }},      │
    │      updatedAt: {{ $now }},      │
    │      experienceManifesto: "",     │
    │      moodKeywords: [],            │
    │      suggestedRoute: [],          │
    │      aiConversationHistory: [    │
    │        {                          │
    │          role: "user",            │
    │          content: {{ $json.messageContent }} │
    │        }                          │
    │      ]                            │
    │    }                              │
    └────────────────┬────────────────┘
                     │
                     ▼
    ┌─────────────────────────────────┐◄────────┘
    │ 5. Merge                         │
    │    → Her iki durumu birleştir    │
    └────────────────┬────────────────┘
                     ▼
    ┌─────────────────────────────────┐
    │ 6. Firestore: Get Full Document │
    │    → Güncel belgeyi al           │
    └────────────────┬────────────────┘
                     ▼
    ┌─────────────────────────────────┐
    │ 7. Code: AI Prompt Hazırla      │
    │    → Conversation history + new │
    └────────────────┬────────────────┘
                     ▼
    ┌─────────────────────────────────┐
    │ 8. Google Gemini AI              │
    │    → AI yanıtı al                │
    └────────────────┬────────────────┘
                     ▼
    ┌─────────────────────────────────┐
    │ 9. Code: Update History          │
    │    → User mesaj + AI yanıt ekle │
    └────────────────┬────────────────┘
                     ▼
    ┌─────────────────────────────────┐
    │ 10. Firestore: Update Document   │
    │     → aiConversationHistory güncelle │
    └────────────────┬────────────────┘
                     ▼
    ┌─────────────────────────────────┐
    │ 11. Respond to Webhook           │
    │     {                             │
    │       success: true,              │
    │       planId: {{ $json.planId }},│
    │       aiResponse: {{ $json.ai }}  │
    │     }                             │
    └─────────────────────────────────┘
```

---

## 🔧 Node Konfigürasyonları

### Node 2: Code - Validate Input

```javascript
// Input validation
const userId = $json.userId;
const messageContent = $json.messageContent;
const planId = $json.planId;

if (!userId || !messageContent || !planId) {
  throw new Error('Missing required fields: userId, messageContent, or planId');
}

console.log('✅ Valid input received');
console.log('  - planId:', planId);
console.log('  - userId:', userId);
console.log('  - message:', messageContent);

return [{
  json: {
    userId,
    messageContent,
    planId
  }
}];
```

### Node 3: Firestore - Get Document

```
Operation: Get
Collection Path: travelPlans
Document ID: ={{ $json.planId }}
Options:
  ✅ Continue on Fail: true
  ✅ Return All: false
```

**Önemli:** "Continue on Fail" aktif olmalı! Yoksa belge yokken hata verir.

### Node 4: Firestore - Create Document (IF belge yoksa)

Bu node sadece Node 3 **HATA** verirse çalışmalı.

**IF Node ile kontrol:**
```javascript
// IF Node Expression
{{ $node["Firestore Get"].error !== undefined }}
```

**Firestore Create Settings:**
```
Operation: Create
Collection Path: travelPlans
Document ID: ={{ $json.planId }}
```

**Document Data (JSON):**
```json
{
  "planId": "={{ $json.planId }}",
  "ownerId": "={{ $json.userId }}",
  "title": "Yeni Seyahat Planı",
  "status": "planning",
  "createdAt": "={{ $now }}",
  "updatedAt": "={{ $now }}",
  "experienceManifesto": "",
  "moodKeywords": [],
  "suggestedRoute": [],
  "aiConversationHistory": [
    {
      "role": "user",
      "content": "={{ $json.messageContent }}"
    }
  ]
}
```

### Node 6: Firestore - Get Full Document (Tekrar)

Hem yeni oluşturulan hem de mevcut belgeyi almak için tekrar GET yapıyoruz.

```
Operation: Get
Collection Path: travelPlans
Document ID: ={{ $json.planId }}
```

### Node 7: Code - AI Prompt Hazırla

```javascript
// Firestore'dan gelen belge
const travelPlan = $json;

// Conversation history
const conversationHistory = travelPlan.aiConversationHistory || [];

// Yeni mesaj
const newMessage = $('Webhook').item.json.messageContent;

// Sistem promptu hazırla
const systemPrompt = `Sen kivaGo AI seyahat asistanısın. 
Kullanıcı: ${$('Webhook').item.json.userId}
Plan ID: ${travelPlan.planId}

Önceki konuşmalar:
${conversationHistory.map(msg => `${msg.role}: ${msg.content}`).join('\n')}

Yeni mesaj: ${newMessage}

Lütfen yardımcı ve samimi bir şekilde yanıt ver.`;

return [{
  json: {
    prompt: systemPrompt,
    planId: travelPlan.planId,
    conversationHistory,
    newMessage
  }
}];
```

### Node 8: Google Gemini AI

```
Model: gemini-pro
Prompt: ={{ $json.prompt }}
Temperature: 0.7
Max Tokens: 1000
```

### Node 9: Code - Update History

```javascript
// Önceki conversation history
const history = $json.conversationHistory || [];

// Yeni mesajları ekle
const updatedHistory = [
  ...history,
  {
    role: "user",
    content: $json.newMessage
  },
  {
    role: "assistant",
    content: $('Google Gemini').item.json.text
  }
];

return [{
  json: {
    planId: $json.planId,
    aiConversationHistory: updatedHistory,
    aiResponse: $('Google Gemini').item.json.text
  }
}];
```

### Node 10: Firestore - Update Document

```
Operation: Update
Collection Path: travelPlans
Document ID: ={{ $json.planId }}
```

**Update Data:**
```json
{
  "aiConversationHistory": "={{ $json.aiConversationHistory }}",
  "updatedAt": "={{ $now }}"
}
```

### Node 11: Respond to Webhook

```json
{
  "success": true,
  "planId": "={{ $json.planId }}",
  "aiResponse": "={{ $json.aiResponse }}"
}
```

---

## 🧪 Test Senaryosu

### İlk Mesaj (Yeni Belge)
**Flutter → n8n:**
```json
{
  "userId": "user-123",
  "messageContent": "İstanbul'a gitmek istiyorum",
  "planId": "abc-def-123"
}
```

**n8n:**
1. Firestore GET → Belge yok
2. Firestore CREATE → Yeni belge oluştur
3. AI yanıt üret
4. Firestore UPDATE → Conversation history ekle
5. Response döndür

**Flutter ← n8n:**
```json
{
  "success": true,
  "planId": "abc-def-123",
  "aiResponse": "İstanbul harika bir seçim! ..."
}
```

### İkinci Mesaj (Mevcut Belge)
**Flutter → n8n:**
```json
{
  "userId": "user-123",
  "messageContent": "Kaç gün kalmalıyım?",
  "planId": "abc-def-123"
}
```

**n8n:**
1. Firestore GET → Belge VAR
2. Conversation history al
3. AI yanıt üret (geçmiş konuşmalarla birlikte)
4. Firestore UPDATE → Yeni conversation ekle
5. Response döndür

---

## ⚠️ Önemli Notlar

1. **Firebase Credentials:** n8n'de Firebase service account ayarlanmalı
2. **Collection Name:** `travelPlans` (küçük harfle)
3. **Document ID:** Flutter'dan gelen planId kullanılmalı
4. **Error Handling:** "Continue on Fail" mutlaka aktif
5. **Timestamp:** Firestore Timestamp formatında olmalı

---

## ✅ Başarı Kriterleri

- ✅ İlk mesajda Firestore'da belge oluşuyor
- ✅ İkinci mesajda mevcut belge kullanılıyor
- ✅ Conversation history birikiyor
- ✅ Flutter'a planId dönüyor
- ✅ Hata almıyoruz

