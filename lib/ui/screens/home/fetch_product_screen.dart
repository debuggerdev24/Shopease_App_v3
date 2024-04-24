import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/providers/scan_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/product_tile.dart';

class FetchProductScreen extends StatefulWidget {
  const FetchProductScreen({super.key, this.product});

  final Product? product;

  @override
  State<FetchProductScreen> createState() => _FetchProductScreenState();
}

class _FetchProductScreenState extends State<FetchProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerProvider>(builder: (context, provider, _) {
      return Scaffold(
        body: Column(
          children: [
             ProductTile(product: widget.product!),
            const Spacer(),
            AppButton(
              onPressed: () {},
              text: 'Add Product',
            ),
          ],
        ),
      );
    });
  }
}
