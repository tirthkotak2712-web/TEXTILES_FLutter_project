import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/core/format.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_styles.dart';
import 'package:textiles/screens/user/product_details_screen.dart';
import 'package:textiles/widgets/app_bar.dart';
import 'package:textiles/widgets/bottom_nav.dart';
import 'package:textiles/widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _query = TextEditingController(text: widget.initialQuery);

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    final results = _query.text.trim().isEmpty ? const [] : store.search(_query.text);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(onPressed: () => goBack(context), icon: const Icon(Icons.arrow_back)),
                  Expanded(
                    child: TextField(
                      controller: _query,
                      autofocus: widget.initialQuery.isEmpty,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: store.rememberSearch,
                      decoration: InputDecoration(
                        hintText: 'Search T-Shirts,...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: AppColors.field,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: results.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final product = results[index];
                  return ListTile(
                    leading: SizedBox(width: 64, height: 64, child: CatalogImage(image: product.image)),
                    title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: Text(Format.inr(product.price)),
                    onTap: () {
                      store.rememberSearch(_query.text);
                      Navigator.push(context, MaterialPageRoute<void>(builder: (_) => ProductDetailsScreen(productId: product.id)));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(index: 0),
    );
  }
}
