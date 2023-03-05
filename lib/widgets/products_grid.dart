import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';
import 'product_item.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showOnlyFavourites;
  ProductsGrid(this._showOnlyFavourites);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final productsData = Provider.of<ProductsProvider>(context);
    final products =
        _showOnlyFavourites ? productsData.favouriteItems : productsData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        Product p = products[index];
        return ProductItem(p.id);
      },
      itemCount: products.length,
    );
  }
}
