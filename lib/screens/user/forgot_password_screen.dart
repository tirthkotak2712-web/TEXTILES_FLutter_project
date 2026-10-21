import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/core/validators.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/widgets/app_bar.dart';
import 'package:textiles/widgets/common.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final error = context.read<StoreRepository>().resetPassword(
          email: _email.text,
          next: _password.text,
          confirm: _confirm.text,
        );
    if (error != null) {
      showAppMessage(context, error);
      return;
    }
    showAppMessage(context, 'Password updated. You can log in now.');
    Navigator.pop(context);
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
            const Text(
              'Forgot Password',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            const Text(
              'Enter the email on your account, then choose a new password.',
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
                  const Text('Email', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: AppValidators.email,
                    decoration: AppStyles.field(hint: 'Enter your email'),
                  ),
                  const SizedBox(height: 16),
                  const Text('New Password', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _password,
                    obscureText: _hidePassword,
                    validator: AppValidators.password,
                    decoration: AppStyles.field(
                      hint: 'Enter new password',
                      suffix: IconButton(
                        onPressed: () => setState(() => _hidePassword = !_hidePassword),
                        icon: Icon(_hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Confirm Password', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirm,
                    obscureText: _hideConfirm,
                    validator: (value) => AppValidators.confirmPassword(value, _password.text),
                    decoration: AppStyles.field(
                      hint: 'Confirm new password',
                      suffix: IconButton(
                        onPressed: () => setState(() => _hideConfirm = !_hideConfirm),
                        icon: Icon(_hideConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            PrimaryButton(label: 'Update Password', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
