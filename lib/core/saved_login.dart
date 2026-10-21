import 'package:shared_preferences/shared_preferences.dart';
import 'package:textiles/resources/app_text.dart';

/// Remembers the last successful shop login on this device.
class SavedLogin {
  static const _emailKey = 'saved_login_email';
  static const _passwordKey = 'saved_login_password';

  static Future<({String email, String password})> load() async {
    final prefs = await SharedPreferences.getInstance();
    return (
      email: prefs.getString(_emailKey) ?? AppText.demoShopEmail,
      password: prefs.getString(_passwordKey) ?? AppText.demoShopPassword,
    );
  }

  static Future<void> save({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email.trim());
    await prefs.setString(_passwordKey, password);
  }
}
