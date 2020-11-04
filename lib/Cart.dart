import 'package:shared_preferences/shared_preferences.dart';

class Cart {
  static Future<bool> addProductCart(
      String productID, String title, int price, String imgUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String productsID = prefs.getString("productsID");

    if (productsID != null) {

      if (productsID.indexOf(productID) >= 0) {
        await increaseNumberProduct(productID);
      } else {
        String data = productsID + productID + "_";
        prefs.setString('productsID', data);
        await addProductData(productID, title, price, imgUrl);
      }

    } else {
      String data = productID + "_";
      prefs.setString('productsID', data);
      await addProductData(productID, title, price, imgUrl);
    }

    return true;
  }

  static addProductData(
      String productID, String title, int price, String imgUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('title_' + productID, title);
    prefs.setInt('price_' + productID, price);
    prefs.setString('imgUrl_' + productID, imgUrl);
    prefs.setInt('number_' + productID, 1);
  }

  static Future<bool> increaseNumberProduct(String productID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int n = prefs.getInt('number_' + productID);
    n += 1;
    prefs.setInt('number_' + productID, n);
    return true;
  }

  static Future<bool> reduceNumberProduct(String productID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int n = prefs.getInt('number_' + productID);
    if (n > 1) {
      n -= 1;
      prefs.setInt('number_' + productID, n);
    } else {
      removeCartProduct(productID);
    }
    return true;
  }

  static Future<bool> removeCartProduct(String productID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String productsID = prefs.getString("productsID");
    productsID = productsID.replaceAll(productID + "_", "");

    if (productsID.isEmpty) {
      prefs.remove('productsId');
    } else {
      prefs.setString('productsID', productsID);
    }

    prefs.remove('title_' + productID);
    prefs.remove('price_' + productID);
    prefs.remove('imgUrl_' + productID);
    prefs.remove('number_' + productID);
    return true;
  }

  static Future<bool> emptyCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String productsID = prefs.getString("productsID");
    List<String> pID = productsID.split('_');

    for (int i = 0; i < (pID.length - 1); i++) {
      prefs.remove('title_' + pID[i]);
      prefs.remove('price_' + pID[i]);
      prefs.remove('imgUrl_' + pID[i]);
      prefs.remove('number_' + pID[i]);
    }

    prefs.remove('productsID');
    return true;
  }

  static Future<String> getCartProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String productsID = prefs.getString("productsID");

    return productsID;
  }

  static Future<Map<String, dynamic>> getProductData(String productID) async {

    Map<String, dynamic> data = Map();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String title = prefs.getString('title_' + productID);
    int price = prefs.getInt('price_' + productID);
    String imgUrl = prefs.getString('imgUrl_' + productID);
    int number = prefs.getInt('number_' + productID);

    data['title'] = title;
    data['price'] = price;
    data['imgUrl'] = imgUrl;
    data['number'] = number;

    return data;
  }
}
