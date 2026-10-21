/// Shared field checks. Screens use these inside [Form] validators so the
/// same regular expressions apply on sign up, password changes, and the cart.
abstract final class AppValidators {
  static final RegExp namePattern = RegExp(r'^[A-Za-z]+(?: [A-Za-z]+)*$');
  static final RegExp emailPattern = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );
  static final RegExp phonePattern = RegExp(r'^[6-9][0-9]{9}$');
  static final RegExp passwordPattern = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$',
  );
  static final RegExp promoPattern = RegExp(r'^[A-Za-z][A-Za-z0-9]{3,14}$');

  static String? name(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Enter your full name.';
    if (!namePattern.hasMatch(text)) return 'Use letters only, for example Tirth Kotak.';
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Enter your email.';
    if (!emailPattern.hasMatch(text)) return 'Enter a valid email, for example name@gmail.com.';
    return null;
  }

  static String? phone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Enter your phone number.';
    if (!phonePattern.hasMatch(text)) return 'Enter a 10-digit mobile number starting with 6–9.';
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Enter a password.';
    if (!passwordPattern.hasMatch(text)) {
      return 'Use 8+ characters with uppercase, lowercase, a number, and a symbol.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if ((value ?? '').isEmpty) return 'Confirm your password.';
    if (value != original) return 'Passwords do not match.';
    return null;
  }

  static String? requiredPassword(String? value, {String label = 'Enter your current password.'}) {
    if ((value ?? '').isEmpty) return label;
    return null;
  }

  static String? promo(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Enter a promo code.';
    if (!promoPattern.hasMatch(text)) return 'Use 4–15 letters and numbers, starting with a letter.';
    return null;
  }
}
