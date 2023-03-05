import 'package:flutter/material.dart';
import 'package:shop_app/screen/product_detail_screen.dart';
import 'package:shop_app/screen/products_overview_screen.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductsProvider(),
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          iconTheme: IconThemeData(color: Colors.deepOrangeAccent),
        ),
        home: ProductsOverviewScreen(),
        routes: {
          './': (context) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
        },
      ),
    );
  }
}
