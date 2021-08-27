import 'package:ai_app/screens/home/purchase.dart';
import 'package:ai_app/services/get_translated.dart';
import 'package:ai_app/services/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class DetailView extends StatelessWidget {
  final String name;
  final String url;
  final String brand;
  final String price;
  final bool paisa;
  final String pincode;
  final String quantity;
  final String phone;

  const DetailView(
      {Key key,
      this.name,
      this.phone,
      this.url,
      this.pincode,
      this.brand,
      this.price,
      this.paisa,
      this.quantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final String todo = ModalRoute.of(context).settings.arguments;
    return Scaffold(

        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   iconTheme: IconThemeData(color: Colors.black),
        //   title: Text(
        //     name,
        //     style: TextStyle(color: Colors.black),
        //   ),
        //   elevation: 0.0,
        //   centerTitle: true,
        // ),
        body: SingleChildScrollView(
      child: SafeArea(
        child: Column(children: [
          Container(
            width: 550,
            child: ClipPath(
                clipper: MyClipper(),
                child: Stack(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: url,
                      placeholder: (context, url) => Loading(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    // Image.network(
                    //   url,
                    //   fit: BoxFit.cover,
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8.0, 0, 0),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back,
                                size: 25, color: Colors.white),
                          )),
                    ),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 5, 24, 0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              elevation: 10,
              child: Center(
                child: Column(children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(name.toTitleCase(),
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            letterSpacing: 0,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      )),
                  SizedBox(
                    height: 25,
                  ),
                  Text(getTranslated(context, 'P') + ": " + price),
                  SizedBox(
                    height: 5,
                  ),
                  Text(getTranslated(context, 'sname') +
                      ": " +
                      brand.toTitleCase()),
                  SizedBox(
                    height: 5,
                  ),
                  Text(getTranslated(context, 'q') + ": " + quantity + " kg"),
                  SizedBox(
                    height: 5,
                  ),
                  Text(getTranslated(context, 'pi') + ": " + pincode),
                  SizedBox(
                    height: 35,
                  )
                ]),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(70.0, 0, 70, 0),
              child: Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Color(0xFF4B53F2),
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PurchaseProduct(
                                  name: name,
                                  owner: brand.toTitleCase(),
                                  number: phone,
                                  url: url,
                                )),
                      );
                    },
                    child: Text(
                      getTranslated(context, 'pu'),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ))),
          SizedBox(
            height: 50,
          )
        ]),
      ),
    ));
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

String convertToTitleCase(String text) {
  if (text == null) {
    return null;
  }

  if (text.length <= 1) {
    return text.toUpperCase();
  }

  // Split string into multiple words
  final List<String> words = text.split(' ');

  // Capitalize first letter of each words
  final capitalizedWords = words.map((word) {
    final String firstLetter = word.substring(0, 1).toUpperCase();
    final String remainingLetters = word.substring(1);

    return '$firstLetter$remainingLetters';
  });

  // Join/Merge all words back to one String
  return capitalizedWords.join(' ');
}

extension CapitalizedStringExtension on String {
  String toTitleCase() {
    return convertToTitleCase(this);
  }
}

showPurchaseDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel", style: TextStyle(color: Colors.redAccent)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("Proceed", style: TextStyle(color: Colors.redAccent)),
    onPressed: () async {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PurchaseProduct()),
      );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Buy Product"),
    content: Text("We are glad you liked our farmer's hardwork."),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
