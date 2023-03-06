import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/screen/app_drawer.dart';
import '../providers/orders_provider.dart';
import 'package:provider/provider.dart';

Widget orderListItem(OrderItem obj) {
  return Card(
    elevation: 2,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: Column(
      children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Order id #' + obj.id,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ] +
          List<Widget>.generate(obj.orderedProducts.length, (index) {
            CartItem p = obj.orderedProducts.elementAt(index);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(
                  p.imageUrl,
                  width: 80,
                  height: 80,
                ),
                Text('${p.title} x ${p.quantity}'),
                Text('\$ ${p.price}'),
              ],
            );
          }),
    ),
  );
}

class OrdersScreen extends StatelessWidget {
  static const String routeName = 'OrdersScreen';
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return orderListItem(ordersData.orders.elementAt(index));
        },
        itemCount: ordersData.orders.length,
      ),
    );
  }
}
