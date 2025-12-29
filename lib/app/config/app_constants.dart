/// Constantes generales de la aplicación
class AppConstants {
  AppConstants._(); // Constructor privado

  // ==================== APP INFO ====================

  static const String appName = 'ListShare';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appDescription =
      'Organiza y comparte tus listas fácilmente';

  // ==================== MONEDAS ====================

  static const List<Map<String, String>> currencies = [
    {'code': 'USD', 'name': 'Dólar'},
    {'code': 'EUR', 'name': 'Euro'},
    {'code': 'GBP', 'name': 'Libra'},
    {'code': 'ARS', 'name': 'Peso argentino'},
    {'code': 'MXN', 'name': 'Peso mexicano'},
    {'code': 'COP', 'name': 'Peso colombiano'},
    {'code': 'CLP', 'name': 'Peso chileno'},
  ];

  // ==================== LÍMITES ====================

  static const int maxListNameLength = 50;
  static const int maxProductNameLength = 100;
  static const int maxCategoryNameLength = 30;
  static const int maxProductQuantity = 99;
  static const int minCategories = 1;
  static const int maxRecentLists = 5;

  // ==================== TIMEOUTS ====================

  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration shortDelay = Duration(milliseconds: 300);
  static const Duration mediumDelay = Duration(milliseconds: 600);
  static const Duration longDelay = Duration(seconds: 1);

  // ==================== STORAGE KEYS ====================

  static const String keyThemeMode = 'theme_mode';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserData = 'user_data';
  static const String keyCategories = 'categories';
  static const String keyLists = 'shopping_lists';
  static const String keyFirstTimeInit = 'first_time_init';

  // ==================== MOCK URLs ====================

  static const String mockShareUrl = 'https://listshare.app/list/';
  static const String termsUrl = 'https://listshare.app/terms';
  static const String privacyUrl = 'https://listshare.app/privacy';
}
