import 'package:flutter/material.dart';
import 'package:shop_practice/screens/CartScreen.dart';
import 'package:shop_practice/screens/LoginScreen.dart';
import '../appData.dart';
import '../homeSlider.dart';
import '../model/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'ProductScreen.dart';
import 'RegisterScreen.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PageShow();
  }
}

class PageShow extends State<HomeView> {
  List<Product> newProduct = [];
  List<Product> orderProduct = [];

  @override
  Widget build(BuildContext context) {
    getProductList('new_product', newProduct);
    getProductList('order_product', orderProduct);

    return Scaffold(
      drawer: Drawer(
        child: Container(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.login),
                title: Text("ورود"),
                onTap: () {
                  AppData.goNewScreen(context, LoginScreen(), 1, 0);
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text("ثبت نام"),
                onTap: () {
                  AppData.goNewScreen(context, RegisterScreen(), 1, 0);
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("فروشگاه مجازی"),
        backgroundColor: Colors.red,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              AppData.goNewScreen(context, CartScreen(), 0, 1);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            HomeSlider(),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("جدیدترین ترین محصولات"),
                  Text(
                    "همه",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            newProduct.length > 0
                ? Container(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: newProductList,
                      itemCount: newProduct.length,
                    ),
                    height: 190.0,
                  )
                : Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                    height: 190.0,
                  ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("پرفروش ترین محصولات"),
                  Text(
                    "همه",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            orderProduct.length > 0
                ? Container(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: orderProductList,
                      itemCount: orderProduct.length,
                    ),
                    height: 190.0,
                  )
                : Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                    height: 190.0,
                  ),
          ],
        ),
      ),
    );
  }

  void getProductList(String action, List<Product> list) {
    if (newProduct.length == 0) {
      var url = AppData.serverUrl + "?action=" + action;
      http.get(url).then(
            (response) {
          if (response.statusCode == 200) {
            List jsonResponse = convert.jsonDecode(response.body);
            for (int i = 0; i < jsonResponse.length; i++) {
              setState(
                    () {
                  list.add(Product(
                    title: jsonResponse[i]['title'],
                    imgUrl: jsonResponse[i]['img_url'],
                    price: int.parse(jsonResponse[i]['price']),
                    id: int.parse(jsonResponse[i]['id']),
                  ));
                },
              );
            }
          }
        },
      );
    }
  }

  Widget newProductList(BuildContext context, int index) =>
      indexProductView(index, newProduct);

  Widget orderProductList(BuildContext context, int index) =>
      indexProductView(index, orderProduct);

  Widget indexProductView(int index, List<Product> list) {
    String price = "";
    var formatter = new NumberFormat("###,###");
    price = formatter.format(list[index].price).toString() + " تومان";

    String title = list[index].title.length > 20
        ? list[index].title.substring(0, 20) + "..."
        : list[index].title;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ProductScreen(
              list[index].id,
              list[index].title,
            ),
          ),
        );
      },
      child: Container(
        width: 250.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[300],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          color: Colors.white,
        ),
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Image(
                image: NetworkImage(AppData.serverUrl + list[index].imgUrl),
                height: 80.0,
              ),
            ),
            Text(
              title,
              style: TextStyle(),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            Container(
              child: Text(
                price,
                style: TextStyle(
                  color: Colors.green,
                ),
                textAlign: TextAlign.left,
              ),
              width: 250.0,
              padding: EdgeInsets.all(10.0),
            ),
          ],
        ),
      ),
    );
  }
}
