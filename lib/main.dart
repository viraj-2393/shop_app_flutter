import 'package:flutter/material.dart';
import '../screens/product_overview_screen.dart';
import '../screens/product_detail_screen.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (ctx) => Auth(),
          ),

          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth,Orders>(
              create: (ctx) => Orders(),
             update: (ctx,auth,previous) =>Orders()
              ..authToken = auth.token
              ..userId = auth.userId,
          ),
          ChangeNotifierProxyProvider<Auth,Products>(
            create: (_)=>Products(),
            update: (ctx,auth,previous) => Products()
            ..authToken = auth.token
            ..userId = auth.userId,
          ),
        ],
      child: Consumer<Auth>(
        builder: (ctx,authData,_)=>MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          home: authData.isAuth ? ProductOverviewScreen() :
              FutureBuilder(
                future: authData.tryAutoLogin(),
                builder: (ctx,authResultSnapshot) =>
                    authResultSnapshot.connectionState == ConnectionState.waiting ? SplashScreen()
                        :  AuthScreen()

              ),
          routes: {

            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.rounteName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) =>  EditProductScreen(),

          },

        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}

