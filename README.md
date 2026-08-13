# Railway Panel (3x-ui on Railway)

یک پروژهٔ مستقل و تمیز برای بالا آوردن پنل پروکسی روی Railway. داخلش پنل
**3x-ui** اجرا می‌شود — همان پنل استانداردی که انواع کانفیگ را می‌سازد.

## چرا 3x-ui و نه چیز دیگر؟

پنل‌های کامل مثل Nova-Server به VPS واقعی نیاز دارند (root + systemd + پورت
TCP و UDP هم‌زمان). Railway فقط **HTTP و TCP** اکسپوز می‌کند (UDP ندارد)، پس
پروتکل‌های UDP مثل Hysteria2 / TUIC / WireGuard / mKCP روی Railway کار نمی‌کنند.
3x-ui روی Railway استارت می‌شود و همهٔ پروتکل‌های TCP را می‌سازد:

| پروتکل | روی Railway |
|---|---|
| VLESS + Reality / TLS | ✅ |
| VMess + WS / gRPC / TCP | ✅ |
| Trojan + WS / gRPC / TCP | ✅ |
| Shadowsocks (TCP) | ✅ |
| Hysteria2 / TUIC | ❌ (نیاز به UDP) |
| WireGuard / AmneziaWG | ❌ (نیاز به UDP) |
| mKCP / QUIC | ❌ (نیاز به UDP) |

## دیپلوی روی Railway

1. این پوشه را به‌عنوان یک ریپو جدا push کنید (یا مستقیم از دکمه Deploy on Railway).
2. Railway خودش `railway.toml` را می‌خواند و دو پورت باز می‌کند:
   - `2053` → HTTP (پنل)
   - `443` → TCP proxy (ترافیک پروکسی)
3. بعد از دیپلوی، در لاگ سرویس این خطوط چاپ می‌شود:

```
panel    : https://xxx.up.railway.app/panel
proxy    : xxxxxxxx.up.railway.app:34125
```

- **ورود به پنل:** آدرس `panel` با `admin / admin` (بعد از ورود حتماً رمز را عوض کنید).
- **در کلاینت:** آدرس/پورت = همان خط `proxy` (نه 443).

## ساخت کانفیگ

در پنل: **Inbounds → Add Inbound** و پروتکل دلخواه را بسازید (VLESS، VMess،
Trojan، Shadowsocks، Reality و…). اینباند را روی **پورت 443** بگذارید؛ کلاینت‌ها
به آدرس `proxy` از لاگ وصل می‌شوند.

## متغیرهای محیطی (اختیاری)

| متغیر | پیش‌فرض | توضیح |
|---|---|---|
| `WEB_PORT` | `2053` | پورت پنل |
| `WEB_PATH` | `panel` | مسیر پنل؛ خالی = روت `/` |

## ⚠️ نکته

Railway استفاده به‌عنوان پروکسی/VPN را در قوانینش ممنوع کرده و ترافیک را با
الگوی شبکه تشخیص می‌دهد. برای تست موقت خوب است، ولی برای استفادهٔ جدی و پایدار
یک VPS (با UDP و IP اختصاصی) بگیرید و آنجا Nova-Server یا 3x-ui را نصب کنید.
