import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/providers/auth.dart';
import 'package:shoping_app/providers/cart.dart';
import 'package:shoping_app/providers/orders.dart';
import 'package:shoping_app/screens/auth_screen.dart';
import 'package:shoping_app/screens/cart_screen.dart';
import 'package:shoping_app/screens/edit_product_screen.dart';
import 'package:shoping_app/screens/orders_screen.dart';
import 'package:shoping_app/screens/product_detail_screen.dart';
import 'package:shoping_app/screens/products_overview_screen.dart';
import 'package:shoping_app/screens/splash_screen.dart';
import 'package:shoping_app/screens/user_product_screen.dart';
import './providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, previous) => Products(
            auth.token,
            auth.userId,
            previous == null ? [] : previous.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, previous) => Orders(
              auth.token, auth.userId, previous == null ? [] : previous.orders),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? PoductsOverviewScreen()
              : 
              FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResutSnapshot) =>
                      authResutSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.rountName: (ctx) => CartScreen(),
            OrdersScreen.rountName: (ctx) => OrdersScreen(),
            UserProductionScreen.routName: (ctx) => UserProductionScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen()
          },
        ),
      ),
    );
  }
}
