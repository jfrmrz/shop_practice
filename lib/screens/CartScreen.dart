import 'package:flutter/material.dart';
import '../Cart.dart';
import '../appData.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double appBarHeight = AppBar().preferredSize.height;
  int cartPrice = 0;
  List<Map<String, dynamic>> productData = [];
  Map<int, String> cartProductID = Map();

  _CartScreenState() {
    _getCartData();
  }

  @override
  Widget build(BuildContext context) {

    var formatter = new NumberFormat("###,###");
    String cartPriceText = formatter.format(cartPrice) + " تومان";


    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("سبد خرید"),
          backgroundColor: Colors.red,
          elevation: 0,
          actions: <Widget>[
            productData.length > 0
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      AlertDialog alertDialog = AlertDialog(
                        contentPadding: EdgeInsets.all(10.0),
                        content:
                            Text("آیا از خالی کردن سبد خرید اطمینان دارید؟"),
                        actions: [
                          RaisedButton(
                            onPressed: () {
                              Cart.emptyCart().then((response) {
                                if (response) {
                                  setState(() {
                                    productData = [];
                                  });
                                }
                              });
                              Navigator.pop(context);
                            },
                            child: Text("بله"),
                          ),
                          RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("خیر"),
                          ),
                        ],
                        //title: Text("عنوان"),
                      );
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => alertDialog);
                    })
                : Text(""),
          ],
        ),
        body: Container(
          child: productData.length > 0
              ? Column(
                  children: <Widget>[
                    Container(
                      color: Colors.green[100],
                      margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text("جمع کل"),
                          ),
                          Expanded(
                            child: Text(
                              cartPriceText.toString(),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Container(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, index) =>
                              _cartRow(index),
                          itemCount: productData.length,
                        ),
                      ),
                    ),
                    RaisedButton(
                      color: Colors.green,
                      onPressed: () {},
                      child: Text("نهایی کردن خرید"),
                    ),
                  ],
                )
              : Center(
                  child: Text("سبد خرید شما خالی است"),
                ),
        ),
      ),
    );
  }

  _getCartData() {
    Cart.getCartProduct().then((response) {
      List<String> productsID = response.split('_');
      for (int i = 0; i < (productsID.length - 1); i++) {
        String id = productsID[i];
        cartProductID[i] = id;
        Cart.getProductData(id).then((response) {
          setState(() {
            cartPrice += (response['price'] * response['number']);
            productData.add(response);
          });
        });
      }
    });
  }

  Widget _cartRow(index) {

    var formatter = new NumberFormat("###,###");
    int totalPrice = productData[index]['price'] * productData[index]['number'];
    String price =
        formatter.format(productData[index]['price']).toString() + " تومان";
    String price2 = formatter.format(totalPrice).toString() + " تومان";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey[200],
          width: 1.0,
        ),
      ),
      margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Image(
                    image: NetworkImage(
                      AppData.serverUrl + productData[index]['imgUrl'],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  productData[index]['title'],
                ),
              ),
            ],
          ),
          //Text(productData[index]['number'].toString()),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            padding: EdgeInsets.all(10.0),
            color: Colors.grey[100],
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text("قیمت واحد"),
                ),
                Expanded(
                  child: Text(
                    price,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1.0,
            color: Colors.grey[400],
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.grey[100],
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text("قیمت کل"),
                ),
                Expanded(
                  child: Text(
                    price2,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width - 30,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Cart.increaseNumberProduct(cartProductID[index])
                              .then((response) {
                            if (response) {
                              setState(() {
                                int n = productData[index]['number'];
                                n += 1;
                                productData[index]['number'] = n;
                                cartPrice += productData[index]['price'];
                              });
                            }
                          });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(productData[index]['number'].toString()),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          Cart.reduceNumberProduct(cartProductID[index])
                              .then((response) {
                            if (response) {
                              setState(() {
                                int n = productData[index]['number'];
                                if (n > 1) {
                                  n -= 1;
                                  productData[index]['number'] = n;
                                  cartPrice -= productData[index]['price'];
                                } else {
                                  cartPrice -= productData[index]['price'];
                                  productData.removeAt(index);
                                  cartProductID.remove(index);
                                  _updateCartProductID();
                                }
                              });
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Text(
                      "حذف محصول",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Cart.removeCartProduct(cartProductID[index])
                          .then((response) {
                        if (response) {
                          setState(() {
                            cartPrice -= productData[index]['price'] * productData[index]['number'];
                            productData.removeAt(index);
                            cartProductID.remove(index);
                            _updateCartProductID();
                          });
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _updateCartProductID() {
    print("updateCartProductID: $cartProductID");
    Map<int, String> newCartData = Map();
    int i = 0;
    cartProductID.forEach((key, value) {
      newCartData[i] = value;
      i++;
    });
    cartProductID = newCartData;
    print("updateCartProductID: $cartProductID");
  }
}
