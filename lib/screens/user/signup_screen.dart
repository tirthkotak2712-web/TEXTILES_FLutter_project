import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/core/validators.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/resources/app_text.dart';
import 'package:textiles/screens/user/user_shell.dart';
import 'package:textiles/widgets/app_bar.dart';
import 'package:textiles/widgets/common.dart';
import 'package:textiles/widgets/textile_mark.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final error = context.read<StoreRepository>().signUp(
          name: _name.text,
          email: _email.text,
          phone: _phone.text,
          password: _password.text,
          confirm: _confirm.text,
        );
    if (error != null) {
      showAppMessage(context, error);
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(builder: (_) => const UserShell()),
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
            const BrandLogo(width: 200),
            const SizedBox(height: 8),
            const Text(
              AppText.createAccount,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            const Text(
              AppText.signupSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 18),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Full Name'),
                  TextFormField(
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    validator: AppValidators.name,
                    decoration: AppStyles.field(hint: 'Enter your name'),
                  ),
                  _label('Email'),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: AppValidators.email,
                    decoration: AppStyles.field(hint: 'Enter your email'),
                  ),
                  _label('Phone Number'),
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    validator: AppValidators.phone,
                    decoration: AppStyles.field(hint: 'Enter your phone number'),
                  ),
                  _label('Password'),
                  TextFormField(
                    controller: _password,
                    obscureText: _hidePassword,
                    validator: AppValidators.password,
                    decoration: AppStyles.field(
                      hint: 'Enter your password',
                      suffix: IconButton(
                        onPressed: () => setState(() => _hidePassword = !_hidePassword),
                        icon: Icon(_hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      ),
                    ),
                  ),
                  _label('Confirm Password'),
                  TextFormField(
                    controller: _confirm,
                    obscureText: _hideConfirm,
                    validator: (value) => AppValidators.confirmPassword(value, _password.text),
                    decoration: AppStyles.field(
                      hint: 'Confirm your password',
                      suffix: IconButton(
                        onPressed: () => setState(() => _hideConfirm = !_hideConfirm),
                        icon: Icon(_hideConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(label: 'Create Account', onPressed: _submit),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account? '),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}
