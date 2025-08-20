# 📱 Citizen Report Incident App

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-3FCF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Bloc](https://img.shields.io/badge/Bloc-5A5A5A?logo=flutter&logoColor=white)](https://bloclibrary.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A **Flutter mobile application** that enables users to report and track incidents in real-time.  
The app integrates with **Supabase** for authentication, database, and storage, and uses **Firebase Cloud Messaging (FCM)** for push notifications.  

---

## 🚀 Features
- 🔑 **User Authentication** (Register, Login, Session management with Supabase Auth)  
- 📝 **Report Incidents** with title, description, category, geolocation, and images  
- 📰 **View Feed** of all submitted incidents in real time  
- 🔔 **Push Notifications** when new incidents are reported  
- 📡 **Offline Handling** with network checks & user-friendly error messages  
- 🧩 **Clean Architecture** — UI → Bloc → UseCase → Repository → Remote Source  

---

## 🛠️ Tech Stack
- **Frontend**: Flutter & Dart  
- **State Management**: Bloc Pattern  
- **Backend**: Supabase (Auth, Database, Storage)  
- **Notifications**: Firebase Cloud Messaging (FCM)  
- **Dependency Injection**: GetIt  
- **Environment Management**: `.env` with `flutter_dotenv`  

---

## 📂 Project Structure
```bash
lib/
 ├── core/
 │   ├── routes/          # App routing (go_router)
 │   ├── service/         # Supabase, DI, local storage, connectivity
 │   └── utils/           # Helpers (snackbars, screen utils, etc.)
 ├── features/
 │   ├── auth/            # Login, Register, AuthBloc, repository
 │   ├── incidents/       # IncidentBloc, repository, remote sources, UI pages
 │   └── notifications/   # Notification use case
 ├── app.dart             # Root widget + routing
 └── main.dart            # App entry point, initialization

## ⚙️ Setup & Installation
git clone https://github.com/your-username/citizen-report-incident.git
cd citizen-report-incident


⚙️ Setup & Installation

Clone the repository

git clone https://github.com/your-username/citizen-report-incident.git
cd citizen-report-incident


Install dependencies

flutter pub get


Configure environment variables

Create a .env file in the root directory:

SUPABASE_URL=your-supabase-url
SUPABASE_ANON_KEY=your-supabase-anon-key


Ensure .env is included in pubspec.yaml under assets.

Run the app

flutter run


## 🔑 Key Implementation Highlights

Authentication Flow: Supabase Auth via AuthRemoteSource, with sessions cached in LocalStorageService.

Incident Upload Flow: Form → Bloc → Use Case → Repository → Supabase DB + Storage.

Notifications: FCM tokens stored in Supabase → new incidents trigger push alerts.

Error Handling: Remote exceptions mapped to domain Failure → surfaced by Bloc states.

# 📸 Screenshots
![Login Page](image.png)
![Sign Up](image-1.png)
![Home page](image-2.png)
![Home page](image-3.png)
![Upload incident page](image-4.png)
![select incident by category](image-5.png)
![select incident by category](image-6.png)


👤 Author
David (Dhayve)
Mobile & Backend Engineer

📄 License
This project is licensed under the MIT License. See the LICENSE
 file for details.