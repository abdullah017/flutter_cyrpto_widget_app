# Crypto Widget App

Bitcoin fiyatini anlik takip eden Flutter uygulamasi ve Jetpack Glance tabanli Android Home Screen Widget.

## Ekran Goruntuleri

<p align="center">
  <img src="https://github.com/user-attachments/assets/b8de818b-341d-444e-ac00-2dc0b39762a1" width="280" alt="App Screenshot"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/e71fb86e-272f-400a-b893-172a4983d94c" width="280" alt="Widget Screenshot"/>
</p>

## Ozellikler

- **Anlik Fiyat Takibi** - CoinGecko API ile Bitcoin fiyati
- **Home Screen Widget** - Jetpack Glance ile modern widget
- **Anlik Guncelleme** - Widget butonu ile < 1 saniyede guncelleme
- **Otomatik Guncelleme** - Uygulama acikken 30 sn, arka planda 15 dk
- **Renk Kodlu Degisim** - Yesil (yukselis) / Kirmizi (dusus)
- **Dark Theme** - Modern karanlik tema tasarimi

## Teknolojiler

| Katman | Teknoloji |
|--------|-----------|
| Frontend | Flutter 3.x |
| Widget | Jetpack Glance 1.1.1 |
| Native | Kotlin 2.2.20 |
| API | CoinGecko (Ucretsiz) |
| Arka Plan | WorkManager |

## Kurulum

```bash
# Repoyu klonla
git clone https://github.com/user/crypto_widget_app.git
cd crypto_widget_app

# Bagimliliklari yukle
flutter pub get

# Uygulamayi calistir
flutter run
```

## Kullanim

1. Uygulamayi yukle ve ac
2. Ana ekrana uzun bas → Widgets → "BTC Fiyat Widget" sec
3. Uygulamadan "Widget Guncelle" butonuna bas
4. Widget aninda guncellenecek

## Proje Yapisi

```
lib/
├── main.dart                    # Ana uygulama UI
└── services/
    ├── crypto_service.dart      # CoinGecko API
    ├── widget_service.dart      # Flutter ↔ Native koprüsü
    └── background_service.dart  # WorkManager

android/app/src/main/kotlin/.../
├── MainActivity.kt              # MethodChannel
├── CryptoGlanceWidget.kt       # Glance UI (Compose)
├── CryptoWidgetReceiver.kt     # Widget Receiver
└── CryptoWidgetUpdater.kt      # Anlik guncelleme
```

## API

```
GET https://api.coingecko.com/api/v3/simple/price
    ?ids=bitcoin
    &vs_currencies=usd
    &include_24hr_change=true
```

## Guncelleme Sureci

```
Flutter App
    ↓
MethodChannel ("updateWidget")
    ↓
CryptoWidgetUpdater.updateWidget()
    ↓
updateAppWidgetState() + widget.update()
    ↓
Widget ANLIK guncellenir
```

## Gereksinimler

- Flutter 3.10+
- Android SDK 26+ (Android 8.0)
- Kotlin 2.0+

## Lisans

MIT License

