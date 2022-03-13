import 'package:flutter/material.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
class AppDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.shop,),
            title: const Text('Shop'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.money,),
            title: const Text('Orders'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.edit,),
            title: const Text('Manage Products'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout,),
            title: const Text('Logout'),
            onTap: (){
              Navigator.of(context).pop();
              Provider.of<Auth>(context,listen: false).logout();
            },
          ),
        ],
      ),
    );
  }

}