import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = 'CartScreen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Widget cartListItemWidget(CartItem c) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: ListTile(
          leading: Container(
            width: 70,
            height: 70,
            child: Image.network(
              c.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          title: Text(
            c.title,
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text('Total: \$ ${c.price * c.quantity}'),
          trailing: Text('\$ ${c.price} * ${c.quantity}'),
        ),
      ),
    );
  }

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<CartProvider>(context);
    final orderData = Provider.of<OrdersProvider>(context, listen: false);
    final sacffMess = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Chip(
                    label: Text(
                      '\$ ${cartData.totalAmount}',
                    ),
                  ),
                  TextButton(
                    onPressed: cartData.itemCount <= 0
                        ? null
                        : () async {
                            try {
                              setState(() {
                                _isLoading = true;
                              });
                              await orderData.addOrder(
                                  cartData.items.values.toList(),
                                  cartData.totalAmount);
                              cartData.clear();
                              setState(() {
                                _isLoading = false;
                              });
                            } catch (error) {
                              setState(() {
                                _isLoading = false;
                              });
                              sacffMess.showSnackBar(SnackBar(
                                content: Text(
                                  'Order Failed!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ));
                            }
                          },
                    child: _isLoading == true
                        ? CircularProgressIndicator()
                        : Text(
                            'ORDER NOW',
                            style: TextStyle(
                                color: cartData.itemCount <= 0
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor),
                          ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                CartItem c = cartData.items.values.elementAt(index);
                return Dismissible(
                  key: Key(c.id),
                  background: Container(
                    color: Colors.redAccent,
                  ),
                  child: cartListItemWidget(c),
                  onDismissed: (direction) {
                    setState(() {
                      cartData.remove(c.id);
                    });
                  },
                );
              },
              itemCount: cartData.itemCount,
            ),
          )
        ],
      ),
    );
  }
}
