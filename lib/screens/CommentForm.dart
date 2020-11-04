import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../appData.dart';

class CommentForm extends StatefulWidget {
  final int productId;

  CommentForm(this.productId);

  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _email = "";
  String _comment = "";
  int send = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("ثبت نظر"),
          backgroundColor: Colors.red,
          elevation: 0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            // ignore: missing_return
                            validator: (String value) {
                              if (value.trim().isEmpty) {
                                return "لطفا نام و نام خانوادگی خود را وارد کنید.";
                              }
                            },
                            onSaved: (String value) {
                              _name = value;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.account_circle),
                              labelText: 'نام و نام خانوادگی',
                              border: new OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            // ignore: missing_return
                            validator: (String value) {
                              if (value.trim().isEmpty) {
                                return "لطفا ایمیل خود را وارد کنید.";
                              }
                            },
                            onSaved: (String value) {
                              _email = value;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'ایمیل',
                              border: new OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            minLines: 1,
                            // ignore: missing_return
                            validator: (String value) {
                              if (value.trim().isEmpty) {
                                return "لطفا نظر خود را وارد کنید.";
                              }
                            },
                            onSaved: (String value) {
                              _comment = value;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today),
                              labelText: 'توضیحات',
                              border: new OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: ButtonTheme(
                            height: 50.0,
                            minWidth: MediaQuery.of(context).size.width - 50,
                            child: RaisedButton(
                              child: Text("ثبت نظر"),
                              elevation: 8.0,
                              highlightElevation: 0.0,
                              color: Colors.red,
                              textColor: Colors.white,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  setState(() {
                                    send = 1;
                                  });
                                  _sendCommentData();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            send == 1
                ? Opacity(
                    opacity: 0.5,
                    child: Container(
                      color: Colors.black,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : Text("")
          ],
        ),
      ),
    );
  }

  _sendCommentData() {
    String url = AppData.serverUrl +
        "?action=add_comment&product_id=" +
        widget.productId.toString();
    http.post(url, body: {
      "name": _name,
      "email": _email,
      "comment": _comment
    }).then((response) {
      print(response.body);
      setState(() {
        send = 0;
        _formKey.currentState.reset();
      });
    });
  }
}
