import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wassalni/core/constounts/varaible.dart';
import 'package:wassalni/core/localization/Translations.dart';
import 'package:wassalni/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wassalni/routes/Pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? langCode = prefs.getString(Varaible.selectedlanguage);
  print(langCode );
  print("ينيوةشسةويشوةسيوشيسشويوشة" );
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase Connected Successfully!');
    debugPrint('Firebase App: ${Firebase.app().name}');
  } catch (e) {
    debugPrint('Firebase Error: $e');
  }
  runApp(MyApp(langCode: langCode));
}

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Register
  Future<UserCredential> register(String email, String password) async {
    return await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Login
  Future<UserCredential> login(String email, String password) async {
    return await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Logout
  Future<void> logout() async {
    await auth.signOut();
  }

  // Current User
  User? get currentUser => auth.currentUser;

  // Auth State
  Stream<User?> get authState => auth.authStateChanges();
}

class MyApp extends StatelessWidget {
  final String? langCode;
  const MyApp({super.key, this.langCode});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: PagesRout.homeTest,
      translations: AppTranslations(),
      locale: langCode != null ? Locale("ar") : Get.deviceLocale,
      getPages: PagesRout.pages,
    );
  }
}
