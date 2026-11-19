# Hızlı Başvuru - Quick Reference

## 🚀 Yeni Kelime Ekleme (3 Adım)

### 1️⃣ Kategoriyi Bul
Sayfaya göre kategori seç:
- Genel → `COMMON`
- Ana sayfa → `HOME_PAGE`
- Kitap detay → `BOOK_DETAIL_PAGE`
- Sepet/Sipariş → `CART_ORDER_PAGE`
- Profil → `PROFILE_PAGE`
- vb...

### 2️⃣ Üç Dosyaya Ekle

**app_tr.arb:**
```json
"myNewKey": "Türkmen çevirisi",
```

**app_ru.arb:**
```json
"myNewKey": "Русский перевод",
```

**app_en.arb:**
```json
"myNewKey": "English translation",
```

### 3️⃣ Generate Et
```bash
flutter gen-l10n
```

---

## 💻 Kodda Kullanım

```dart
// Text widget
Text(context.l10n.myNewKey)

// AppBar title
AppBar(title: Text(context.l10n.myNewKey))

// Button
ElevatedButton(
  child: Text(context.l10n.myNewKey),
  onPressed: () {},
)
```

---

## 📋 Mevcut Kategoriler

| Kategori | Kullanım Yeri |
|----------|---------------|
| `COMMON` | Genel (yes, no, save, close) |
| `BOTTOM_NAVIGATION` | Alt menü |
| `HOME_PAGE` | Ana sayfa |
| `BOOK_DETAIL_PAGE` | Kitap detay |
| `CART_ORDER_PAGE` | Sepet ve sipariş |
| `FAVORITE_PAGE` | Favoriler |
| `CATEGORY_PAGE` | Kategoriler |
| `PROFILE_PAGE` | Profil |
| `USER_INFO_PASSWORD` | Kullanıcı bilgileri |
| `COUPON_PAGE` | Kuponlar |
| `CONTACT_PAGE` | İletişim |
| `DATE_TIME` | Tarih/Zaman |
| `MESSAGES_ALERTS` | Hata mesajları |

---

## ⚠️ Dikkat!

✅ **DOĞRU:**
- `"myNewKey": "Değer",`
- Üç dosyaya da ekle
- camelCase kullan

❌ **YANLIŞ:**
- `"my_new_key": "Değer",` (snake_case)
- `"my new key": "Değer",` (boşluk)
- Sadece bir dosyaya eklemek

---

## 🔗 Detaylı Bilgi

Daha fazla bilgi için `LOCALIZATION_GUIDE.md` dosyasına bakın.

