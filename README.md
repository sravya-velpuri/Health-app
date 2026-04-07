<p align="center">
  <img src="https://img.icons8.com/3d-fluency/94/heart-with-pulse.png" width="80" alt="Health & Wellness Pro Logo"/>
</p>

<h1 align="center">🏥 Health & Wellness Pro</h1>

<p align="center">
  <em>Your all-in-one companion for a healthier, happier lifestyle.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-FFCA28?logo=firebase&logoColor=black" alt="Firebase"/>
  <img src="https://img.shields.io/badge/Material%203-Enabled-6750A4" alt="Material 3"/>
  <img src="https://img.shields.io/badge/Architecture-MVVM-green" alt="MVVM"/>
  <img src="https://img.shields.io/badge/License-MIT-blue" alt="License"/>
</p>

---

## 📖 Overview

**Health & Wellness Pro** is a beautifully designed, feature-rich Flutter application that helps users track and improve their daily health habits. From workout logging and meal tracking to hydration monitoring and sleep analysis — everything you need for a balanced lifestyle is right at your fingertips.

Built with a modern **MVVM architecture**, a stunning **Glassmorphism UI**, and powered by **Firebase**, the app delivers a premium experience across Android and iOS platforms.

---

## ✨ Features

### 🏠 Smart Dashboard
- **Personalized greetings** based on time of day
- **Auto-scrolling Daily Health Tips** carousel with animated indicators
- **Quick Stats grid** — Water, Sleep, Calorie, & Activity goals at a glance
- **BMI Calculator** — Instant access with personalized health insights
- **Motivational quotes** to keep you inspired

### 🏋️ Workout Tracker
- Comprehensive **Exercise Library** with categorized workouts
- **Log workouts** with exercise type, duration, and calories burned
- Historical **workout logs** with date tracking
- Curated tips on home workouts and fitness routines

### 🍽️ Nutrition & Meal Tracker
- **Log meals** with food name, calorie count, and meal type (Breakfast / Lunch / Dinner / Snack)
- **Daily Macro Guide** for proteins, carbs, and fats
- **Top 10 Superfoods** reference section
- Educational content: *"What is a Healthy Diet?"*

### 💧 Hydration Monitor
- **Track daily water intake** with intuitive glass-by-glass logging
- **Set custom daily hydration goals**
- Visual progress indicators
- Learn *"How Water Helps Your Body"*

### 😴 Sleep Tracker
- **Log sleep hours** and analyze sleep quality
- **Sleep Cycle Stages** educational content (Light → Deep → REM)
- **Weekly sleep history** with trend visualization
- Science-backed tips: *"Why Sleep is Crucial"*

### 🧮 BMI Calculator
- Enter height and weight for instant BMI calculation
- **Color-coded result categories** (Underweight / Normal / Overweight / Obese)
- Personalized health tips based on your BMI range

### 👤 User Profile
- **Profile photo** support (Camera & Gallery)
- Editable personal details: Name, Age, Height, Weight, Gender
- **Fitness Goal** selector (Stay Healthy, Lose Weight, Gain Muscle, etc.)
- Account management with secure logout

### 🌍 Multi-Language Support
- Seamless switching between **English**, **Telugu (తెలుగు)**, and **Hindi (हिंदी)**
- All UI labels, navigation, and content dynamically translated in real-time

### 🎨 Premium UI/UX
- **Glassmorphism design** with frosted glass containers and backdrop blur effects
- **Dark Mode & Light Mode** toggle with smooth transitions
- **Google Fonts (Outfit)** for modern typography
- **Material 3** design system with curated color palettes
- Smooth **micro-animations** and gradient backgrounds
- Animated bottom navigation bar with color-coded sections

### 🔐 Authentication
- **Firebase Email/Password** authentication
- Secure **Sign Up** and **Login** flows
- Session persistence with auto-login

---

## 🏗️ Architecture

The project follows the **MVVM (Model-View-ViewModel)** pattern for clean separation of concerns:

```
lib/
├── main.dart                    # App entry point & Provider setup
├── firebase_options.dart        # Firebase configuration
│
├── models/                      # Data models
│   ├── meal_model.dart
│   ├── sleep_model.dart
│   ├── user_model.dart
│   ├── water_model.dart
│   └── workout_model.dart
│
├── views/                       # UI screens
│   ├── auth_screen.dart         # Login / Sign Up
│   ├── splash_screen.dart       # Animated splash screen
│   ├── main_shell.dart          # Bottom navigation shell
│   ├── dashboard_screen.dart    # Home dashboard
│   ├── workout_screen.dart      # Workout tracker
│   ├── meal_screen.dart         # Meal & nutrition tracker
│   ├── water_screen.dart        # Hydration monitor
│   ├── sleep_screen.dart        # Sleep tracker
│   ├── bmi_screen.dart          # BMI calculator
│   └── profile_screen.dart      # User profile management
│
├── viewmodels/                  # Business logic & state
│   ├── auth_viewmodel.dart
│   ├── dashboard_viewmodel.dart
│   ├── workout_viewmodel.dart
│   ├── meal_viewmodel.dart
│   ├── water_viewmodel.dart
│   ├── sleep_viewmodel.dart
│   ├── theme_viewmodel.dart
│   └── profile_viewmodel.dart
│
├── services/                    # Backend & utility services
│   ├── auth_service.dart        # Firebase Auth wrapper
│   ├── firestore_service.dart   # Cloud Firestore operations
│   ├── local_storage_service.dart  # SharedPreferences storage
│   ├── localization_service.dart   # Multi-language translations
│   └── notification_service.dart   # Local push notifications
│
└── theme/                       # Design system
    ├── app_theme.dart           # Light & Dark theme definitions
    └── glass_widgets.dart       # Glassmorphism reusable widget
```

---

## 🛠️ Tech Stack

| Category             | Technology                                       |
|----------------------|--------------------------------------------------|
| **Framework**        | Flutter 3.x with Dart 3.x                        |
| **State Management** | Provider (ChangeNotifier)                        |
| **Architecture**     | MVVM (Model-View-ViewModel)                      |
| **Authentication**   | Firebase Auth (Email/Password)                   |
| **Database**         | Cloud Firestore + SharedPreferences (local)      |
| **Charts**           | fl_chart                                         |
| **Typography**       | Google Fonts (Outfit)                            |
| **Design System**    | Material 3 + Custom Glassmorphism                |
| **Notifications**    | flutter_local_notifications                      |
| **Calendar**         | table_calendar                                   |
| **Image Picker**     | image_picker (Camera & Gallery)                  |
| **Animations**       | Lottie                                           |

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** (3.x or later) — [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK** (3.x or later)
- **Firebase Project** — [Firebase Console](https://console.firebase.google.com/)
- **Android Studio** or **VS Code** with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/sravya-velpuri/Health-app.git
   cd Health-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/)
   - Enable **Email/Password Authentication**
   - Set up **Cloud Firestore**
   - Download `google-services.json` (Android) and place it in `android/app/`
   - Ensure `firebase_options.dart` is configured for your project

4. **Run the app**
   ```bash
   flutter run
   ```

5. **Build for production**
   ```bash
   flutter build apk --release
   ```

---

## 📱 Screens

| Screen | Description |
|--------|-------------|
| 🔐 **Auth** | Clean glassmorphic login/signup with email & password |
| 🏠 **Dashboard** | Health tips carousel, quick stats, BMI access, daily motivation |
| 🏋️ **Workouts** | Exercise library, workout logging, and fitness tips |
| 🍽️ **Meals** | Meal logging, macro guides, and superfood references |
| 💧 **Water** | Glass-by-glass hydration tracking with custom goals |
| 😴 **Sleep** | Sleep logging, cycle education, and weekly trends |
| 🧮 **BMI** | Height/weight input with color-coded health categories |
| 👤 **Profile** | Photo, personal details, goals, language, and dark mode |

---

## 🎨 Design Highlights

- **Glassmorphism** — Frosted glass containers with `BackdropFilter` blur effects
- **Gradient Backgrounds** — Carefully crafted light and dark mode gradients
- **Animated Navigation** — Color-coded bottom bar with expand/collapse labels
- **Auto-scrolling Carousel** — Tips cycle automatically with smooth page transitions
- **Responsive Layout** — Adapts to various screen sizes using `CustomScrollView` and `SliverGrid`

---

## 🤝 Contributing

Contributions are welcome! If you'd like to improve the app:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

## 👩‍💻 Author

**Sravya Velpuri**

- GitHub: [@sravya-velpuri](https://github.com/sravya-velpuri)

---

<p align="center">
  Made with ❤️ and Flutter
</p>
