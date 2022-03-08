import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/cart_item.dart' as ci;
import '../providers/orders.dart';
class CartScreen extends StatelessWidget{
  static const rounteName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child:Padding(
              padding: EdgeInsets.all(8),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text('Total',style: TextStyle(fontSize: 20),),
                    Spacer(),
                    Chip(label: Text('\$${cart.totalAmount.toStringAsFixed(2)}',style: TextStyle(color: Colors.white),),backgroundColor: Theme.of(context).primaryColor,),
                    OrderButton(cart)
                ],
              ) ,
            ) ,
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx,index)=>ci.CartItem(
                  cart.items.values.toList()[index].id,
                  cart.items.keys.toList()[index],
                  cart.items.values.toList()[index].price,
                  cart.items.values.toList()[index].quantity,
                  cart.items.values.toList()[index].title
              ),
              itemCount: cart.itemCount,

            ),
          )
        ],
      ),
    );

  }
}
class OrderButton extends StatefulWidget{
  final Cart cart;
  OrderButton(this.cart);
  @override
  State<StatefulWidget> createState() {
    return _OrderButtonState();
  }
}
class _OrderButtonState extends State<OrderButton>{
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.cart.totalAmount <=0 || _isLoading ? null :() async{
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Orders>(context,listen: false).addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
        setState(() {
          _isLoading = false;
        });
        widget.cart.clear();
      },
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW',style: TextStyle(color:Theme.of(context).primaryColor),),
    );
  }
}