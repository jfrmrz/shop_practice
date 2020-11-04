import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as Convert;
import '../appData.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int send = 0;
  bool checkBoxChanged = false;
  bool obscureText = true;
  String mobile = "";
  String password = "";
  String errorLogin = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("ورود"),
          backgroundColor: Colors.red,
          elevation: 0,
        ),
        body: _loginForm(),
      ),
    );
  }

  _sendData() {
    setState(() {
      send = 1;
    });
    String url = AppData.serverUrl + "?action=login";
    http.post(url, body: {"mobile": mobile, "password": password}).then(
        (response) {
      if (response.statusCode == 200) {

        Map<String, dynamic> data = Convert.jsonDecode(response.body);
        if (data.containsKey("token")) {

          _saveData(data['token'], data['name'], data['mobile'], data['time'])
              .then((value) {
            if (value) {

              Navigator.pushReplacementNamed(context, '/home');
            } else {
              setState(() {
                send = 0;
                errorLogin = "خطایی رخ داده است٬ لطفا دوباره تلاش نمایید.";
              });
            }
          });
        } else {
          setState(() {
            send = 0;
            errorLogin = data['error'];
          });
        }
      } else {
        setState(() {
          errorLogin = "خطا در ارتباط با سرور٬ دوباره تلاش نمایید.";
        });
      }
    });
  }

  Future<bool> _saveData(
      String token, String name, String mobile, int time) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("token", token);
    sharedPreferences.setString("name", name);
    sharedPreferences.setString("mobile", mobile);
    sharedPreferences.setInt("time", time);
    return true;
  }

  Widget _loginForm() {
    return Stack(
      children: <Widget>[
        SafeArea(
          child: Center(
            child: IntrinsicHeight(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'شماره موبایل',
                          contentPadding: EdgeInsets.all(7.0),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.trim().isEmpty) {
                            return 'لطفا شماره موبایل خود را وارد نمایید.';
                          } else if (!AppData.checkMobileNumber(value)) {
                            return 'شماره موبایل وارد شده معتبر نیست.';
                          }
                        },
                        onSaved: (String value) {
                          mobile = value;
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'کلمه عبور',
                          contentPadding: EdgeInsets.all(7.0),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.trim().isEmpty) {
                            return 'لطفا کلمه عبور خود را وارد نمایید.';
                          }
                        },
                        onSaved: (String value) {
                          password = value;
                        },
                        obscureText: obscureText,
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: checkBoxChanged,
                            onChanged: (bool status) {
                              setState(() {
                                checkBoxChanged = status;
                                obscureText = !status;
                              });
                            },
                            activeColor: Colors.redAccent,
                          ),
                          Text(
                            "نمایش کلمه عبور",
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        errorLogin,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 40.0),
                      ButtonTheme(
                        height: 50.0,
                        // bottom line's alternative => MediaQuery.of(context).size.width,
                        minWidth: double.infinity,
                        child: RaisedButton(
                          child: Text("ورود"),
                          elevation: 8.0,
                          highlightElevation: 0.0,
                          color: Colors.red,
                          textColor: Colors.white,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _sendData();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        send == 1
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
}
