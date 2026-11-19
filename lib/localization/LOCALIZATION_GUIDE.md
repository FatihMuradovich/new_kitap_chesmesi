# Localization Guide - Çeviri Rehberi

Bu rehber, projeye yeni çeviri metinleri eklemek için hazırlanmıştır.

## 📁 Dosya Yapısı

Çeviri dosyaları `lib/localization/l10n/` klasöründe bulunur:
- `app_tr.arb` - Türkmen dili çevirileri
- `app_ru.arb` - Rusça çevirileri
- `app_en.arb` - İngilizce çevirileri

## 🗂️ Kategoriler

Tüm çeviri dosyaları aşağıdaki kategorilere göre düzenlenmiştir:

### 1. **COMMON** (Genel)
Uygulama genelinde kullanılan ortak metinler
- Örnek: `yes`, `no`, `save`, `close`, `select`

### 2. **BOTTOM_NAVIGATION** (Alt Menü)
Alt navigasyon menüsü
- Örnek: `homeScreen`, `categories`, `favorites`, `cart`, `profil`

### 3. **HOME_PAGE** (Ana Sayfa)
Ana sayfa ile ilgili metinler
- Örnek: `newBooks`, `discountBook`, `turkmenBooks`, `childrenBooks`

### 4. **BOOK_DETAIL_PAGE** (Kitap Detay Sayfası)
Kitap detay sayfası
- Örnek: `description`, `publisher`, `productCode`, `add_cart`

### 5. **CART_ORDER_PAGE** (Sepet ve Sipariş)
Sepet ve sipariş sayfaları
- Örnek: `cartIsEmpty`, `totalAmount`, `acceptCart`, `completeOrder`

### 6. **FAVORITE_PAGE** (Favoriler)
Favori sayfası
- Örnek: `favoriteIsEmpty`, `empty_favorites`

### 7. **CATEGORY_PAGE** (Kategori)
Kategori sayfası
- Örnek: `emptyCategory`

### 8. **PROFILE_PAGE** (Profil)
Profil sayfası
- Örnek: `myProfile`, `myOrders`, `aboutUs`, `language`

### 9. **USER_INFO_PASSWORD** (Kullanıcı Bilgileri)
Kullanıcı bilgileri ve şifre
- Örnek: `name`, `surname`, `password`, `change_password`

### 10. **COUPON_PAGE** (Kupon)
Kupon sayfası
- Örnek: `coupon`, `couponCode`, `discountRate`, `invalidCoupon`

### 11. **CONTACT_PAGE** (İletişim)
İletişim sayfası
- Örnek: `contact_information`, `sendMessage`, `messageSentSuccessfully`

### 12. **DATE_TIME** (Tarih ve Zaman)
Tarih ve zaman ile ilgili metinler
- Örnek: `january`, `february`, `march`

### 13. **MESSAGES_ALERTS** (Mesajlar ve Uyarılar)
Hata mesajları ve uyarılar
- Örnek: `errorMessage`

---

## ➕ Yeni Kelime Nasıl Eklenir?

### Adım 1: Hangi Kategoriye Ait Olduğunu Belirle
Eklemek istediğiniz metni hangi sayfada kullanacaksınız? Ona göre kategorisini belirleyin.

### Adım 2: Üç Dosyaya da Ekleyin
Yeni bir kelime eklerken **mutlaka üç dosyaya da** aynı anahtarla eklemelisiniz:
- `app_tr.arb` (Türkmen)
- `app_ru.arb` (Rusça)
- `app_en.arb` (İngilizce)

### Adım 3: Örnek Format

```json
"keyName": "Çeviri metni",
```

**Örnek:**
Sepet sayfası için "Sepeti Onayla" butonu eklemek istiyorsanız:

**app_tr.arb** (CART_ORDER_PAGE kategorisine):
```json
"confirmBasket": "Sebedi tassykla",
```

**app_ru.arb** (CART_ORDER_PAGE kategorisine):
```json
"confirmBasket": "Подтвердить корзину",
```

**app_en.arb** (CART_ORDER_PAGE kategorisine):
```json
"confirmBasket": "Confirm basket",
```

### Adım 4: Localization Dosyalarını Oluştur

Terminal'de şu komutu çalıştırın:
```bash
flutter gen-l10n
```

veya

```bash
flutter pub get
```

### Adım 5: Kodda Kullanım

```dart
Text(context.l10n.confirmBasket)
```

---

## ⚠️ Önemli Kurallar

1. ✅ **Her zaman üç dosyaya da aynı key'i ekleyin**
2. ✅ **Key isimleri camelCase formatında olmalı** (örnek: `myNewKey`)
3. ✅ **Virgül kullanmayı unutmayın** (son satır hariç)
4. ✅ **Kategorilere göre düzenli ekleyin**
5. ❌ **Türkçe karakter kullanmayın key isimlerinde** (sadece değerlerde kullanın)
6. ❌ **Boşluk içeren key isimleri kullanmayın**

---

## 🔄 Güncelleme Sonrası

Her çeviri güncellemesinden sonra:
1. `flutter gen-l10n` komutunu çalıştırın
2. Uygulamayı yeniden başlatın (Hot reload yeterli olmayabilir)

---

## 📝 Örnek Senaryo

**Yeni bir "Siparişi İptal Et" butonu eklenmek isteniyorsa:**

1. Kategori belirleme: `CART_ORDER_PAGE` (sipariş sayfası için)

2. **app_tr.arb** dosyasına ekle:
```json
"@_CART_ORDER_PAGE": "══════════════════════════════════════════════════════════",
"@_CART_ORDER_PAGE_DESCRIPTION": "Sepet ve sipariş sayfaları",

"cartIsEmpty": "Sebediňiz boş",
"cancelOrder": "Sargydy ýatyr",  // YENİ EKLENEN
"completeOrder": "Sargydy tamamla",
```

3. **app_ru.arb** dosyasına ekle:
```json
"cancelOrder": "Отменить заказ",
```

4. **app_en.arb** dosyasına ekle:
```json
"cancelOrder": "Cancel order",
```

5. Terminal'de çalıştır:
```bash
flutter gen-l10n
```

6. Kodda kullan:
```dart
ElevatedButton(
  onPressed: () {},
  child: Text(context.l10n.cancelOrder),
)
```

---

## 🎯 Faydalı İpuçları

- Yeni bir sayfa eklerken, o sayfa için yeni bir kategori başlığı oluşturabilirsiniz
- Kategori başlıkları `@_` ile başlar ve kod içinde kullanılmaz
- Her kategori için description ekleyebilirsiniz
- Alfabetik sıra yerine, mantıksal gruplandırma tercih edilmiştir

---

**Son güncelleme:** 3 Ekim 2025

