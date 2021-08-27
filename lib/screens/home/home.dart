import 'dart:async';

import 'package:ai_app/localization.dart/demo_localiztion.dart';
import 'package:ai_app/screens/Products/crud.dart';
import 'package:ai_app/screens/Products/detail.dart';
import 'package:ai_app/screens/home/main_drawer.dart';
import 'package:ai_app/services/List.dart';
import 'package:ai_app/services/get_translated.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:ai_app/services/database.dart';
import 'package:ai_app/services/loading.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

import 'package:ai_app/models/grains.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool settings;
  bool isSearching;
  bool isLoading = true;

  Future<void> getBoolValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool('isFarmer');
    // print(boolValue);

    setState(() {
      settings = boolValue;
    });
  }

  GoogleTranslator googleTranslator = GoogleTranslator();

  TextEditingController _searchController = TextEditingController();

  String name = "";
  String cities;
  String _chosenValue = 'two';

  TextEditingController nameController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  _buildTextField(
    TextEditingController controller,
    String labelText,
    String validator,
    TextInputType keyboardtype,
  ) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return validator;
        }
        return null;
      },
      controller: controller,
      keyboardType: keyboardtype,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: labelText,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  CollectionReference ref = FirebaseFirestore.instance.collection('products');

  void initiateSearch(String val) {
    setState(() {
      name = val.toLowerCase().trim();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getBoolValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    Timer timer = Timer(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User user = auth.currentUser;

    // Color baseColor = Color(0xFFF2F2F2);
    final ColorMain = Color(0xFF4B53F2);
    return StreamProvider<List<Grains>>.value(
      value: DatabaseService().grains,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              DemoLocalization.of(context).getTranslatedValue('home_page'),
              style: Theme.of(context).textTheme.headline6,
            ),
            // title: Text(
            //   "Krishi",
            //   style: Theme.of(context).textTheme.headline6,
            // ),
            elevation: 0.0,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          ),
          drawer: Main_Drawer(
            obtained: settings,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        getTranslated(context, 'buy_line'),
                        // "Buy the products directly from the producers",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              letterSpacing: 0,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35.0, 0, 35, 0),
                      child: TextFormField(
                        controller: _searchController,
                        onChanged: (val) {
                          initiateSearch(val);
                          setState(() {
                            isSearching = true;
                          });
                        },
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            prefixIcon: Icon(Icons.search, color: ColorMain),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.cancel, color: ColorMain),
                              onPressed: () {
                                setState(() {
                                  isSearching = false;
                                  name = null;
                                  cities = null;
                                  _searchController.clear();
                                });
                              },
                            ),
                            hintText: getTranslated(context, 'search'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    name != "" && name != null
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(35.0, 0, 35, 0),
                            child: DropdownButtonFormField(
                              validator: (value) => value == null
                                  ? getTranslated(context, 'city')
                                  : null,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintText: getTranslated(context, 'city'),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0))),
                              hint: Text(getTranslated(context, 'city')),
                              items: ListStates.map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              value: cities,
                              onChanged: (value) {
                                cities = value;
                                setState(() {
                                  isSearching = true;
                                });
                              },
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(35.0, 0, 35, 0),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0))),
                              disabledHint: Text(getTranslated(context, 'for')),
                              items: null,
                              value: null,
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(35.0, 0, 35, 0),
                    //   child: DropdownButtonFormField<String>(
                    //     // decoration: InputDecoration(
                    //     //     contentPadding:
                    //     //         EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //     //     border: OutlineInputBorder(
                    //     //         borderRadius: BorderRadius.circular(32.0))),

                    //     value: _chosenValue,
                    //     decoration: InputDecoration(
                    //         contentPadding:
                    //             EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //         border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(32.0))),
                    //     icon: Icon(Icons.sort),
                    //     //elevation: 5,
                    //     style: TextStyle(color: Colors.black),

                    //     items: [
                    //       DropdownMenuItem(
                    //         child: Text(
                    //           getTranslated(context, 'ar'),
                    //           style: Theme.of(context).textTheme.bodyText2,
                    //         ),
                    //         value: 'one',
                    //       ),
                    //       DropdownMenuItem(
                    //         child: Text(getTranslated(context, 'eq'),
                    //             style: Theme.of(context).textTheme.bodyText2),
                    //         value: 'two',
                    //       ),
                    //       DropdownMenuItem(
                    //         child: Text(getTranslated(context, 'et'),
                    //             style: Theme.of(context).textTheme.bodyText2),
                    //         value: 'three',
                    //       ),
                    //     ],
                    //     hint: Text(
                    //       "",
                    //       style: TextStyle(
                    //           color: Colors.black,
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w600),
                    //     ),
                    //     onChanged: (String newValue) {
                    //       setState(() {
                    //         _chosenValue = newValue;
                    //       });
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: StreamBuilder(
                stream: name != "" && name != null && isSearching == true
                    ? FirebaseFirestore.instance
                        .collection('products')
                        .where("searchindex", arrayContains: name)
                        .where('city', isEqualTo: cities)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection("products")
                        .snapshots(),
                builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return isLoading == true
                        ? ShimmerList()
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              var doc = snapshot.data.docs[index].data();
                              return Container(
                                width: 200,
                                child: Column(
                                  children: [
                                    Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailView(
                                                  name: doc['name'],
                                                  url: doc['imagelocation'],
                                                  brand: doc['brand'],
                                                  price:
                                                      doc['price'].toString(),
                                                  pincode: doc['pincode'],
                                                  quantity:
                                                      doc['Quantity Available'],
                                                  paisa: settings,
                                                  phone: doc['number'],
                                                ),

                                                // settings: RouteSettings(
                                                //   arguments: doc['name'],
                                                // )),
                                              ));
                                        },
                                        child: Card(
                                          elevation: 3,
                                          child: ListTile(
                                            leading: user.uid == doc['uid']
                                                ? IconButton(
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    iconSize: 25,
                                                    onPressed: () {
                                                      nameController.text =
                                                          doc['name'];
                                                      brandController.text =
                                                          doc['brand'];
                                                      priceController.text =
                                                          doc['price']
                                                              .toString();
                                                      pincodeController.text =
                                                          doc['pincode'];
                                                      numberController.text =
                                                          doc['number'];

                                                      showDialog(
                                                          context: context,
                                                          builder:
                                                              (context) =>
                                                                  Dialog(
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            new BoxDecoration(
                                                                          shape:
                                                                              BoxShape.rectangle,
                                                                          borderRadius:
                                                                              new BorderRadius.all(new Radius.circular(500.0)),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              15.0,
                                                                              15,
                                                                              15,
                                                                              5),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Text(
                                                                                "Update Product",
                                                                                style: TextStyle(letterSpacing: 0, fontSize: 20, fontWeight: FontWeight.w500),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 25,
                                                                              ),
                                                                              ListView(
                                                                                shrinkWrap: true,
                                                                                children: [
                                                                                  Column(
                                                                                    children: [
                                                                                      Form(
                                                                                          key: _formKey,
                                                                                          child: Column(children: [
                                                                                            // _buildTextField(nameController, 'Name', 'Please enter a valid product ', TextInputType.name),
                                                                                            // SizedBox(
                                                                                            //   height: 25,
                                                                                            // ),
                                                                                            _buildTextField(
                                                                                              brandController,
                                                                                              'Seller Name',
                                                                                              'Please enter a valid name',
                                                                                              TextInputType.name,
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 25,
                                                                                            ),
                                                                                            _buildTextField(priceController, 'Price', 'Please enter a valid price', TextInputType.number),
                                                                                            SizedBox(
                                                                                              height: 25,
                                                                                            ),
                                                                                            _buildTextField(
                                                                                              numberController,
                                                                                              'Phone Number',
                                                                                              'Please enter a valid number',
                                                                                              TextInputType.number,
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 25,
                                                                                            ),
                                                                                            _buildTextField(pincodeController, 'Pincode', 'Please enter a valid pincode', TextInputType.number),
                                                                                            SizedBox(
                                                                                              height: 25,
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 35,
                                                                                            ),

                                                                                            Material(
                                                                                                elevation: 10.0,
                                                                                                borderRadius: BorderRadius.circular(30.0),
                                                                                                color: Color(0xFF4B53F2),
                                                                                                child: MaterialButton(
                                                                                                  minWidth: MediaQuery.of(context).size.width,
                                                                                                  padding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
                                                                                                  onPressed: () async {
                                                                                                    if (_formKey.currentState.validate()) {}

                                                                                                    snapshot.data.docs[index].reference.update({
                                                                                                      "name": nameController.text,
                                                                                                      "brand": brandController.text,
                                                                                                      "price": int.parse(priceController.text),
                                                                                                      "imageUrl": imageController.text,
                                                                                                      "number": numberController.text,
                                                                                                      "pincode": pincodeController.text,
                                                                                                    }).whenComplete(() => Navigator.pop(context));
                                                                                                  },
                                                                                                  child: Text(
                                                                                                    "Update Product",
                                                                                                    textAlign: TextAlign.center,
                                                                                                    style: TextStyle(color: Colors.white),
                                                                                                  ),
                                                                                                )),
                                                                                            SizedBox(
                                                                                              height: 20,
                                                                                            ),
                                                                                            Material(
                                                                                                elevation: 10.0,
                                                                                                borderRadius: BorderRadius.circular(30.0),
                                                                                                color: Colors.redAccent,
                                                                                                child: MaterialButton(
                                                                                                  minWidth: MediaQuery.of(context).size.width,
                                                                                                  padding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
                                                                                                  onPressed: () async {
                                                                                                    snapshot.data.docs[index].reference.delete().whenComplete(() => Navigator.pop(context));
                                                                                                  },
                                                                                                  child: Text(
                                                                                                    "Delete",
                                                                                                    textAlign: TextAlign.center,
                                                                                                    style: TextStyle(color: Colors.white),
                                                                                                  ),
                                                                                                )),
                                                                                            SizedBox(
                                                                                              height: 20,
                                                                                            )
                                                                                          ]))
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ));
                                                    },
                                                  )
                                                : null,
                                            title: Text(getTranslated(
                                                    context, 'product') +
                                                ": " +
                                                doc['name']),
                                            subtitle: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(getTranslated(
                                                          context, 'sname') +
                                                      ": " +
                                                      doc['brand']),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    getTranslated(
                                                            context, 'P') +
                                                        ": " +
                                                        doc['price']
                                                            .toString() +
                                                        ' per kg',
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(getTranslated(
                                                          context, 'pi') +
                                                      ": " +
                                                      doc['pincode']),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start),
                                            // trailing: Container(
                                            //   width: 100.0,
                                            //   height: 100.0,
                                            //   decoration: BoxDecoration(
                                            //     shape: BoxShape.rectangle,
                                            //     image: DecorationImage(
                                            //         image: NetworkImage(
                                            //             doc['imagelocation']),
                                            //         fit: BoxFit.cover),
                                            //   ),
                                            // ),
                                            trailing: CachedNetworkImage(
                                              // height: 100,
                                              // width: 100,
                                              imageUrl: doc['imagelocation'],
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: 100.0,
                                                height: 100.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover),
                                                ),
                                                //   ),
                                                //   placeholder: (context, url) =>
                                                //       Loading2(),
                                                //   errorWidget:
                                                //       (context, url, error) =>
                                                //           Icon(Icons.error),
                                                // ),
                                                //     Image.network(
                                                //   doc['imagelocation'],
                                                //   height: 100,
                                                //   width: 100,
                                                //   fit: BoxFit.cover,
                                                // ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              );
                            });
                  } else
                    return ShimmerList();
                },
              )),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            elevation: 10.0,
            label: Text(
              DemoLocalization.of(context).getTranslatedValue('sell'),
            ),
            icon: Icon(Icons.add),
            backgroundColor: new Color(0xFFE57373),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductSreen()),
              );
            },
          )),
    );
  }
}
