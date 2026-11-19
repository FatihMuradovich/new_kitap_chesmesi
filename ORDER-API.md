# Sipariş API'si — Uygulama Entegrasyon Rehberi

**Kitap Çeşmesi · Backend**

Sipariş durumu, müşteri iptali ve durum geçmişi için backend'de yapılan değişiklikler — ve
mobil uygulamanın hangi uçları nasıl kullanması gerektiği.

---

## 1. Backend'de ne değişti

| Değişiklik | Uygulamaya etkisi |
|---|---|
| **Müşteri iptali** — yeni uç | "Siparişi iptal et" butonu artık yapılabilir. Sadece `Pending` ve `Confirmed` durumlarında. |
| **Durum geçmişi** — yeni alan `statusHistory` | Her siparişte zaman çizelgesi gösterebilirsiniz. Hem listede hem detayda geliyor. |
| **Push bildirim** | Durum değişince otomatik gidiyor. Payload'da `orderId` var — bildirime tıklayınca detaya yönlendirin. |
| **Geçiş doğrulaması** | Geçersiz durum geçişleri artık `400` dönüyor. Uygulamanın butonları buna göre gizlemesi gerekir. |
| **Sahiplik kontrolü** | Başkasının siparişi artık `404`. Kendi siparişlerinizde bir şey değişmedi. |
| **`count` alanı** | Sipariş listesinde toplam sayı geliyor — sayfalama artık hesaplanabilir. |
| **Access token 15 dk** (önce 2 dk) | Oturum çok daha kararlı. Refresh interceptor yine gerekli. |

---

## 2. Durum modeli

Beş durum var:

```
  Pending  ──▶  Confirmed  ──▶  Shipped  ──▶  Delivered
     │             │              │
     │ müşteri     │ müşteri      │ yalnızca admin
     ▼             ▼              ▼
  ─────────── Cancelled ───────────
```

| Geçiş | Kim yapabilir |
|---|---|
| `Pending` → `Confirmed` | Admin |
| `Pending` → `Cancelled` | **Müşteri** veya admin |
| `Confirmed` → `Shipped` | Admin |
| `Confirmed` → `Cancelled` | **Müşteri** veya admin |
| `Shipped` → `Delivered` | Admin |
| `Shipped` → `Cancelled` | Yalnızca admin |
| `Delivered` / `Cancelled` | Son durum — hiçbir yere geçmez |

> **Uygulamada:** "İptal et" butonunu yalnızca `status` alanı `Pending` veya `Confirmed`
> olduğunda gösterin. Backend zaten engelliyor, ama kullanıcıya çalışmayacak bir buton
> göstermeyin.

---

## 3. Kullanacağınız uçlar

Hepsinin başında dil öneki var: `/api/:lang/…` — `lang` zorunlu ve `tm`, `ru`, `en` dışında
bir değer `400` döner. Aşağıdaki uçların tamamı müşteri JWT'si ister:
`Authorization: Bearer <accessToken>`

---

### `GET /api/:lang/user/order`

**Siparişlerim listesi.** Yalnızca giriş yapan kullanıcının siparişleri, en yeniden eskiye.
Kitap detayı *taşımaz* — liste ekranı için kasıtlı olarak hafif.

**Query parametreleri**

```
page    // varsayılan 1
limit   // varsayılan 100
status  // opsiyonel: Pending | Confirmed | Shipped | Delivered | Cancelled
```

**Yanıt**

```json
{
  "success": true,
  "count": 5,
  "data": [
    {
      "id": 5,
      "status": "Cancelled",
      "total": "100",
      "address": "T",
      "desc": null,
      "etrapId": 1,
      "giftCoverId": null,
      "couponId": null,
      "createdAt": "2026-08-14T09:54:54.559Z",
      "updatedAt": "2026-08-14T09:54:54.649Z",
      "orderItems": [
        { "id": 5, "bookId": 1, "quantity": 1, "price": "100" }
      ],
      "statusHistory": []
    }
  ]
}
```

`count` = toplam kayıt sayısı, sayfalama için. `total` ve `price` string gelir (Decimal).

> Liste kartında kitap kapağı göstermek isterseniz bu uç yetmez — `orderItems` yalnızca
> `bookId` taşır. O durumda backend'de `include` genişletilmeli.

---

### `GET /api/:lang/user/order/:id`

**Sipariş detayı.** Kitapların tam bilgisi burada: ad, görseller, yazar, dil.
Başkasının siparişi `404` döner.

**Üst seviye alanlar**

```
id · status · total · address · desc · etrapId · giftCoverId
couponId · createdAt · updatedAt · user · orderItems · statusHistory
```

**`orderItems[i]`**

```json
{
  "id": 2,
  "bookId": 1,
  "quantity": 1,
  "price": "100",
  "book": {
    "id": 1,
    "name": "Test Kitap",
    "price": "100",
    "images": [ { "path": "/uploads/books/…" } ],
    "author":   { "id": 1, "name": "…" },
    "language": { "id": 1, "name": "…" }
  }
}
```

- `price` → **sipariş anındaki** fiyat. Bunu gösterin.
- `book.price` → kitabın **bugünkü** fiyatı. Göstermeyin.

`book` ayrıca şunları taşır: `cover`, `pageCount`, `publishYear`, `productCode`, `stock`,
`discount`, `discountType`, `discountEnd`, `desc`, `categoryId`, `subcategoryId`.

**`statusHistory[i]`**

```json
{
  "id": 11,
  "status": "Cancelled",
  "actorType": "User",
  "actorId": 1,
  "note": "fikrim değişti",
  "createdAt": "2026-08-14T09:54:54.652Z"
}
```

- `actorType`: `User` | `Admin` | `System`
- `note`: iptal sebebi; genelde `null`
- Kayıtlar **tarihe göre artan** sırada gelir — doğrudan zaman çizelgesi olarak çizebilirsiniz.

---

### `PATCH /api/:lang/user/order/:id/cancel`

**Siparişi iptal et.** Stok otomatik geri eklenir, kullanılan kupon serbest bırakılır
(müşteri tekrar kullanabilir) ve geçmişe kayıt düşer.

**Body** — tamamı opsiyonel

```json
{ "reason": "fikrim değişti" }
```

`reason` en fazla 500 karakter.

**200 — başarılı**

```json
{ "success": true, "data": { "id": 6, "status": "Cancelled" } }
```

**Hatalar**

| Kod | `message` | Ne zaman |
|---|---|---|
| 400 | `Order with status 'Shipped' can no longer be cancelled. Please contact support.` | Kargoya verilmiş / teslim edilmiş |
| 400 | `Order is already cancelled` | Zaten iptal |
| 400 | `reason must be shorter than or equal to 500 characters` | Sebep çok uzun (dizi olarak gelir) |
| 404 | `Couldn't find order with this id!` | Sipariş yok **veya** başkasına ait |
| 401 | — | Token yok / süresi dolmuş |

> Hata mesajları İngilizce ve teknik. Kullanıcıya bunları doğrudan göstermeyin —
> `statusCode` ve mevcut duruma bakıp kendi metinlerinizi yazın.

---

### `POST /api/:lang/order`

**Sipariş oluştur.** Değişmedi, ama bilmeniz gereken bir özelliği var: sipariş
*sunucudaki sepetten değil*, gövdedeki `items` dizisinden kurulur. Yani sepeti uygulamada
yerel tutup yalnızca ödeme anında giriş isteyebilirsiniz.

**Body**

```json
{
  "etrapId": 1,
  "address": "…",
  "desc": "…",
  "giftCoverId": 2,
  "coupon": "TEST10",
  "items": [ { "bookId": 1, "quantity": 2 } ]
}
```

| Alan | Not |
|---|---|
| `etrapId` | **ZORUNLU** — teslimat bölgesi, ücreti buradan gelir |
| `address` | Opsiyonel |
| `desc` | Opsiyonel not |
| `giftCoverId` | Opsiyonel hediye paketi |
| `coupon` | Opsiyonel — kuponun **kodu**, id değil |
| `items` | En az bir kalem |

> Gövdede `price` göndermeyin — gönderseniz de yok sayılır, fiyat ve indirim sunucuda
> hesaplanır. Stok yetersizse veya kitap `Finished` ise `400` döner.

---

## 4. Kullanmayacağınız uçlar

Bunlar artık admin token'ı istiyor. Uygulamadan çağırırsanız `401` alırsınız — eskiden
herkese açıktılar, bu bir güvenlik düzeltmesiydi.

| Kullanmayın | Bunun yerine |
|---|---|
| `GET /order` | `GET /user/order` |
| `GET /order/:id` | `GET /user/order/:id` |
| `GET /order/count` | `count` alanı listeden gelir |
| `PATCH /order/:id` | `PATCH /user/order/:id/cancel` |

---

## 5. Uygulamada dikkat edilecekler

**1. Fiyatta `item.price` kullanın, `item.book.price` değil.**
İlki siparişin verildiği andaki dondurulmuş fiyat, ikincisi kitabın bugünkü fiyatı.
Yanıtta ikisi de var. Karıştırırsanız müşteri eski siparişinde bugünkü fiyatı görür.

**2. Refresh interceptor şart.**
Access token 15 dakika (eskiden 2 dakikaydı). Her `401`'de `POST /auth/refresh-token` ile
yenileyip isteği tekrarlayın. Eşzamanlı 401'lerin hepsinin ayrı ayrı refresh tetiklememesi
için kuyruk kurun — admin panelindeki `admin/src/services/api.tsx` çalışan bir örnek.

**3. Bildirimden derin bağlantı kurun.**
Push payload'ı `{ type: "order_status", orderId, status }` taşır. `type` alanına bakıp
kullanıcıyı doğrudan o siparişin detayına götürün.

**4. Cihaz dilini kaydedin.**
Bildirim metninin dili `DeviceToken.locale` alanından seçiliyor; kayıtlı değilse Türkmence
gönderilir. `POST /notification/register-token` çağrısında `locale` göndermeyi unutmayın.

**5. Parasal alanlar string gelir.**
`total` ve `price` Prisma `Decimal` olduğu için JSON'da `"100"` şeklinde. Doğrudan
toplamayın, önce sayıya çevirin.

**6. Görsel yolları göreli.**
`images[i].path` = `/uploads/books/…`. Başına sunucu adresini ekleyin.

**7. İptal sonrası listeyi tazeleyin.**
İptal yanıtı yalnızca güncellenmiş siparişi döner, `statusHistory` içermez. Detay
ekranındaysanız yeniden çekin.

---

## 6. Local'e bağlanmak

| Uygulama nerede | Base URL |
|---|---|
| iOS Simulator | `http://localhost:3001/api` |
| Android Emulator | `http://10.0.2.2:3001/api` |
| Gerçek telefon (aynı WiFi) | `http://<MAC_IP>:3001/api` |

Makinenin LAN IP'sini bulmak için:

```bash
ipconfig getifaddr en0
```

Bu IP **DHCP ile değişir** (bu projede geliştirme sırasında birkaç kez değişti).
Uygulamada sabit yazmayın, bir config/env değişkeninden okuyun — prod'a geçerken de
tek yerden çevirirsiniz.

Native uygulamada **CORS sorun değil** — o bir tarayıcı mekanizması. Ama Android 9+ ve iOS
şifresiz HTTP'yi varsayılan olarak engeller: debug build'de `usesCleartextTraffic` /
ATS istisnası gerekir. Bunları release build'e koymayın.

### Local'de SMS gönderilmiyor

Kayıt akışında OTP kodu veritabanına yazılıyor ama gönderilemediği için `Failed`
işaretleniyor ve doğrulama kabul etmiyor. Test ederken durumu elle çevirin:

```bash
psql -h localhost -U macbook -d kitapC -Atc \
  "UPDATE otp_codes SET status='Sent' WHERE phone_number='+9936…';
   SELECT code FROM otp_codes ORDER BY id DESC LIMIT 1;"
```

Ayrıca `POST /auth/send-code` local'de ~10 saniye sürer (SMS başarısız olunca 5 sn bekleyip
bir kez daha deniyor). Uygulamanın timeout'unu buna göre ayarlayın. Kodun ömrü 5 dakika.

---

## Deploy notu

Backend değişiklikleri local'de uçtan uca test edildi. Canlıya çıkmadan önce sunucudaki
migration zincirinin çözülmesi gerekiyor — `20260319120506_make_user_birthday_nullable`
mevcut kolonları eklemeye çalıştığı için `prisma migrate deploy` o adımda kilitlenir.
Ayrıntılar için `DEPLOY-CHANGES.md`.
