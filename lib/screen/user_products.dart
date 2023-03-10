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

Future<void> _refreshProducts(BuildContext context) async {
  await Provider.of<ProductsProvider>(context, listen: false).fetch();
}

class UserProducts extends StatelessWidget {
  static const String routeName = 'UserProducts';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
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
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (ctx, index) {
              Product p = productData.items.elementAt(index);
              return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) async {
                    try {
                      await productData.removeByIndex(index);
                    } catch (error) {
                      scaffoldMessenger.showSnackBar(SnackBar(
                        content: Text(
                          'Deletion Failed!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ));
                    }
                  },
                  background: Container(color: Colors.redAccent),
                  child: userProductListItem(context, p));
            },
            itemCount: productData.items.length,
          ),
        ),
      ),
    );
  }
}
