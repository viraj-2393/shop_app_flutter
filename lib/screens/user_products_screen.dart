import 'package:flutter/material.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_product_screen.dart';
class UserProductsScreen extends StatelessWidget{
  static const routeName = '/user-products';
  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<Products>(context,listen: false).fetchAndSetProducts(true);
  }
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx,snapshot) => snapshot.connectionState == ConnectionState.waiting ?
            const Center(child: CircularProgressIndicator(),)
            : RefreshIndicator(
          onRefresh:()=> _refreshProducts(context) ,
          child: Consumer<Products>(
            builder: (ctx,productData,_) =>Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemBuilder: (ctx,index)=>
                    Column(
                      children: [
                        UserProductItem(
                            productData.items[index].id,
                            productData.items[index].title,
                            productData.items[index].imageUrl
                        ),
                        const Divider()
                      ],
                    )
                ,
                itemCount: productData.items.length ,
              ),
            ),
          ),
        ),
      )
    );
  }
}