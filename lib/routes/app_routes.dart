/// أسماء المسارات في مكان واحد (لا تكتب نصوص المسارات يدوياً في أي مكان آخر)
abstract final class AppRoutes {
  /// شاشة البداية: تفحص الجلسة وتقرر الصفحة الأولى
  static const splash = '/splash';

  /// صفحة الدخول/التسجيل (كانت PagesRout.authsecrin)
  static const auth = '/auth';

  /// الهيكل الرئيسي بوضعي الزبون والسائق
  static const shell = '/shell';
}
