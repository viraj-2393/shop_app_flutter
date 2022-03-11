import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [

  ];
   String authToken = '';
  //Products(this.authToken);
  var _showFavoritesOnly = false;
  Product findById(String id){
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get items{
    // if(_showFavoritesOnly){
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems{
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async{
    final url = Uri.parse('https://shop-app-f3f7c-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try{
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String,dynamic>;
      //print(extractedData);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description:  prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite']
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    }
    catch(error){
      rethrow;
    }

  }

  Future<void> addProduct(Product product) async{
    final url = Uri.parse('https://shop-app-f3f7c-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.post(url, body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'isFavorite': product.isFavorite
      }));
      final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)['name']
      );
      _items.add(newProduct);
      //_items.insert(0, newProduct);//at the beginning
      notifyListeners();
    }
    catch(error){
      rethrow;
    }

  }
  Future<void> updateProducts(String id,Product newProduct) async{
   final prodIndex  =  _items.indexWhere((prod) => prod.id == id);
   if(prodIndex >= 0){
     final url = Uri.parse('https://shop-app-f3f7c-default-rtdb.firebaseio.com/products/$id.json');
     await http.patch(url,body:json.encode({
       'title':newProduct.title,
       'description':newProduct.description,
       'price': newProduct.price,
       'imageUrl': newProduct.imageUrl,
     }));

     _items[prodIndex] = newProduct;
     notifyListeners();
   }

  }
  Future<void> deleteProduct(String id) async{
    final url = Uri.parse('https://shop-app-f3f7c-default-rtdb.firebaseio.com/products/$id.json');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
      if(response.statusCode >= 400){
        _items.insert(existingProductIndex,existingProduct);
        notifyListeners();
        throw HttpException('Could not delete product');
      }
      existingProduct = null;
  }
}