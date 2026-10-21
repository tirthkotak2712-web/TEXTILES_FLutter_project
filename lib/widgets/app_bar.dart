import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/resources/app_text.dart';

class TextilesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TextilesAppBar({
    super.key,
    this.title,
    this.titleColor = AppColors.ink,
    this.showMenu = false,
    this.showBack = false,
    this.showCart = false,
    this.showBell = false,
    this.actions = const [],
  });

  final String? title;
  final Color titleColor;
  final bool showMenu;
  final bool showBack;
  final bool showCart;
  final bool showBell;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    return AppBar(
      leading: showBack
          ? IconButton(
              onPressed: () => goBack(context),
              icon: const Icon(Icons.arrow_back),
            )
          : showMenu
              ? IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu),
                )
              : null,
      automaticallyImplyLeading: false,
      title: Text(
        title ?? AppText.brandTitle,
        style: TextStyle(
          color: titleColor,
          fontWeight: FontWeight.w800,
          fontSize: 22,
        ),
      ),
      actions: [
        ...actions,
        if (showCart)
          IconButton(
            onPressed: () => selectTab(context, 2),
            icon: Badge(
              isLabelVisible: store.cart.isNotEmpty,
              label: Text('${store.cart.length}'),
              backgroundColor: AppColors.green,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        if (showBell)
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        const SizedBox(width: 4),
      ],
    );
  }
}

void selectTab(BuildContext context, int index) {
  context.read<StoreRepository>().setTab(index);
  Navigator.of(context).popUntil((route) => route.isFirst);
}

/// Leaves the current screen. Uses [Navigator.pop] so the arrow always
/// returns to the page that opened this one.
void goBack(BuildContext context) {
  final navigator = Navigator.of(context);
  if (navigator.canPop()) {
    navigator.pop();
    return;
  }
  final root = Navigator.of(context, rootNavigator: true);
  if (root.canPop()) root.pop();
}
