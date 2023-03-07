import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screen/add_product_screen.dart';
import 'package:shop_app/screen/app_drawer.dart';
import 'package:provider/provider.dart';

Widget userProductListItem(BuildContext context, Product obj) {
  return ListTile(
    title: Text(obj.title),
    leading: CircleAvatar(
        backgroundImage: NetworkImage(
      obj.imageUrl,
    )),
    trailing: IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Navigator.of(context)
            .pushNamed(AddProductScreen.routeName, arguments: obj.id);
      },
    ),
  );
}

class UserProducts extends StatelessWidget {
  static const String routeName = 'UserProducts';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('User Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddProductScreen.routeName);
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          Product p = productData.items.elementAt(index);
          return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                productData.removeByIndex(index);
              },
              background: Container(color: Colors.redAccent),
              child: userProductListItem(context, p));
        },
        itemCount: productData.items.length,
      ),
    );
  }
}
