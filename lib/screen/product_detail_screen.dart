import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../models/product.dart';
import '../widgets/badge.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = "ProductDetailScreen";
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    Product loadedProduct =
        Provider.of<ProductsProvider>(context, listen: false).findById(id);
    final cartData = Provider.of<CartProvider>(context, listen: false);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
        actions: <Widget>[
          Consumer<CartProvider>(
            builder: (ctx, data, ch) {
              return Badge(
                child: ch,
                value: data.itemCount.toString(),
              );
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    child: Container(
                      width: double.infinity,
                      height: size.height / 3,
                      child: Image.network(
                        loadedProduct.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loadedProduct.title,
                          style: TextStyle(fontSize: 22),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '\$ ${loadedProduct.price}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'inclusive of all taxes',
                          style: TextStyle(
                              color: Color.fromRGBO(1, 166, 133, 1.0),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Card(
              elevation: 2,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Product Details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Icon(Icons.list),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      loadedProduct.description,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      cartData.addItem(loadedProduct.id, loadedProduct.price,
                          loadedProduct.title, loadedProduct.imageUrl);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.shopping_bag,
                          size: 20,
                        ),
                        Text('Add to Cart'),
                      ],
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        Size((size.width - 50) / 2, 20),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(255, 61, 107, 1.0)),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                  ),
                  Consumer<ProductsProvider>(
                    builder: (ctx, value, ch) {
                      return OutlinedButton(
                        onPressed: () {
                          value.toggleIsFavourite(loadedProduct.id);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            loadedProduct.isFavourite == false
                                ? Icon(Icons.favorite_outline)
                                : Icon(
                                    Icons.favorite,
                                    color: Colors.redAccent,
                                  ),
                            ch,
                          ],
                        ),
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                            Size((size.width - 50) / 2, 20),
                          ),
                          // backgroundColor: MaterialStateProperty.all(
                          //     Color.fromRGBO(255, 61, 107, 1.0)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text('Favourite'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
