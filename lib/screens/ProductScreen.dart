import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../appData.dart';
import 'dart:convert' as convert;
import 'package:flutter_html_view/flutter_html_view.dart';
import 'Comments.dart';
import 'package:intl/intl.dart';
import 'CartScreen.dart';
import '../Cart.dart';

// ignore: must_be_immutable
class ProductScreen extends StatefulWidget {
  int productId;
  String title;

  ProductScreen(int id, String title) {
    this.productId = id;
    this.title = title.length > 30 ? title.substring(0, 30) + "..." : title;
  }

  @override
  _ProductScreenState createState() => _ProductScreenState(productId);
}

class _ProductScreenState extends State<ProductScreen> {
  List<dynamic> commentList = [];
  String title = "";
  String imgUrl = "";
  String content = "";
  String id = "";
  int tabIndex = 0;
  String price = "";
  String productPrice;

  _ProductScreenState(productID) {
    _getProduct(productID);
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = AppBar(
      title: Text(widget.title),
      backgroundColor: Colors.red,
      elevation: 0,
      bottom: TabBar(
        indicatorColor: Colors.white,
        tabs: <Widget>[
          Tab(text: "توضیحات", icon: Icon(Icons.title)),
          Tab(text: "نظرات", icon: Icon(Icons.comment)),
          Tab(text: "گالری تصاویر", icon: Icon(Icons.image)),
        ],
      ),
    ).preferredSize.height;

    double contentHeight =
        MediaQuery.of(context).size.height - appBarHeight - 322;
    // print("Content height is: " + contentHeight.toString());
    // print("AppBar height is: " + appBarHeight.toString());

    return Material(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: Colors.red,
            elevation: 0,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(text: "توضیحات", icon: Icon(Icons.title)),
                Tab(text: "نظرات", icon: Icon(Icons.comment)),
                Tab(text: "گالری تصاویر", icon: Icon(Icons.image)),
              ],
            ),
          ),
          body: new Theme(
            data: ThemeData(
              fontFamily: 'elmessiri',
              hintColor: Colors.grey[400],
              primaryColor: Colors.red,
            ),
            child: TabBarView(
              children: [
                title.isNotEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Image.network(
                              AppData.serverUrl + imgUrl,
                              height: 200.0,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill,
                            ),
                            Container(
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                title,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  child: HtmlView(data: content),
                                  height: contentHeight,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Cart.addProductCart(id, title, int.parse(productPrice), imgUrl).then((response) {
                                      if (response) {
                                        AppData.goNewScreen(context, CartScreen(), 0, 1);
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50.0,
                                    color: Colors.green,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.add_shopping_cart,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Text(
                                              price,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                //new CommentForm(widget.productId),
                new Comments(widget.productId, commentList),
                Container(child: Center(child: Text("Gallery"))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getProduct(int productID) async {
    String url =
        AppData.serverUrl + "?action=getProductData&id=" + productID.toString();
    await http.get(url).then((response) {
      //print(response.statusCode);
      if (response.statusCode == 200) {
        dynamic jsonResponse = convert.jsonDecode(response.body);
        setState(() {
          title = jsonResponse['title'];
          imgUrl = jsonResponse['img_url'];
          content = jsonResponse['content'];
          id = jsonResponse['id'];
          productPrice = jsonResponse['price'];

          var formatter = new NumberFormat("###,###");
          price =
              formatter.format(int.parse(jsonResponse['price'])).toString() +
                  " تومان";
        });
      }
    });
  }
}
