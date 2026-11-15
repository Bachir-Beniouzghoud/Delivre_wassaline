# wassalni

A new Flutter project.

## Getting Started
lib/
├─ core/       ← أدوات مشتركة لا تعرف شيئاً عن الشاشات
│   ├─ bootstrap/   تهيئة التطبيق (Firebase + قراءة اللغة والثيم) + InitialBinding
│   ├─ enum/        UserRole, OrderStatus, AppMode, DriverStatus, Permission
│   ├─ errors/      أخطاء مخصصة (OrderNotFound, InvalidStatusTransition...)
│   ├─ theme/ localization/ Extenstion/   مظهر، ترجمة، ويدجتات مساعدة
├─ data/       ← كل ما يتعلق بالبيانات
│   ├─ models/          UserModel, DilevreModel, CustomerModel, OrderModel, OrderLocation
│   └─ repositories/
│       ├─ abstractInterface/   العقود: Authuser, UserRepository, OrderRepository
│       └─ implementations/firebase/   التنفيذ الفعلي مع Firebase/Firestore
├─ modules/    ← الميزات (Controller + View + Binding)
│   ├─ auth/ shell/ orders/ customer/ delivery/ shared/
│   └─ bindings/   من يصنع أي Controller لأي صفحة
└─ routes/     ← أسماء المسارات + جدول الصفحات + الحارس
*******************************************************
This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
