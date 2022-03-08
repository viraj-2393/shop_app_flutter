import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';
class OrdersScreen extends StatelessWidget{
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    //final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context,listen: false).fetchAndSetOrders(),
        builder: (ctx,dataSnapshot) {
          if(dataSnapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          else{
            if(dataSnapshot.error != null){
              return Center(child: Text('An error Occured!'),);
            }
            else{
             return Consumer<Orders>(builder:(ctx,ordersData,child) =>
                 ListView.builder(
                   itemCount: ordersData.orders.length,
                   itemBuilder: (ctx,index) =>OrderItem(ordersData.orders[index]),
                 )
             );
            }
          }
        },
      )
    );
  }
}