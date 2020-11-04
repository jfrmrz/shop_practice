import 'package:flutter/cupertino.dart';

class Product {

  String title;
  String imgUrl;
  int price;
  int id;

  Product({@required this.title, this.imgUrl, this.price, this.id});
}