# Kitap Çeşmesi

Türkmenistan'daki okurlar için kitap satış uygulaması. Kullanıcılar kitapları
inceleyip arayabilir, sepete ekleyip sipariş verebilir ve siparişlerini takip
edebilir. Uygulama Türkmence, Rusça ve İngilizce kullanılabilir.

Android ve iOS için Flutter ile geliştirilmiştir.

## Özellikler

- Kategoriler, alt kategoriler, filtreler ve kitap arama
- Kitap detayı, yorumlar ve puanlama
- Sepet, sipariş verme, sipariş geçmişi ve sipariş iptali
- Favoriler ve kuponlar
- Telefon numarasıyla kayıt, giriş ve şifre sıfırlama (SMS kodu)
- Push bildirimleri (Firebase Cloud Messaging)
- Üç dil: Türkmence, Rusça, İngilizce (seçilen dil cihazda saklanır)
- İnternet yokken her sayfada "tekrar dene" ekranı

## Teknolojiler

| Alan | Kullanılan |
|---|---|
| Framework | Flutter 3.47, Dart 3 |
| Durum yönetimi | flutter_bloc (Cubit) |
| Bağımlılık yönetimi | get_it (`lib/app/di.dart`) |
| Ağ | Dio (token yenileme, dil öneki ve zaman aşımı interceptor'da) |
| Yönlendirme | auto_route 11 (kod üretimiyle) |
| Güvenli depolama | flutter_secure_storage (token'lar) |
| Bildirimler | firebase_messaging, flutter_local_notifications |
| Çeviriler | Flutter gen-l10n (ARB dosyaları) |

## Kurulum

### 1. Gereksinimler

- Flutter 3.47 veya üstü (`flutter --version`)
- Android için: Android Studio / Android SDK
- iOS için: macOS, Xcode ve CocoaPods

### 2. Repoda bulunmayan dosyalar

Repo herkese açık olduğu için aşağıdaki dosyalar **bilerek** repoya
eklenmemiştir (`.gitignore`). Proje sahibinden alınıp şu konumlara konmalıdır:

| Dosya | Konum | Ne için |
|---|---|---|
| `google-services.json` | `android/app/` | Android'de Firebase (bildirimler). Bu dosya olmadan Android derlemesi başarısız olur. |
| `GoogleService-Info.plist` | `ios/Runner/` | iOS'ta Firebase (bildirimler) |
| `key.properties` | `android/` | Yalnızca release (mağaza) derlemesi için imza bilgileri |
| Keystore (`.jks`) | `key.properties` içindeki `storeFile` yolunda | Yalnızca release derlemesi için imza anahtarı |

> Bu dosyalar asla commit edilmemelidir. Keystore ve şifreleri kaybolursa
> uygulama Play Store'da aynı anahtarla güncellenemez; güvenli bir yerde
> yedekleyin.

`android/key.properties` şu alanları içerir (değerler gizlidir):

```properties
storePassword=...
keyPassword=...
keyAlias=...
storeFile=...
```

### 3. Çalıştırma

```bash
flutter pub get
flutter run
```

## Sık kullanılan komutlar

```bash
# Testler ve statik analiz
flutter test
flutter analyze

# Yönlendirme kodunu yeniden üretmek (yeni sayfa eklenince, @RoutePage)
dart run build_runner build

# Çevirileri yeniden üretmek (ARB dosyaları değişince)
flutter gen-l10n
```

### Mağaza sürümü

`pubspec.yaml` içindeki `version` değerini artırın (ör. `1.1.8+12` →
`1.1.9+13`), sonra:

```bash
# Android (Play Store) — App Bundle
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols

# iOS (App Store) — ardından Xcode ile arşivlenip yüklenir
flutter build ipa --release --obfuscate --split-debug-info=build/symbols
```

`build/symbols` klasörünü her sürüm için ayrı saklayın: bu klasör olmadan o
sürümün çökme raporları okunamaz.

`key.properties` yoksa Android release derlemesi açık bir hata mesajıyla
**bilerek** durur; imzasız paketin yanlışlıkla mağazaya gitmesini engeller.
Debug derlemesi bu dosya olmadan çalışır.

## Bilinmesi gerekenler

- **Türkmence dil kodu:** Flutter'da Türkmence için hazır destek olmadığından
  arayüzde Türkmence `tr` koduyla temsil edilir (`app_tr.arb` Türkmence
  metinleri içerir). API'ye ise `tm` olarak gider
  (`lib/core/service/language_service.dart`).
- **Dil değişince:** Sunucudan gelen, dile bağlı veriler
  `lib/core/session/reload_language_dependent_data.dart` ile yeniden istenir.
  Dile bağlı yeni bir uygulama geneli cubit eklenirse buraya da eklenmelidir.
- **Oturum:** Çıkışta kullanıcıya özel cubit'ler
  `lib/core/session/end_user_session.dart` ile sıfırlanır. Kullanıcıya özel
  yeni bir uygulama geneli cubit eklenirse buraya da eklenmelidir.
- **Loglar** yalnızca debug derlemesinde açıktır.

## Klasör yapısı

```
lib/
├── app/            # Uygulama girişi, DI (get_it), router
├── common/         # Ortak widget'lar ve yardımcılar (ör. hata/tekrar dene ekranı)
├── core/           # Ağ katmanı, yapılandırma, servisler, oturum yönetimi
├── features/       # Özellikler — her biri data / domain / presentation
│   ├── auth/       #   kayıt, giriş, şifre sıfırlama
│   ├── book/       #   kitap listesi, detay, yorumlar
│   ├── category/
│   ├── favorite/
│   ├── home/       #   ana sayfa, bildirimler
│   ├── order/      #   sepet, sipariş, siparişlerim
│   ├── profile/    #   profil, kuponlar, dil, sabit sayfalar
│   ├── search/
│   └── ...
└── localization/   # ARB çeviri dosyaları ve üretilen kod
test/               # Birim ve widget testleri
```

## Diğer belgeler

- [ORDER-API.md](ORDER-API.md) — Sipariş API'si entegrasyon rehberi
