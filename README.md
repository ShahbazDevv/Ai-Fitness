<div align="center">
  <img src="https://raw.githubusercontent.com/ShahbazDevv/ai-fitness/main/assets/ai_based_fitness_logo/logo.png" alt="AI Fitness Logo" width="120" height="120">

  # 🏋️ AI Fitness

  <p align="center">
    <b>Your Personal AI-Powered Fitness Coach — Transform Your Body with Intelligence</b>
  </p>

  <p align="center">
    <img src="https://img.shields.io/badge/Flutter-3.29+-02569B?logo=flutter&logoColor=white" alt="Flutter">
    <img src="https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart&logoColor=white" alt="Dart">
    <img src="https://img.shields.io/badge/GetX-4.6-E91E63?logo=getx&logoColor=white" alt="GetX">
    <img src="https://img.shields.io/badge/Supabase-3FCF8E?logo=supabase&logoColor=white" alt="Supabase">
    <img src="https://img.shields.io/badge/Gemini%20AI-4285F4?logo=google&logoColor=white" alt="Gemini AI">
    <img src="https://img.shields.io/badge/Material%203-0066FF?logo=materialdesign&logoColor=white" alt="Material 3">
    <img src="https://img.shields.io/badge/Android-3DDC84?logo=android&logoColor=white" alt="Android">
  </p>

  <br>
</div>

---

## 📖 About

**AI Fitness** is a next-generation fitness application that leverages artificial intelligence to deliver personalized workout plans, diet recommendations, and real-time body analysis. Built with Flutter and powered by HuggingFace AI models, the app serves as your complete digital fitness companion.

<div align="center">

| What You Can Do | |
|---|---|
| 🔐 Create account & login securely | 🧠 Chat with AI Coach |
| 📸 Analyze body with AI vision | 💪 Get AI-powered workout plans |
| 🥗 Receive personalized diet plans | 📊 Track BMI & FFMI |
| 💧 Monitor water intake | 📈 Track fitness progress |
| 🏃 Daily activity tracking | 🔔 Smart notifications |
| 🎨 Beautiful dark Material 3 UI | 📱 Responsive design |

</div>

---

## ✨ Features

<div align="center">

| Feature | | Feature | |
|---------|---|---------|---|
| ✅ **Authentication** | Email/password auth with Supabase | ✅ **AI Coach** | Contextual chat with HuggingFace Mistral-7B |
| ✅ **AI Body Analysis** | Vision-based body scan from photos | ✅ **Workout Plans** | Push/Pull/Legs/Full Body routines |
| ✅ **Diet Plans** | Full-day meal plans with macros | ✅ **BMI Calculator** | Body Mass Index with status |
| ✅ **FFMI Calculator** | Fat-Free Mass Index analytics | ✅ **Progress Tracking** | Weight logs & body fat estimation |
| ✅ **Water Tracker** | Daily hydration logging | ✅ **Daily Activity** | Steps, calories, distance tracking |
| ✅ **Health Integration** | Apple Health & Google Fit sync | ✅ **Profile Management** | Full user profile with goals |
| ✅ **Onboarding** | Interactive 3-page intro | ✅ **Dark Theme** | Premium Material 3 dark design |
| ✅ **Glassmorphism UI** | Modern glass design system | ✅ **Responsive UI** | Screen-adaptive layouts |
| ✅ **Supabase Backend** | Auth, DB & cloud storage | ✅ **Connectivity** | Real-time network monitoring |
| ✅ **Notifications** | In-app smart alerts | ✅ **Settings** | Units, preferences, dark mode |
| ✅ **Premium** | Subscription upgrade screen | ✅ **Support** | In-app help & about pages |

</div>

---

## 🛠️ Tech Stack

<div align="center">

| Category | Technologies |
|----------|-------------|
| **Framework** | Flutter 3.29+ |
| **Language** | Dart 3.12+ |
| **State Management** | GetX 4.6 (Reactive state, DI, routing) |
| **Backend** | Supabase (Auth, PostgreSQL, Storage) |
| **AI Engine** | HuggingFace API (Mistral-7B-Instruct) |
| **Design** | Material 3, Glassmorphism |
| **Responsive** | flutter_screenutil |
| **Typography** | Google Fonts |
| **Charts** | fl_chart |
| **Animations** | Lottie, flutter_svg |
| **Health Data** | health (Apple Health / Google Fit) |
| **Network** | http, connectivity_plus |
| **Storage** | shared_preferences, cached_network_image |
| **Permission** | permission_handler |
| **Media** | image_picker |
| **Utilities** | intl, uuid, path_provider, flutter_dotenv |

</div>

---

## 📁 Project Structure

```
lib/
├── bindings/              # GetX dependency injection bindings
│   ├── initial_binding.dart
│   ├── auth_binding.dart
│   ├── dashboard_binding.dart
│   ├── ai_coach_binding.dart
│   ├── ai_scan_binding.dart
│   ├── fitness_binding.dart
│   ├── onboarding_binding.dart
│   ├── profile_binding.dart
│   ├── progress_binding.dart
│   ├── settings_binding.dart
│   └── splash_binding.dart
├── config/
│   └── environment.dart   # Environment variable access
├── constants/
│   ├── app_colors.dart    # Crimson dark theme palette
│   ├── app_images.dart    # Asset image references
│   ├── app_strings.dart   # String constants
│   └── app_text_styles.dart
├── controllers/           # GetX controllers (business logic)
│   ├── auth_controller.dart
│   ├── ai_coach_controller.dart
│   ├── ai_scan_controller.dart
│   ├── dashboard_controller.dart
│   ├── fitness_controller.dart
│   ├── main_controller.dart
│   ├── onboarding_controller.dart
│   ├── profile_controller.dart
│   ├── progress_controller.dart
│   ├── settings_controller.dart
│   └── splash_controller.dart
├── features/              # View layer by feature
│   ├── activity/
│   ├── ai_coach/
│   ├── ai_scan/
│   ├── auth/
│   ├── bmi/
│   ├── dashboard/
│   ├── diet/
│   ├── main/
│   ├── notifications/
│   ├── onboarding/
│   ├── premium/
│   ├── profile/
│   ├── progress/
│   ├── settings/
│   ├── splash/
│   ├── support/
│   ├── water/
│   └── workout/
├── models/                # Data models
│   ├── chat_model.dart
│   ├── diet_model.dart
│   ├── progress_model.dart
│   ├── user_model.dart
│   └── workout_model.dart
├── repositories/          # Data abstraction layer
│   ├── ai_repository.dart
│   ├── auth_repository.dart
│   ├── fitness_repository.dart
│   └── profile_repository.dart
├── routes/                # Route definitions
│   ├── app_pages.dart
│   └── app_routes.dart
├── services/              # External integrations
│   ├── ai/
│   │   ├── ai_coach_service.dart
│   │   ├── conversation_manager.dart
│   │   └── prompt_builder.dart
│   ├── connectivity_service.dart
│   ├── health_service.dart
│   ├── huggingface_service.dart
│   ├── notification_service.dart
│   ├── storage_service.dart
│   └── supabase_service.dart
├── theme/
│   └── app_theme.dart     # Material 3 dark theme
├── widgets/               # Reusable UI components
│   ├── ai_chat_bubble.dart
│   ├── animated_progress_bar.dart
│   ├── app_logo.dart
│   ├── custom_image.dart
│   ├── glass_button.dart
│   ├── glass_card.dart
│   ├── glass_textfield.dart
│   ├── onboarding_illustration.dart
│   ├── progress_ring.dart
│   └── responsive_helper.dart
└── main.dart              # App entry point
```

---

## 📱 App Screenshots

<div align="center">

| Splash | Login | Signup | Home |
|--------|-------|--------|------|
| <img src="screenshots/splash.png" width="220"> | <img src="screenshots/login.png" width="220"> | <img src="screenshots/signup.png" width="220"> | <img src="screenshots/home.png" width="220"> |

| AI Coach | Body Scan | Workout | Diet Plan |
|----------|-----------|---------|-----------|
| <img src="screenshots/aicoach.png" width="220"> | <img src="screenshots/bodyscan.png" width="220"> | <img src="screenshots/workout.png" width="220"> | <img src="screenshots/diet.png" width="220"> |

| Progress | Profile | Water Tracker | BMI |
|----------|---------|---------------|-----|
| <img src="screenshots/progress.png" width="220"> | <img src="screenshots/profile.png" width="220"> | <img src="screenshots/water.png" width="220"> | <img src="screenshots/bmi.png" width="220"> |

</div>

---

## 🚀 Installation

### Prerequisites

- Flutter SDK 3.29+
- Dart 3.12+
- Android Studio / VS Code
- A Supabase project
- HuggingFace API key (or use offline mock mode)

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/ShahbazDevv/ai-fitness.git

# 2. Navigate to project
cd ai-fitness

# 3. Install dependencies
flutter pub get

# 4. Create environment file
cp .env.example .env
```

### Configuration

Edit `.env` with your credentials:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
HF_API_KEY=your-huggingface-api-key
HF_MODEL=mistralai/Mistral-7B-Instruct-v0.3
HF_BASE_URL=https://router.huggingface.co/hf/v1
```

### Run

```bash
# For Android
flutter run

# For iOS
cd ios && pod install && cd ..
flutter run

# For web
flutter run -d chrome

# For Windows
flutter run -d windows

# For macOS
flutter run -d macos

# For Linux
flutter run -d linux
```

---

## 🔐 Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `SUPABASE_URL` | ✅ | Your Supabase project URL |
| `SUPABASE_ANON_KEY` | ✅ | Supabase anonymous API key |
| `HF_API_KEY` | ❌* | HuggingFace API key for AI features |
| `HF_MODEL` | ❌ | HuggingFace model ID (default: Mistral-7B-Instruct) |
| `HF_BASE_URL` | ❌ | HuggingFace API base URL |

> *⚠️ **Mock Mode**: If `HF_API_KEY` is empty, the app runs in offline mock mode with realistic simulated responses — perfect for testing and development.

---

## 🏗️ Architecture

The app follows **MVVM** architecture powered by **GetX**:

```
View (UI)
  │  observes
  ▼
Controller (GetX Controller)
  │  calls
  ▼
Repository (Data Abstraction)
  │  delegates
  ▼
Service (External Integration)
  │
  ├── SupabaseService (Auth, Database, Storage)
  ├── HuggingFaceService (AI completions, Vision)
  ├── HealthService (Apple Health / Google Fit)
  ├── ConnectivityService (Network status)
  ├── StorageService (SharedPreferences)
  └── NotificationService (In-app alerts)
```

**Key patterns:**
- **GetX Bindings** — Lazy dependency injection for services and controllers
- **Reactive State** — `Rx` observables with automatic UI updates
- **Repository Pattern** — Abstract data access behind repository interfaces
- **Feature-based Organization** — Each feature has dedicated views, bindings, and routes
- **Service Locator** — All services registered via `Get.put()` in `InitialBinding`

---

## 🔮 Future Improvements

- [ ] **Google Fit / Apple Health** — Deeper bidirectional health data sync
- [ ] **Wear OS / watchOS** — Companion watch app for quick tracking
- [ ] **Exercise Analytics** — Performance trends, volume tracking, PR detection
- [ ] **Meal Recognition** — AI-powered food photo analysis for automatic logging
- [ ] **Voice AI Coach** — Speech-to-text interaction with the coach
- [ ] **Advanced Charts** — Body composition trends, strength progression graphs
- [ ] **Push Notifications** — Workout reminders, hydration alerts, motivation nudges
- [ ] **Cloud Sync** — Cross-device data synchronization
- [ ] **Social Features** — Workout sharing, challenges, leaderboards
- [ ] **Offline Mode** — Full offline capability with local AI fallback
- [ ] **Workout Timer** — Built-in rest timer with haptic feedback
- [ ] **Sleep Tracking** — Integration with sleep data for recovery insights

---

## 👨‍💻 Author

<div align="center">
  <p>
    <b>Shahbaz Devv</b><br>
    <a href="https://github.com/ShahbazDevv">
      <img src="https://img.shields.io/badge/GitHub-ShahbazDevv-181717?logo=github&logoColor=white" alt="GitHub">
    </a>
  </p>
</div>

---

## 📄 License

```
MIT License

Copyright (c) 2026 ShahbazDevv

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

<div align="center">
  <p>Made with ❤️ and Flutter</p>
  <p>⭐ Star this repository if you found it useful!</p>
</div>
