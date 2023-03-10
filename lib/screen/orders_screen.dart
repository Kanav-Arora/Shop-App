import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/screen/app_drawer.dart';
import '../providers/orders_provider.dart';
import 'package:provider/provider.dart';

Widget orderListItem(OrderItem obj) {
  return Card(
    elevation: 2,
    margin: EdgeInsets.symmetric(vertical: 5),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
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
    ),
  );
}

class OrdersScreen extends StatefulWidget {
  static const String routeName = 'OrdersScreen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;

  Future _obtainFuture() {
    return Provider.of<OrdersProvider>(context, listen: false).fetch();
  }

  @override
  void initState() {
    // TODO: implement initState
    _ordersFuture = _obtainFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<OrdersProvider>(context, listen: false).fetch();
        },
        child: FutureBuilder(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text('Unable to fetch orders'),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<OrdersProvider>(
                    builder: (c, value, child) {
                      return ListView.builder(
                        itemBuilder: (ctx, index) {
                          return orderListItem(value.orders.elementAt(index));
                        },
                        itemCount: value.orders.length,
                      );
                    },
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
