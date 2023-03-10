import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  final Uri url_products =
      Uri.https('shop-app-ac632-default-rtdb.firebaseio.com', '/products.json');

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return items.where((element) => element.isFavourite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product p) async {
    try {
      final response = await http.post(url_products,
          body: json.encode({
            'title': p.title,
            'desc': p.description,
            'price': p.price,
            'imageUrl': p.imageUrl,
            'isFav': p.isFavourite,
          }));

      final newP = Product(
          id: json.decode(response.body)['name'].toString().substring(1),
          title: p.title,
          description: p.description,
          price: p.price,
          imageUrl: p.imageUrl);
      _items.add(newP);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetch() async {
    try {
      final response = await http.get(url_products);
      final data = json.decode(response.body);
      final List<Product> _ls = [];
      data.forEach((key, value) {
        _ls.add(Product(
          id: key.toString(),
          title: value['title'],
          description: value['desc'],
          price: value['price'] as double,
          imageUrl: value['imageUrl'],
          isFavourite: value['isFav'] as bool,
        ));
      });
      _items = _ls;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> removeByIndex(int ind) async {
    String id = _items.elementAt(ind).id;
    Product existingProduct = _items.elementAt(ind);
    final Uri url_delete = Uri.https(
        'shop-app-ac632-default-rtdb.firebaseio.com', '/products/$id.json');
    _items.removeAt(ind);
    notifyListeners();
    final response = await http.delete(url_delete);

    if (response.statusCode >= 400) {
      _items.insert(ind, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }

  Future<void> toggleIsFavourite(String id) async {
    Product p = _items.firstWhere((element) => element.id == id);
    final Uri url_toggle = Uri.https(
        'shop-app-ac632-default-rtdb.firebaseio.com', '/products/$id.json');
    p.isFavourite = !p.isFavourite;
    notifyListeners();
    final response = await http.patch(url_toggle,
        body: json.encode({
          'title': p.title,
          'desc': p.description,
          'price': p.price,
          'imageUrl': p.imageUrl,
          'isFav': p.isFavourite
        }));
    if (response.statusCode >= 400) {
      p.isFavourite = !p.isFavourite;
      notifyListeners();
      throw HttpException('Unable to favourite the product');
    }
  }

  Future<void> updateProduct(String id, Product p) async {
    var prodIndex = _items.indexWhere((element) => element.id == id);
    try {
      final Uri url_update_product = Uri.https(
          'shop-app-ac632-default-rtdb.firebaseio.com', '/products/$id.json');
      await http.patch(url_update_product,
          body: json.encode({
            'title': p.title,
            'desc': p.description,
            'price': p.price,
            'imageUrl': p.imageUrl,
            'isFav': p.isFavourite,
          }));
      _items[prodIndex] = p;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
