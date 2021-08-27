import 'package:ai_app/services/get_translated.dart';
import 'package:ai_app/services/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitDualRing(
          color: Colors.blueAccent,
          size: 50.0,
        ),
      ),
    );
  }
}

class Loading2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitRipple(
        color: Colors.blueAccent,
        size: 50.0,
      ),
    );
  }
}

class Loading3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'home')),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 250,
            ),
            SpinKitRipple(
              color: Colors.blueAccent,
              size: 50.0,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              getTranslated(context, "do"),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;

    return ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child) {
          return notifier.darkTheme
              ? SafeArea(
                  child: ListView.builder(
                    itemCount: 6,
                    itemBuilder: (BuildContext context, int index) {
                      offset += 5;
                      time = 800 + offset;

                      return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Shimmer.fromColors(
                            highlightColor: Colors.grey[800],
                            baseColor: Colors.grey[850],
                            child: ShimmerLayout(),
                            period: Duration(milliseconds: time),
                          ));
                    },
                  ),
                )
              : SafeArea(
                  child: ListView.builder(
                    itemCount: 6,
                    itemBuilder: (BuildContext context, int index) {
                      offset += 5;
                      time = 800 + offset;

                      return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Shimmer.fromColors(
                            highlightColor: Colors.white,
                            baseColor: Color(0xFFEBEBF4),
                            child: ShimmerLayout(),
                            period: Duration(milliseconds: time),
                          ));
                    },
                  ),
                );
        }));
  }
}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double containerWidth = 280;
    double containerHeight = 15;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 100,
            width: 100,
            color: Color(0xFFEBEBF4),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: containerHeight,
                width: containerWidth,
                color: Color(0xFFEBEBF4),
              ),
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: containerWidth,
                color: Color(0xFFEBEBF4),
              ),
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: containerWidth * 0.75,
                color: Color(0xFFEBEBF4),
              )
            ],
          )
        ],
      ),
    );
  }
}
