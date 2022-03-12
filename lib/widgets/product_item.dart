import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';
class ProductItem extends StatelessWidget{
  // final String id;
  // final String title;
  // final String imageUrl;
  // ProductItem(this.id,this.title,this.imageUrl);

  @override
  Widget build(BuildContext context) {
    //final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context,listen:false);
    final authData = Provider.of<Auth>(context,listen: false);
    return Card(
        elevation: 5,
        child:Consumer<Product>(
            builder: (ctx,product,child) => ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child:GridTile(
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushNamed(
                        ProductDetailScreen.routeName,
                        arguments: product.id
                    );
                  },
                  child: Image.network(product.imageUrl,fit: BoxFit.cover,),
                ),
                footer: GridTileBar(
                    backgroundColor: Colors.black87,
                    leading: IconButton(
                      icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border,color:Colors.deepOrange),
                      onPressed: (){
                        product.toggleFavoriteStatus(authData.token,authData.userId);
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.shopping_cart,color: Colors.deepOrange,),
                      onPressed: (){
                        cart.addItem(product.id, product.price, product.title);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Item added to the cart!'),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: (){
                              cart.removeSingleItem(product.id);
                            },
                          )
                        ));
                      },
                    ),
                    title: FittedBox(
                      child: Text(product.title,textAlign: TextAlign.center,),
                    )
                ),
              ),

            ),
        )
    );
  }
}