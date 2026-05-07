# CanteenGo

A Flutter-based smart canteen ordering app for students and staff. Browse the menu, order food, pay via a digital wallet, and track your order status in real time — all from your phone.

---

## Features

### Authentication
- Register with name, email, phone, and optional student/staff ID
- Login with any valid credentials (demo mode — no backend required)
- Session persisted across app restarts via SharedPreferences

### Home
- Personalized greeting with wallet balance card
- Category filter (All, Breakfast, Lunch, Snacks, Beverages, Desserts)
- Live search across all menu items
- "Popular Now" horizontal carousel
- "Recommended" grid that reacts to selected category and search
- Quick navigation to wallet top-up

### Menu
- Full menu grid with search and category filter
- Each card shows image, veg/non-veg indicator, rating, prep time, and price

### Item Detail
- Hero food image with loading placeholder
- Nutritional info (calories estimate, serving size, prep time)
- Description, tags, and "What's Included" section
- Quantity selector
- Similar items carousel
- Add to cart with toast confirmation

### Cart & Checkout
- Cart with item quantities, subtotal, 5% tax, and total
- Wallet balance validation before placing order
- Special instructions field
- Order placed with a unique token number

### Order Tracking
- Active and past orders tabs
- Live status progression: Confirmed → Preparing → Ready → Completed
- QR code for order collection
- Estimated ready time display
- Cancel order (before "Preparing")

### Wallet
- Current balance display
- Quick top-up grid (TSh 2,000 – 100,000)
- Custom amount entry
- Transaction recorded immediately

### Profile
| Setting | Behaviour |
|---------|-----------|
| Edit Profile | Bottom sheet — update name, email, phone |
| Saved Addresses | Add / delete campus pickup locations |
| Notifications | Toggle order updates and promo alerts |
| Language | Switch between English and Swahili |
| Theme | Light / Dark mode toggle (persisted) |
| Help & FAQ | Expandable answers to common questions |
| Send Feedback | Star rating + free-text form |
| About | App version info |

---

## Tech Stack

| Layer | Package |
|-------|---------|
| State management | [provider](https://pub.dev/packages/provider) ^6.1.2 |
| Fonts | [google_fonts](https://pub.dev/packages/google_fonts) ^6.2.1 |
| Persistence | [shared_preferences](https://pub.dev/packages/shared_preferences) ^2.3.2 |
| Image caching | [cached_network_image](https://pub.dev/packages/cached_network_image) ^3.4.1 |
| QR codes | [qr_flutter](https://pub.dev/packages/qr_flutter) ^4.1.0 |
| Date formatting | [intl](https://pub.dev/packages/intl) ^0.19.0 |
| Unique IDs | [uuid](https://pub.dev/packages/uuid) ^4.5.1 |
| Toasts | [fluttertoast](https://pub.dev/packages/fluttertoast) ^8.2.8 |

---

## Project Structure

```
lib/
├── main.dart                    # App entry point, providers setup
├── theme/
│   └── app_theme.dart           # Light & dark themes, brand colours
├── models/
│   ├── user.dart
│   ├── menu_item.dart
│   ├── cart_item.dart
│   └── order.dart
├── providers/
│   ├── auth_provider.dart       # Login, register, wallet, profile update
│   ├── menu_provider.dart       # Menu items, categories, search/filter
│   ├── cart_provider.dart       # Cart state, quantities, totals
│   ├── order_provider.dart      # Order lifecycle & status simulation
│   └── settings_provider.dart   # Theme, language, notifications, addresses
├── screens/
│   ├── splash_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   │   ├── main_screen.dart     # Bottom nav scaffold
│   │   └── home_screen.dart
│   ├── menu/
│   │   ├── menu_screen.dart
│   │   └── item_detail_screen.dart
│   ├── cart/
│   │   ├── cart_screen.dart
│   │   └── checkout_screen.dart
│   ├── orders/
│   │   ├── orders_screen.dart
│   │   └── order_detail_screen.dart
│   ├── profile/
│   │   └── profile_screen.dart
│   └── wallet/
│       └── wallet_screen.dart
└── widgets/
    └── menu_item_card.dart
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.10.0
- Android SDK or Xcode (for iOS)
- On Windows: enable **Developer Mode** in system settings (required for plugin symlinks)

### Run

```bash
# Clone the repo
git clone https://github.com/your-org/canteen_app.git
cd canteen_app

# Install dependencies
flutter pub get

# Run on a connected device or emulator
flutter run
```

### Build release APK

```bash
flutter build apk --release
```

The output APK is at `build/app/outputs/flutter-apk/app-release.apk`.

---

## Demo Login

The app uses a mock authentication system — **any non-empty email and password will work**.

| Field | Value |
|-------|-------|
| Email | `student@university.ac.tz` |
| Password | `password123` |

The username shown in the app is derived from the part before `@` in the email.  
Every new login starts with a wallet balance of **TSh 10,000**.

---

## Currency

All prices are in **Tanzanian Shillings (TSh)**. Sample price range:

| Item | Price |
|------|-------|
| Chai (Tea) | TSh 1,000 |
| Mandazi (3 pcs) | TSh 1,500 |
| Ugali & Beans | TSh 2,500 |
| Veg Sandwich | TSh 2,500 |
| Cold Coffee | TSh 3,000 |
| Masala Dosa | TSh 3,500 |
| Grilled Chicken | TSh 7,000 |
| Chicken Biryani | TSh 8,000 |

---

## Brand Colours

| Token | Hex | Usage |
|-------|-----|-------|
| Primary | `#FF6B35` | Buttons, active states, highlights |
| Secondary | `#2EC4B6` | Accents, order status |
| Accent | `#FFB627` | Ratings, star icons |
| Error | `#E63946` | Non-veg indicator, delete actions |
| Success | `#06A77D` | Veg indicator, order ready |

---

## Order Flow

```
Browse menu → Add to cart → Checkout → Place order
     ↓
Token number + QR code issued
     ↓
Confirmed → Preparing (5 s) → Ready (15 s) → Collected
```

Orders can be cancelled while in **Confirmed** status. Status progression is simulated automatically for demo purposes.

---

## License

This project is private. All rights reserved.
