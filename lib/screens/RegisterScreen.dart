import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../appData.dart';
import 'dart:convert' as Convert;
import 'dart:async';

import 'LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  String requestCodeText = "ارسال مجدد کد فعال سازی: 10 ثانیه";
  String setTime = "ok";
  String resend = "no";
  String getActiveCode = "no";
  String form = "register";
  String activated = "no";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String name, mobile, email, password;
  int send = 0;
  String error = "";
  var focusNode1 = new FocusNode();
  var focusNode2 = new FocusNode();
  var focusNode3 = new FocusNode();
  var focusNode4 = new FocusNode();
  var focusNode5 = new FocusNode();
  String code1 = "";
  String code2 = "";
  String code3 = "";
  String code4 = "";
  String code5 = "";

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          appBar: AppBar(
            title: Text("ثبت نام"),
            backgroundColor: Colors.red,
            elevation: 0.0,
            //leading: Icon(Icons.close),
          ),
          body: Builder(
            builder: (context) {
              return widget.activated == "no"
                  ? SingleChildScrollView(
                      child: widget.form == "active"
                          ? _activateForm(context)
                          : _registerForm(),
                    )
                  : Center(
                      child: IntrinsicHeight(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "فعالسازی حساب کاربری شما با موفقیت انجام شد.",
                              textAlign: TextAlign.center,
                            ),
                            FlatButton(
                              child: Text("ورود"),
                              onPressed: () {
                                AppData.goNewScreen(context, LoginScreen(), 1, 0);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
            },
          )),
    );
  }

  void _sendData() {
    String url = AppData.serverUrl + "?action=register_user";
    http.post(url, body: {
      "name": name,
      "mobile": mobile,
      "email": email,
      "password": password
    }).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> data = Convert.jsonDecode(response.body);

        if (data.containsKey("error")) {
          setState(() {
            send = 0;
            error = data['error'];
          });
        } else {
          setState(() {
            widget.form = "active";
          });
        }
      } else {
        setState(() {
          send = 0;
          error = "خطا در ارتباط با سرور - دوباره تلاش نمایید";
        });
      }
    });
  }

  Widget _registerForm() {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'نام و نام خانوادگی',
                prefixIcon: Icon(Icons.person),
                //contentPadding: EdgeInsets.all(10.0),
                /*focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                          width: 2.0,
                        ),
                      ),*/
              ),
              //initialValue: name,
              // ignore: missing_return
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return "لطفا نام و نام خانوادگی خود را وارد کنید.";
                } else if (value.trim().length < 6) {
                  return 'نام و نام خانوادگی باید حداقل شامل 6 کاراکتر باشد.';
                }
              },
              onSaved: (String value) {
                name = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'شماره موبایل',
                prefixIcon: Icon(Icons.phone),
                //contentPadding: EdgeInsets.all(10.0),
              ),
              //initialValue: mobile,
              keyboardType: TextInputType.phone,
              // ignore: missing_return
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return "لطفا شماره موبایل خود را وارد کنید.";
                } else {
                  if (!AppData.checkMobileNumber(value)) {
                    return "شماره موبایل وارد شده معتبر نمی باشد.";
                  }
                }
              },
              onSaved: (String value) {
                mobile = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'ایمیل',
                prefixIcon: Icon(Icons.email),
                //contentPadding: EdgeInsets.all(10.0),
              ),
              //initialValue: email,
              keyboardType: TextInputType.emailAddress,
              // ignore: missing_return
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return "لطفا ایمیل خود را وارد نمایید.";
                } else {
                  RegExp emailValidate = RegExp(
                      "^(([0-9a-zA-Z._-])*@([0-9a-zA-Z])*\\.+[a-zA-Z]{2,9})\$");
                  if (!emailValidate.hasMatch(value)) {
                    return "ایمیل وارد شده معتبر نمی باشد.";
                  }
                }
              },
              onSaved: (String value) {
                email = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'کلمه عبور',
                prefixIcon: Icon(Icons.lock),
                //contentPadding: EdgeInsets.all(10.0),
              ),
              //initialValue: password,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              // ignore: missing_return
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return "لطفا کلمه عبور خود را وارد نمایید.";
                } else if (value.trim().length < 6) {
                  return "کلمه باید حداقل شامل 6 کاراکتر باشد.";
                }
              },
              onSaved: (String value) {
                password = value;
              },
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0),
              width: MediaQuery.of(context).size.width,
              child: Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0),
              child: ButtonTheme(
                height: 50.0,
                minWidth: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  child: send == 0
                      ? Text("ثبت نام")
                      : Container(
                          child: CircularProgressIndicator(),
                          height: 24.0,
                          width: 24.0,
                        ),
                  elevation: 8.0,
                  highlightElevation: 0.0,
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () {
                    if (send == 0) {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        setState(() {
                          send = 1;
                        });
                        _sendData();
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activateForm(BuildContext context) {
    String message = "کد فعال سازی ارسال شده به شماره موبایل ";
    message += mobile.toString();
    message += " را وارد نمایید.";

    if (widget.setTime == "ok") {
      widget.setTime = "no";
      _timer();
    }

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.5),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        focusNode: focusNode1,
                        onChanged: (String value) {
                          code1 = value;
                          FocusScope.of(context).requestFocus(focusNode2);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        focusNode: focusNode2,
                        onChanged: (String value) {
                          code2 = value;
                          FocusScope.of(context).requestFocus(focusNode3);
                        },
                        onTap: () {
                          _focusEmptyField();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        focusNode: focusNode3,
                        onChanged: (String value) {
                          code3 = value;
                          FocusScope.of(context).requestFocus(focusNode4);
                        },
                        onTap: () {
                          _focusEmptyField();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        focusNode: focusNode4,
                        onChanged: (String value) {
                          code4 = value;
                          FocusScope.of(context).requestFocus(focusNode5);
                        },
                        onTap: () {
                          _focusEmptyField();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        focusNode: focusNode5,
                        onChanged: (String value) {
                          code5 = value;
                          _activeAccount(context);
                        },
                        onTap: () {
                          _focusEmptyField();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: GestureDetector(
                child: Text(widget.requestCodeText),
                onTap: () {
                  if (widget.resend == "ok") {
                    setState(() {
                      widget.getActiveCode = "ok";
                    });
                    _sendActiveCode(context);
                  }
                },
              ),
            )
          ],
        ),
        widget.getActiveCode == "ok"
            ? Container(
                height: MediaQuery.of(context).size.height,
                color: Color.fromARGB(80, 10, 10, 10),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Text(""),
      ],
    );
  }

  _focusEmptyField() {
    if (code1.trim().isEmpty) {
      FocusScope.of(context).requestFocus(focusNode1);
    } else if (code2.trim().isEmpty) {
      FocusScope.of(context).requestFocus(focusNode2);
    } else if (code3.trim().isEmpty) {
      FocusScope.of(context).requestFocus(focusNode3);
    } else if (code4.trim().isEmpty) {
      FocusScope.of(context).requestFocus(focusNode4);
    }
  }

  _timer() {
    Timer _timer;
    int i = 5;
    const eachSecond = const Duration(seconds: 1);
    _timer = new Timer.periodic(eachSecond, (Timer timer) {
      print(i.toString());
      if (i == 0) {
        i = 5;
        timer.cancel();
        setState(() {
          widget.resend = "ok";
          widget.requestCodeText = "ارسال مجدد کد تایید";
        });
      } else {
        setState(() {
          widget.setTime = "no";
          String message = "ارسال مجدد کد فعال سازی: ";
          String t = i
              .toString()
              .replaceAll("9", "9")
              .replaceAll("8", "8")
              .replaceAll("7", "7")
              .replaceAll("6", "6")
              .replaceAll("5", "5")
              .replaceAll("4", "4")
              .replaceAll("3", "3")
              .replaceAll("2", "2")
              .replaceAll("1", "1")
              .replaceAll("0", "0");
          message += t + " ثانیه";
          widget.requestCodeText = message;
        });

        i -= 1;
      }
    });
  }

  _activeAccount(BuildContext context) {
    String activeCode = code1 + code2 + code3 + code4 + code5;
    print(activeCode);

    String url = AppData.serverUrl + "?action=activeAccount";
    http.post(url, body: {"mobile": mobile, "activeCode": activeCode}).then(
        (response) {
      Map<String, dynamic> data = Convert.jsonDecode(response.body);
      if (data.containsKey("active")) {
        setState(() {
          widget.activated = "ok";
        });
      } else {
        if (activeCode.isNotEmpty) {
          Scaffold.of(context).showSnackBar(
            new SnackBar(
              content: Text(
                "کد وارد شده اشتباه است.",
                style: TextStyle(fontFamily: 'far_yekan'),
              ),
              action: SnackBarAction(
                label: "باشه",
                onPressed: () {
                  Scaffold.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      }
    });
  }

  _sendActiveCode(BuildContext context) {
    String activeCode = code1 + code2 + code3 + code4 + code5;
    widget.resend = "no";
    String url = AppData.serverUrl + "?action=sendActiveCode";
    http.post(url, body: {"mobile": mobile}).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          widget.getActiveCode = "no";
          widget.setTime = "ok";
        });
      } else {
        setState(() {
          widget.getActiveCode = "no";
          widget.resend = "ok";

          if (activeCode.isNotEmpty) {
            Scaffold.of(context).showSnackBar(
              new SnackBar(
                content: Text(
                  "خطا در ارتباط با سرور؛ لظفا دوباره تلاش کنید.",
                  style: TextStyle(fontFamily: 'far_yekan'),
                ),
                action: SnackBarAction(
                  label: "باشه",
                  onPressed: () {
                    Scaffold.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
          }
        });
      }
    });
  }
}
