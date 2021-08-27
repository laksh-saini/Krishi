import 'package:ai_app/screens/authentication/register.dart';
import 'package:ai_app/screens/authentication/sign_in.dart';
import 'package:ai_app/services/get_translated.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        // title: Text(
        //   "APP",
        //   style: TextStyle(color: Colors.black),
        // ),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
        // constraints: BoxConstraints.expand(),
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage("assets/j.png"), fit: BoxFit.cover)),
        child: Center(
          child: Column(
            children: <Widget>[
              Carasouel(),
              // Image.asset(
              //   'assets/b.jpg',
              //   width: 800,
              //   height: 300,
              // ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(
                        getTranslated(context, 'home_page'),
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Colors.indigo[900], fontSize: 25),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      Text(
                        getTranslated(context, 'we'),
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Colors.indigo[900], fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 150,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                FlatButton(
                  color: Color(0xFF4B53F2),
                  minWidth: 150,
                  height: 50,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    getTranslated(context, 'login'),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 25,
                  width: 25,
                ),
                FlatButton(
                  color: Color(0xFF4B53F2),
                  minWidth: 150,
                  height: 50,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register()),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    getTranslated(context, 'reg'),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ])
            ],
          ),
        ),
      ),
    );
  }
}

class Carasouel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color maincolor = Color(0xFF4B53F2);
    return SizedBox(
        height: 200.0,
        width: 350.0,
        child: Carousel(
          images: [
            NetworkImage(
                'https://miro.medium.com/max/5000/1*Dpb3vjQtqb4D1nAU4RnRWA@2x.png'),
            NetworkImage(
                'https://media.istockphoto.com/vectors/woman-with-laptop-sitting-in-nature-and-leaves-concept-illustration-vector-id1139913278?k=6&m=1139913278&s=612x612&w=0&h=vDks140zgZAaCDrxSW0C4IabyHQI7aM8uw0MfM7gMrs='),
            NetworkImage(
              'https://image.freepik.com/free-vector/man-work-working-laptop-flat-colorful-style-violet-background-workplace-web-page-template-vector-illustration_164911-75.jpg',
            ),
          ],
          dotSize: 4.0,
          dotSpacing: 15.0,
          dotColor: maincolor,
          indicatorBgPadding: 5.0,
          dotBgColor: Colors.white,
          dotIncreasedColor: maincolor,
          borderRadius: true,
        ));
  }
}
