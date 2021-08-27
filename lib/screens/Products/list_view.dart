import 'package:ai_app/screens/Products/detail.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key key}) : super(key: key);
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageController = TextEditingController();
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

    // Color baseColor = Color(0xFFF2F2F2);
    return StreamBuilder(
      stream: ref.snapshots(),
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
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
                                    builder: (context) => DetailView(
                                      name: doc['name'],
                                      url: doc['imageUrl'],
                                      brand: doc['brand'],
                                      price: doc['price'],
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
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        iconSize: 25,
                                        onPressed: () {
                                          nameController.text = doc['name'];
                                          brandController.text = doc['brand'];
                                          priceController.text = doc['price'];
                                          imageController.text =
                                              doc['imageUrl'];

                                          showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Container(
                                                        decoration:
                                                            new BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          borderRadius:
                                                              new BorderRadius
                                                                  .all(new Radius
                                                                      .circular(
                                                                  500.0)),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  15.0,
                                                                  15,
                                                                  15,
                                                                  5),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "Update Product",
                                                                style: TextStyle(
                                                                    letterSpacing:
                                                                        0,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              SizedBox(
                                                                height: 25,
                                                              ),
                                                              ListView(
                                                                shrinkWrap:
                                                                    true,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Form(
                                                                          key:
                                                                              _formKey,
                                                                          child:
                                                                              Column(children: [
                                                                            _buildTextField(
                                                                                nameController,
                                                                                'Name',
                                                                                'Please enter a valid product ',
                                                                                TextInputType.name),
                                                                            SizedBox(
                                                                              height: 25,
                                                                            ),
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
                                                                                priceController,
                                                                                'Price',
                                                                                'Please enter a valid price',
                                                                                TextInputType.number),
                                                                            SizedBox(
                                                                              height: 25,
                                                                            ),
                                                                            _buildTextField(
                                                                                imageController,
                                                                                'Image',
                                                                                'Please upload a valid image',
                                                                                TextInputType.url),
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
                                title: Text(
                                  'Product: ' + doc['name'],
                                ),
                                subtitle: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Name: ' + doc['brand'],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Price: ' + doc['price'] + ' per kg',
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start),
                                trailing: Image.network(
                                  doc['imageUrl'],
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        } else
          return Text('');
      },
    );
  }
}
