import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'CommentForm.dart';
import '../appData.dart';
import 'dart:convert' as convert;

// ignore: must_be_immutable
class Comments extends StatefulWidget {
  final int productId;
  List<dynamic> commentList = [];

  Comments(this.productId, this.commentList);

  @override
  _CommentsState createState() => _CommentsState(productId, commentList);
}

class _CommentsState extends State<Comments> {
  int page = 1;
  int moreData = 1;
  ScrollController _scrollController = new ScrollController();

  void initState() {
    _scrollController.addListener(() {
      //print(_scrollController.position.pixels);
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        _loadData(widget.productId);
      }
    });
  }

  _CommentsState(productId, List<dynamic> commentList) {
    if (commentList.length == 0) {
      _loadData(productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = moreData == 1
        ? widget.commentList.length + 1
        : widget.commentList.length;

    return widget.commentList.length > 0
        ? Stack(
            children: [
              ListView.builder(
                itemBuilder: (buildContext, index) {
                  return commentRow(index);
                },
                itemCount: itemCount,
                controller: _scrollController,
              ),
              Positioned(
                child: FloatingActionButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext context) =>
                    //             CommentForm(widget.productId)));
                    AppData.goNewScreen(context, CommentForm(widget.productId), 1, 0);
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.red,
                ),
                bottom: 20,
                right: 20,
              ),
            ],
          )
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  Widget commentRow(index) {
    double width = MediaQuery.of(context).size.width - 40;
    if (index == widget.commentList.length) {
      return Container(
        height: 100,
        width: width,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Container(
        // decoration: BoxDecoration(
        //   border: Border.all(
        //     color: Colors.grey[200],
        //     width: 1,
        //   ),
        // ),
        margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        child: Column(
          children: [
            Container(
              width: width,
              color: Colors.grey[200],
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("ارسال شده توسط: " + widget.commentList[index]['name']),
                  Text("در تاریخ: " + widget.commentList[index]['date']),
                ],
              ),
            ),
            Container(
              width: width,
              color: Colors.white,
              padding: EdgeInsets.all(10.0),
              child: Text(
                widget.commentList[index]['content'],
                style: TextStyle(fontFamily: 'sans'),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _loadData(int productId) {
    String url = AppData.serverUrl +
        "?action=get_comment&product_id=" +
        productId.toString() +
        "&page=" +
        page.toString();
    http.get(url).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          if (response.body == "[]") {
            moreData = 0;
          } else {
            widget.commentList =
                widget.commentList + convert.jsonDecode(response.body);
          }
        });
        page += 1;
      }
    });
  }
}
