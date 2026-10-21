import 'package:flutter/material.dart';
import 'package:textiles/widgets/app_bar.dart';

void openAdminPage(BuildContext context, Widget page) {
  final navigator = Navigator.of(context);
  final scaffold = Scaffold.maybeOf(context);
  if (scaffold != null && scaffold.isDrawerOpen) navigator.pop();
  navigator.push(MaterialPageRoute<void>(builder: (_) => page));
}

class AdminPage extends StatelessWidget {
  const AdminPage({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
  });

  final String title;
  final Widget body;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => goBack(context),
          icon: const Icon(Icons.arrow_back),
        ),
        automaticallyImplyLeading: false,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: actions,
      ),
      body: body,
    );
  }
}
