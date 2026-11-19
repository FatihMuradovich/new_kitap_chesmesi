# Özel Sipariş API'si — Uygulama Entegrasyon Rehberi

**Kitap Çeşmesi · Backend**

Stokta olmayan kitapların yurtdışından getirtilmesi için eklenen talep–teklif–onay akışı,
ve mobil uygulamanın hangi uçları nasıl kullanması gerektiği.

---

## 1. Neden ayrı bir akış

Normal satışta fiyat bellidir, sepete atılır, ödenir. Özel siparişte kitap yurtdışından
geliyor ve **fiyat her seferinde değişken** — önden ilan edilemez. Bu yüzden akış şöyle:

```
müşteri talep açar  →  admin fiyat verir  →  müşteri seçip onaylar  →  sipariş oluşur
```

Onaydan sonra iş normal `Order` üzerinden yürür; `isSpecialOrder: true` olur ve tedarik
süreci `supplyStatus` alanında ayrı bir eksen olarak ilerler.

---

## 2. Neler değişti

| Değişiklik | Uygulamaya etkisi |
|---|---|
| **`GET /book` → yeni `status` filtresi** | "Getirtebiliriz" bölümü `?status=Finished` ile beslenir. **Filtre göndermezseniz liste eskisi gibi döner** — mevcut sürüm bozulmaz. |
| **Kitap yanıtında `specialOrderable`** | Kitap detayında butonu buna göre çizin. |
| **Yeni `/special-order` uçları** | Talep açma, teklif görme, onaylama. |
| **`GET /delivery-method`** | Uçak / tır: ad + tahmini gün. Public, token istemez. |
| **`Order` yeni alanları** | `isSpecialOrder`, `supplyStatus`, `deliveryMethod`, `estimatedArrival`, `specialRequest`. |
| **İptal kuralı özel siparişte farklı** | `status` değil `supplyStatus` belirler — sadece `Preparing` iken açık. |

---

## 3. Durum modeli

### Talep (`SpecialOrderRequest.status`)

```
  Pending ─┬─▶ Quoted ─┬─▶ Approved     (Order oluştu, gerisi Order'da)
           │           ├─▶ Rejected     (müşteri teklifi beğenmedi)
           │           ├─▶ Expired      (teklif süresi doldu, gece cron'u)
           │           └─▶ Cancelled    (müşteri vazgeçti)
           ├─▶ Unavailable              (admin: getirtemiyorum)
           └─▶ Cancelled
```

`Approved`, `Rejected`, `Expired`, `Cancelled`, `Unavailable` son durumdur.

### Sipariş oluştuktan sonra — iki eksen

```
Order.status:        Confirmed ────────────────────────▶ Shipped ─▶ Delivered
Order.supplyStatus:  Preparing ─▶ OrderedAbroad ─▶ InTransit ─▶ Arrived
                     └ iptal ┘  └────────── iptal kapalı ──────────────┘
```

Sipariş **`Confirmed`** doğar (admin zaten fiyat verip anlaşmış, `Pending` aşaması yok).
`supplyStatus` yalnızca ileri gider, geri alınamaz.

> **Uygulamada:** "İptal et" butonunu özel siparişte yalnızca
> `isSpecialOrder && supplyStatus === "Preparing"` iken gösterin.
> Normal siparişte kural değişmedi (`Pending` / `Confirmed`).

---

## 4. Uçlar

Hepsinin başında dil öneki var: `/api/:lang/…` — `lang` zorunlu, `tm | ru | en`.
Aksi belirtilmedikçe müşteri JWT'si ister: `Authorization: Bearer <accessToken>`.

---

### `GET /api/:lang/book?status=Finished`

**Keşif listesi.** Stokta olmayan, getirtilebilecek kitaplar. Mevcut tüm filtreler
(`search`, `categoryIds`, `authorIds`, `page`, `limit` …) aynen çalışır. Token istemez.

Ek query parametreleri:

```
status            // Available | Upcoming | Finished
specialOrderable  // true → sadece özel siparişe açık kitaplar
```

Yanıttaki her kitapta artık `specialOrderable` de var.

> **Önemli:** `status` göndermezseniz sonuç **eskisiyle birebir aynı**. Ana listeleme
> ekranınızı değiştirmenize gerek yok.

### Finished kitaplarda fiyat `null` gelir

Stoku bitmiş kitabın fiyatı artık katalogdaki eski fiyat değil, özel sipariş teklifiyle
belirleniyor. Bu yüzden **`status = "Finished"` olan kitaplarda şu alanlar `null` döner:**

```
price · discount · discountType · discountEnd
```

Bu, kitabın döndüğü **tüm** uygulama uçları için geçerli: `GET /book`, `GET /book/:id`,
`GET /user/favorite`, `GET /user/books`. (Sepet bunun dışında — orada fiyat görünmeye
devam eder.)

> **Uygulamada:** `Finished` kitaplarda fiyat alanı yerine "Özel sipariş" / "Fiyat sorunuz"
> yazın; `price` alanını doğrudan formatlamayın, `null` gelirse `NaN` gösterirsiniz.
> İndirim rozetini de çizmeyin — `discount` da `null`.

Kitap detayı artık **`inComingPrice` (alış fiyatı) alanını hiç döndürmüyor** — o alan
yalnızca admin panelini ilgilendiriyor.

---

### `GET /api/:lang/delivery-method`

**Getirtme usulleri.** Token istemez. Talep ekranında "uçakla 7–14 gün, tırla 25–45 gün"
bilgisini göstermek için.

```json
{
  "success": true,
  "count": 2,
  "data": [
    { "id": 1, "name": "Uçar bilen", "minDays": 7,  "maxDays": 14, "active": true, "sortOrder": 1 },
    { "id": 2, "name": "Ýük ulagy bilen", "minDays": 25, "maxDays": 45, "active": true, "sortOrder": 2 }
  ]
}
```

`name` seçilen dile göre gelir. `sortOrder` sırasıyla gösterin.

---

### `POST /api/:lang/special-order`

**Talep aç.** Bir talepte birden fazla kitap olabilir.

```json
{
  "items": [
    { "bookId": 12, "quantity": 2 },
    { "bookId": 15 }
  ],
  "note": "Mümkünse ciltli olsun"
}
```

`quantity` verilmezse 1. Aynı kitap iki kez gönderilirse adetler toplanır.

**400 dönen durumlar**
- Kitap stokta (`status !== Finished`) — normal sipariş verilmeli
- Kitap özel siparişe kapalı (`specialOrderable: false`)
- Kullanıcının **açık** (`Pending`/`Quoted`) bir talebinde zaten o kitap var

---

### `GET /api/:lang/user/special-order`

**Taleplerim.** `page`, `limit`, `status` query parametreleri. Yanıt `count` taşır.

---

### `GET /api/:lang/user/special-order/:id`

**Talep detayı — teklif ekranının beslendiği uç.** Başkasının talebi `404`.

```json
{
  "success": true,
  "data": {
    "id": 1,
    "status": "Quoted",
    "note": "Mümkünse ciltli olsun",
    "adminNote": "C kitabını tedarikçi vermiyor.",
    "quotedAt": "2026-09-02T18:57:42.741Z",
    "quoteExpiresAt": "2026-09-09T18:57:42.710Z",
    "orderId": null,
    "selectedMethod": null,
    "methods": [
      { "id": 1, "name": "Uçar bilen", "minDays": 7, "maxDays": 14, "active": true },
      { "id": 2, "name": "Ýük ulagy bilen", "minDays": 25, "maxDays": 45, "active": true }
    ],
    "totalsByMethod": [
      { "methodId": 1, "total": "900" },
      { "methodId": 2, "total": "670" }
    ],
    "items": [
      {
        "id": 1,
        "bookId": 12,
        "quantity": 2,
        "available": true,
        "selected": false,
        "prices": [
          { "methodId": 1, "unitPrice": "250" },
          { "methodId": 2, "unitPrice": "180" }
        ],
        "book": { "id": 12, "name": "…", "images": [], "author": { "id": 3, "name": "…" }, "language": { "id": 1, "name": "…" } }
      }
    ]
  }
}
```

- `available: false` olan kalem **seçilemez** — üstü çizili gösterin, `adminNote` sebebi açıklar.
- `prices` boş olan kalem o usulle getirilemiyor demektir.
- `totalsByMethod`, **uygun kalemlerin tamamı seçilirse** oluşacak ürün toplamıdır
  (teslimat ücreti hariç). Kullanıcı seçim yaptıkça toplamı `prices × quantity` ile
  kendiniz hesaplayın.
- Tutarlar `Decimal` olduğu için **string** gelir.

---

### `POST /api/:lang/special-order/:id/approve`

**Teklifi onayla.** Müşteri hem usulü hem hangi kitapları alacağını seçer, adresini verir.
**Bu çağrı siparişi oluşturur.**

```json
{
  "methodId": 2,
  "itemIds": [1],
  "etrapId": 1,
  "address": "Aşgabat, 10. köçe 5",
  "desc": "kapıya bırakın",
  "giftCoverId": null
}
```

**Toplam nasıl hesaplanır**

```
toplam = Σ (unitPrice × quantity)   // sadece seçilen kalemler, seçilen usulün fiyatı
       + hediye paketi (varsa)
       + etrap teslimat ücreti
```

**Kupon geçmez** — özel siparişte kâr marjı değişken.

Dönen yanıt doğrudan `Order` nesnesidir: `isSpecialOrder: true`, `status: "Confirmed"`,
`supplyStatus: "Preparing"`. Kullanıcıyı "Siparişlerim"e yönlendirin.

**400 dönen durumlar**
- Talep `Quoted` değil, ya da `quoteExpiresAt` geçmiş
- Seçilen kalem bu talebe ait değil, ya da `available: false`
- Seçilen kalemin bu usul için fiyatı yok
- Usul pasif

---

### `POST /api/:lang/special-order/:id/reject`

**Teklifi reddet.** Yalnızca `Quoted` iken. Gövde: `{ "reason": "pahalı" }` (opsiyonel).

### `POST /api/:lang/special-order/:id/cancel`

**Talebi iptal et.** `Pending` veya `Quoted` iken. Gövde: `{ "reason": "…" }` (opsiyonel).

---

## 5. Sipariş oluştuktan sonra

Mevcut sipariş uçları aynen kullanılır — `GET /user/order`, `GET /user/order/:id`,
`PATCH /user/order/:id/cancel`. Özel siparişlerde yanıtta ek alanlar var:

```json
{
  "isSpecialOrder": true,
  "supplyStatus": "InTransit",
  "estimatedArrival": "2026-10-01T00:00:00.000Z",
  "deliveryMethod": { "id": 1, "name": "Uçar bilen", "minDays": 7, "maxDays": 14 },
  "specialRequest": { "id": 2 }
}
```

`GET /user/order` listesinde `isSpecialOrder=true/false` filtresi de kullanabilirsiniz.

**Tedarik aşaması zaman çizelgesinde görünür.** `statusHistory` içindeki kayıtlarda
`status` alanı `Confirmed` kalırken `note` alanı `OrderedAbroad`, `InTransit`,
`Arrived` değerini (varsa admin notuyla birlikte `"Arrived: Gümrükten çıktı"` biçiminde)
taşır. Zaman çizelgesini çizerken `note` önekini de değerlendirin.

---

## 6. Push bildirimler

`data.type` alanına göre yönlendirin:

| `type` | Ek alanlar | Ne zaman |
|---|---|---|
| `special_order` | `requestId`, `status` | Teklif hazır (`Quoted`), getirtilemiyor (`Unavailable`), süre doldu (`Expired`) |
| `special_order_supply` | `orderId`, `supplyStatus` | Yurtdışından sipariş edildi, yola çıktı, geldi |
| `order_status` | `orderId`, `status` | Mevcut sipariş bildirimleri — değişmedi |

`special_order` → talep detayına, `special_order_supply` → sipariş detayına götürün.

---

## 7. Ekran akışı önerisi

```
Ana sayfa
  └─ "Getirtebiliriz" bölümü            GET /book?status=Finished
       └─ Kitap detayı
            └─ [Özel sipariş ver]        (status === "Finished" && specialOrderable)
                 └─ POST /special-order

Profil
  └─ "Taleplerim"                        GET /user/special-order
       └─ Talep detayı                   GET /user/special-order/:id
            ├─ Quoted → usul seç + kitap seç + adres
            │            └─ POST /special-order/:id/approve  → Siparişlerim
            ├─ [Reddet]                  POST /special-order/:id/reject
            └─ [İptal]                   POST /special-order/:id/cancel

Siparişlerim
  └─ Sipariş detayı                      GET /user/order/:id
       └─ supplyStatus zaman çizelgesi + tahmini varış
            └─ [İptal] yalnızca supplyStatus === "Preparing"
```

---

## 8. Uç noktalar özeti

| Metot | Uç | Auth |
|---|---|---|
| GET | `/book?status=Finished` | — |
| GET | `/delivery-method` | — |
| POST | `/special-order` | Müşteri |
| GET | `/user/special-order` | Müşteri |
| GET | `/user/special-order/:id` | Müşteri |
| POST | `/special-order/:id/approve` | Müşteri |
| POST | `/special-order/:id/reject` | Müşteri |
| POST | `/special-order/:id/cancel` | Müşteri |
| GET | `/special-order` · `/special-order/count` · `/special-order/:id` | Admin |
| PATCH | `/special-order/:id/quote` · `/special-order/:id/decline` | Admin |
| PATCH | `/order/:id/supply` | Admin |
| GET/POST/PATCH/DELETE | `/delivery-method` | Admin (okuma hariç) |
