import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = 'AddProductScreen';

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  TextEditingController _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(() {
      if (!_imageUrlFocusNode.hasFocus) {
        return setState(() {});
      }
      return;
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    Provider.of<ProductsProvider>(context, listen: false)
        .addProduct(_editedProduct);
    Navigator.of(context).pop();
  }

  Widget get validUrl {
    if ((!_imageUrlController.text.endsWith('.png') &&
            !_imageUrlController.text.endsWith('.jpg') &&
            !_imageUrlController.text.endsWith('.jpeg')) ||
        (!_imageUrlController.text.startsWith('http') &&
            !_imageUrlController.text.startsWith('https')) ||
        _imageUrlController.text.isEmpty) {
      return SizedBox(
        width: 10,
        height: 10,
      );
    } else {
      return Container(
        padding: EdgeInsets.only(top: 25),
        width: 200,
        height: 200,
        child: Image.network(_imageUrlController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  validator: (value) {
                    return value.isEmpty == true ? 'Empty' : null;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  decoration: InputDecoration(
                    label: Text('Title'),
                  ),
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: newValue,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl);
                  },
                ),
                TextFormField(
                  validator: (value) {
                    return value.isEmpty == true ? 'Empty' : null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  decoration: InputDecoration(
                    label: Text('Price'),
                  ),
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(newValue),
                        imageUrl: _editedProduct.imageUrl);
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Empty';
                    else if (value.length < 10) return 'Too short';
                    return null;
                  },
                  maxLines: 2,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  focusNode: _descriptionFocusNode,
                  decoration: InputDecoration(
                    label: Text('Description'),
                  ),
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: newValue,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl);
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Empty';
                    else if (!value.startsWith('http') &&
                        !value.startsWith('https'))
                      return 'Invalid link';
                    else if (!value.endsWith('.png') &&
                        !value.endsWith('.jpg') &&
                        !value.endsWith('.jpeg')) return 'Invalid image';
                    return null;
                  },
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(label: Text('Image URL')),
                  controller: _imageUrlController,
                  focusNode: _imageUrlFocusNode,
                  onEditingComplete: (() {
                    setState(() {});
                  }),
                  onSaved: (newValue) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: newValue);
                  },
                ),
                validUrl
              ],
            )),
      ),
    );
  }
}