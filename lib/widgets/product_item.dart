import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/screen/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductItem extends StatelessWidget {
  final String id;
  ProductItem(this.id);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context, listen: false);
    final Product p = productsData.items.firstWhere(
      (element) => element.id == id,
    );
    final cartData = Provider.of<CartProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: id,
              );
            },
            child: Image.network(
              p.imageUrl,
              fit: BoxFit.cover,
            )),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<ProductsProvider>(
            builder: (ctx, value, _) => IconButton(
              icon: Icon(
                value.items
                        .firstWhere((element) => element.id == id)
                        .isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                value.toggleIsFavourite(id);
              },
            ),
          ),
          title: Text(
            p.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              cartData.addItem(p.id, p.price, p.title);
            },
          ),
        ),
      ),
    );
  }
}
