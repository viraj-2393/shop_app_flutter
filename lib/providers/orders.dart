

import 'package:flutter/material.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this. amount,
    required this.products,
    required this.dateTime
  });
}
class Orders with ChangeNotifier{
  List<OrderItem> _orders = [];
  String authToken = '';
  //Orders(this.authToken);
  List<OrderItem> get orders{
    return [..._orders];
  }
  Future<void> addOrder(List<CartItem> cartProducts,double total) async{
    final url = Uri.parse('https://shop-app-f3f7c-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final timeStamp = DateTime.now();
    final response = await http.post(url,body: json.encode({
      'amount': total,
      'dateTime': timeStamp.toIso8601String(),
      'products': cartProducts.map((cp) =>{
        'id' : cp.id,
        'title': cp.title,
        'quantity':cp.quantity,
        'price':cp.price
      }).toList()

    }));
    _orders.add(
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timeStamp
        ));
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async{
    final url = Uri.parse('https://shop-app-f3f7c-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String,dynamic>;
    if(extractedData == null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>).map((item) =>
          CartItem(
            id: item['id'],
            price: item['price'],
            quantity: item['quantity'],
            title: item['title']
          )).toList(),
          dateTime: DateTime.parse(orderData['dateTime'])
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}