import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/screen/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Drawer(
        width: size.width / 1.7,
        child: Column(
          children: [
            AppBar(
              title: Text('Freestyle'),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              leading: Icon(
                Icons.man_outlined,
                size: 26,
              ),
              title: Text(
                'Shop',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () => Navigator.of(context).pushReplacementNamed('/'),
            ),
            ListTile(
              leading: Icon(
                Icons.shopping_bag,
                size: 26,
              ),
              title: Text(
                'Orders',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName),
            )
          ],
        ));
  }
}
