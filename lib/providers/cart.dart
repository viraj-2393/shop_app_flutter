import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartItem{
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price
  });
}

class Cart with ChangeNotifier{
  Map<String,CartItem> _items = {

  };

  Map<String ,CartItem> get items{
    return {..._items};
  }
  int get itemCount{
    if(!_items.isEmpty){
      return _items.length;
    }
    return 0;

  }
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem)
    {total += cartItem.price * cartItem.quantity;});
    return total;
  }
  void removeItem(String id){
    _items.remove(id);
    notifyListeners();
  }
  void clear(){
    _items = {};
    notifyListeners();
  }
  void addItem(String productId,double price,String title){
    if(_items.containsKey(productId)){
      //change quantity
      _items.update(productId, (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price));
    }else{
      _items.putIfAbsent(productId, () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price));
    }
    notifyListeners();
  }
}