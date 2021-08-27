import 'package:ai_app/services/get_translated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PurchaseProduct extends StatelessWidget {
  final String name;
  final String owner;
  final String number;
  final String url;

  const PurchaseProduct({Key key, this.name, this.owner, this.number, this.url})
      : super(key: key);

  _makingPhoneCall() async {
    String fin = number;
    String url = 'tel:+{$fin}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    print(url);
  }

  @override
  Widget build(BuildContext context) {
    Color color = Color(0xFF4B53F2);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          getTranslated(context, 'pu'),
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            CachedNetworkImage(
              // height: 100,
              // width: 100,
              imageUrl: url,
              placeholder: (context, url) => CircularProgressIndicator(),
              imageBuilder: (context, imageProvider) => Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
            ),
            // CachedNetworkImage(
            //   imageUrl: url,
            //   imageBuilder: (context, imageProvider) => Container(
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       image:
            //           DecorationImage(image: imageProvider, fit: BoxFit.fill),
            //     ),
            //   ),
            //   placeholder: (context, url) => Loading(),
            //   errorWidget: (context, url, error) => Icon(Icons.error),
            // ),
            SizedBox(
              height: 50,
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                getTranslated(context, 'glad') + " " + name + " ",
                style: GoogleFonts.roboto(
                    fontSize: 18, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
            )),
            Padding(
              padding: const EdgeInsets.fromLTRB(70.0, 50, 70, 0),
              child: Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: color,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
                    onPressed: () async {
                      _makingPhoneCall();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.call, color: Colors.white),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          getTranslated(context, 'call'),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  )),
            ),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}
