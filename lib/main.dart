import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shop_practice/screens/HomeScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fa'),
      ],
      theme: ThemeData(
        fontFamily: 'far_yekan',
        primaryColor: Colors.redAccent,
      ),
      title: 'Flutter Demo',
      home: Material(
        color: Colors.white,
        child: HomeView(),
      ),
      routes: {
        '/home': (BuildContext context) => HomeView(),
      },
      // onGenerateRoute: (RouteSettings setting) {
      //   List<String> params = setting.name.split('/');
      //   if (params.length > 1 && params[1] == "home") {
      //     print(params[2]);
      //     print(params[3]);
      //     return MaterialPageRoute(builder: (BuildContext context) => HomeView());
      //   }
      //   return null;
      // },
      // onUnknownRoute: (RouteSettings setting) {
      //   return MaterialPageRoute(builder: (BuildContext context) => CartScreen());
      // },
    );
  }
}
