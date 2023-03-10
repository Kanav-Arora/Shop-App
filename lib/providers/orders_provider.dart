import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> orderedProducts;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.orderedProducts,
    @required this.dateTime,
  });
}

class OrdersProvider with ChangeNotifier {
  final url = 'shop-app-ac632-default-rtdb.firebaseio.com';
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> ls, double total) async {
    final Uri url_add_order = Uri.https(url, '/orders.json');
    final timestamp = DateTime.now();
    try {
      final response = await http.post(url_add_order,
          body: json.encode({
            'amount': total,
            'datetime': timestamp.toIso8601String(),
            'products': ls
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                      'imageUrl': cp.imageUrl,
                    })
                .toList(),
          }));
      if (response.statusCode >= 400) {
        throw HttpException('Error occured');
      }
      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: total,
              orderedProducts: ls,
              dateTime: DateTime.now()));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetch() async {
    final Uri url_fetch_order = Uri.https(url, '/orders.json');
    try {
      List<OrderItem> temp = [];
      final response = await http.get(url_fetch_order);
      final data = json.decode(response.body) as Map<String, dynamic>;
      data.forEach((key, value) {
        OrderItem o = new OrderItem(
            id: key,
            amount: value['amount'],
            orderedProducts: (value['products'] as List<dynamic>)
                .map(
                  (e) => CartItem(
                    id: e['id'],
                    title: e['title'],
                    quantity: e['quantity'],
                    price: e['price'],
                    imageUrl: e['imageUrl'],
                  ),
                )
                .toList(),
            dateTime: DateTime.parse(value['datetime']));
        temp.insert(0, o);
      });
      _orders = temp;
      notifyListeners();
    } catch (error) {
      throw HttpException('Unable to fetch orders');
    }
  }
}
