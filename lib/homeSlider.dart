import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'appData.dart';
import 'model/appSlider.dart';

class HomeSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeSliderState();
  }
}

class _HomeSliderState extends State<HomeSlider> {
  List<AppSlider> sliders = [];
  int sliderPosition = 0;

  void getSliders() {
    if (sliders.length == 0) {
      var url = AppData.serverUrl + "?action=get_sliders";
      http.get(url).then(
        (response) {
          if (response.statusCode == 200) {
            List jsonResponse = convert.jsonDecode(response.body);
            for (int i = 0; i < jsonResponse.length; i++) {
              setState(
                () {
                  sliders.add(
                    AppSlider(
                      imgUrl: jsonResponse[i]['img_url'],
                    ),
                  );
                },
              );
            }
          }
        },
      );
    }
  }

  _HomeSliderState() {
    getSliders();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: sliders.length > 0
          ? Stack(
              children: [
                PageView.builder(
                  itemBuilder: (context, position) {
                    return slidersView(position);
                  },
                  itemCount: sliders.length,
                  onPageChanged: (position) {
                    setState(() {
                      sliderPosition = position;
                    });
                  },
                ),
                Container(
                  child: Center(
                    child: sliderDots(),
                  ),
                  margin: EdgeInsets.only(top: 160.0),
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      height: 200,
    );
  }

  Widget slidersView(position) {
    return Image(
      image: NetworkImage(
          AppData.serverUrl + sliders[position].imgUrl),
      fit: BoxFit.fitWidth,
    );
  }

  Widget sliderDots() {
    List<Widget> sliderDotsItem = [];
    for (int i = 0; i < sliders.length; i++) {
      i == sliderPosition
          ? sliderDotsItem.add(_active())
          : sliderDotsItem.add(_inActive());
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: sliderDotsItem,
    );
  }

  Widget _active() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      width: 10.0,
      height: 10.0,
      margin: EdgeInsets.only(right: 5.0),
    );
  }

  Widget _inActive() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[400],
        shape: BoxShape.circle,
      ),
      width: 10.0,
      height: 10.0,
      margin: EdgeInsets.only(right: 5.0),
    );
  }
}
