import 'package:ai_app/services/get_translated.dart';
import 'package:ai_app/services/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ListScreenIndi extends StatefulWidget {
  @override
  _ListScreenIndiState createState() => _ListScreenIndiState();
}

class _ListScreenIndiState extends State<ListScreenIndi> {
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

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(getTranslated(context, "products"),
            style: Theme.of(context).textTheme.headline6),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder(
              stream: ref.snapshots(),
              builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        var doc = snapshot.data.docs[index].data();
                        return user.uid == doc['uid']
                            ? Container(
                                width: 200,
                                child: Column(
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          elevation: 3,
                                          child: ListTile(
                                            leading: user.uid == doc['uid']
                                                ? IconButton(
                                                    icon: Icon(Icons.edit),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    iconSize: 25,
                                                    onPressed: () {
                                                      nameController.text =
                                                          doc['name'];
                                                      brandController.text =
                                                          doc['brand'];
                                                      priceController.text =
                                                          doc['price']
                                                              .toString();
                                                      imageController.text =
                                                          doc['imagelocation'];
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
                                                                          color:
                                                                              const Color(0xFFFFFF),
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

                                                                                            _buildTextField(priceController, 'Price', 'Please enter a valid price', TextInputType.number),
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
                                                                                                      "price": priceController.text,
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
                                            trailing: CachedNetworkImage(
                                              imageUrl: doc['imagelocation'],
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
                                              ),
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                            // Image.network(
                                            //   doc['imagelocation'],
                                            //   height: 100,
                                            //   width: 100,
                                            //   fit: BoxFit.cover,
                                            // ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                color: Colors.white,
                                // child: Padding(
                                //   padding: const EdgeInsets.only(top: 50.0),
                                //   child: Center(
                                //     child: Text(
                                //       'All your products will apear here.',
                                //       style: GoogleFonts.poppins(
                                //           color: Colors.black, fontSize: 14),
                                //     ),
                                //   ),
                                // ),
                              );
                      });
                } else
                  return Text('Error fetching Data. Please try again later');
              },
            ),
          ),
        ],
      ),
    );
  }
}
