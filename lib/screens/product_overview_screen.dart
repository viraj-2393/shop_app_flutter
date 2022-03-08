import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../providers/products.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
enum FilterOptions {
  Favorites,
  All
}
class ProductOverviewScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ProductOverviewScreenState();
  }
}
class ProductOverviewScreenState extends State<ProductOverviewScreen>{
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState(){
    //Provider.of<Products>(context).fetchAndSetProducts();
    // Future.delayed(Duration.zero).then((_){
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_){
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //final productsContainer = Provider.of<Products>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue){
              setState(() {
                if(selectedValue == FilterOptions.Favorites){
                  _showOnlyFavorites = true;
                }
                else{
                  _showOnlyFavorites = false;
                }
              });

            },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) =>[
                PopupMenuItem(
                    child: Text('Only Favorites'),
                    value:FilterOptions.Favorites
                ),
                PopupMenuItem(
                    child: Text('Show All'),
                    value:FilterOptions.All
                )
              ]
          ),
          Consumer<Cart>(
            builder: (_,cartData,ch) =>Badge(
              child: ch as Widget,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: (){
                Navigator.of(context).pushNamed(
                    CartScreen.rounteName
                );
              },
            ),
          )

        ],
      ),
      drawer: AppDrawer(),
      body:_isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : ProductGrid(_showOnlyFavorites)
    );
  }

}