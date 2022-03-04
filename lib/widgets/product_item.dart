import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget{
  final String id;
  final String title;
  final String imageUrl;
  ProductItem(this.id,this.title,this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child:GridTile(
          child: GestureDetector(
            onTap: (){
              Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: id
              );
            },
            child: Image.network(imageUrl,fit: BoxFit.cover,),
          ),
          footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading: IconButton(
                icon: Icon(Icons.favorite,color:Colors.deepOrange),
                onPressed: (){},
              ),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart,color: Colors.deepOrange,),
                onPressed: (){},
              ),
              title: FittedBox(
                child: Text(title,textAlign: TextAlign.center,),
              )
          ),
        ),

    )
    );
  }
}