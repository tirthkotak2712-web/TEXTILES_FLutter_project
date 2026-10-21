import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:textiles/core/saved_login.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/resources/app_text.dart';
import 'package:textiles/screens/admin/admin_dashboard_screen.dart';
import 'package:textiles/core/validators.dart';
import 'package:textiles/screens/user/forgot_password_screen.dart';
import 'package:textiles/screens/user/signup_screen.dart';
import 'package:textiles/screens/user/user_shell.dart';
import 'package:textiles/widgets/app_bar.dart';
import 'package:textiles/widgets/common.dart';
import 'package:textiles/widgets/textile_mark.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: AppText.demoShopEmail);
  final _password = TextEditingController(text: AppText.demoShopPassword);
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _restoreSavedLogin();
  }

  Future<void> _restoreSavedLogin() async {
    final saved = await SavedLogin.load();
    if (!mounted) return;
    _email.text = saved.email;
    _password.text = saved.password;
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _enter(bool admin) async {
    final store = context.read<StoreRepository>();
    if (admin) {
      store.loginAsAdmin();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(builder: (_) => const AdminDashboardScreen()),
        (_) => false,
      );
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final error = store.login(email: _email.text, password: _password.text);
    if (error != null) {
      if (!mounted) return;
      showAppMessage(context, error);
      return;
    }
    await SavedLogin.save(email: _email.text, password: _password.text);
    TextInput.finishAutofillContext(shouldSave: true);
    if (!mounted) return;
    final home = store.isAdmin
        ? const AdminDashboardScreen()
        : const UserShell();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(builder: (_) => home),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => goBack(context),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            const BrandLogo(width: 210),
            const SizedBox(height: 12),
            const Text(
              AppText.welcomeBack,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            const Text(
              AppText.loginSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, fontSize: 16),
            ),
            const SizedBox(height: 22),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [
                      AutofillHints.username,
                      AutofillHints.email,
                    ],
                    textInputAction: TextInputAction.next,
                    validator: AppValidators.email,
                    decoration: AppStyles.field(hint: 'Enter your email'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Password',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _password,
                    obscureText: _obscure,
                    autofillHints: const [AutofillHints.password],
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _enter(false),
                    validator: (value) => AppValidators.requiredPassword(
                      value,
                      label: 'Enter your password.',
                    ),
                    decoration: AppStyles.field(
                      hint: 'Enter your password',
                      suffix: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                  ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            PrimaryButton(label: 'Login', onPressed: () => _enter(false)),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const ForgotPasswordScreen(),
                  ),
                ),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: AppColors.green,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const SignupScreen(),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: AppColors.green,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: TextButton(
                onPressed: () => _enter(true),
                child: const Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
