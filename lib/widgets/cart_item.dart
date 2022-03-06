import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
class CartItem extends StatelessWidget{
  final String id;
  final String productId;
  final double price;
  final int quantitiy;
  final String title;
  CartItem(
      this.id,
      this.productId,
      this.price,
      this.quantitiy,
      this.title
      );
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Are you sure?'),
              content:Text('Do you want to remove the item from the cart?'),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.of(ctx).pop(false);
                    },
                    child: Text('No')
                ),
                TextButton(
                    onPressed: (){
                      Navigator.of(ctx).pop(true);
                    },
                    child: Text('Yes')
                )
              ],
            )
        );
        //return Future.value(true);
      },
      onDismissed: (direction){
        Provider.of<Cart>(context,listen: false).removeItem(productId);
      },
      background: Container(color: Theme.of(context).errorColor,
      child:const Icon(
        Icons.delete,
        color: Colors.white,
        size: 20,
      ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 15
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 15
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(child: Text('\$${price}'),),
                )
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantitiy}'),
            trailing: Text('$quantitiy X'),
          ),
        ),
      ),
    );
  }
}