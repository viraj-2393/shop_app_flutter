import 'package:flutter/material.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../widgets/user_product_item.dart';
class UserProductsScreen extends StatelessWidget{
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){},
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (ctx,index)=>
          Column(
            children: [
              UserProductItem(
                  productData.items[index].title,
                  productData.items[index].imageUrl
              ),
              Divider()
            ],
          )
              ,
          itemCount: productData.items.length ,
        ),
      )
    );
  }
}