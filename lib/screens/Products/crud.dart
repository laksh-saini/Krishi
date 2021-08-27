import 'package:ai_app/services/get_translated.dart';
import 'package:ai_app/services/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_app/services/List.dart';

class AddProductSreen extends StatefulWidget {
  @override
  _AddProductSreenState createState() => _AddProductSreenState();
}

class _AddProductSreenState extends State<AddProductSreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  Map<String, dynamic> productToAdd;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('products');
  final FirebaseAuth auth = FirebaseAuth.instance;
  void inputData() {
    // here you write the codes to input the data into firestore
  }

  var helloindex = [];
  var imageisplay;
  PickedFile imageFile;
  String imageUrl;
  String locationimage;
  String countryValue;
  String stateValue;
  String cityValue;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  uploadData(String name) async {
    List<String> splitlist = name.split(' ');
    List<String> indexList = [];
    for (int i = 0; i < splitlist.length; i++) {
      for (int j = 0; j < splitlist[i].length; j++) {
        indexList.add(splitlist[i].substring(0, j + 1).toLowerCase());
      }
    }
    helloindex = indexList;
  }

  addProduct() {
    final User user = auth.currentUser;
    uploadData(nameController.text);

    productToAdd = {
      "name": nameController.text,
      "brand": brandController.text,
      "price": int.parse(priceController.text),
      "imageUrl": imageController.text,
      "Quantity Available": quantityController.text,
      "uid": user.uid,
      "searchindex": helloindex,
      "imagelocation": locationimage,
      "pincode": pincodeController.text,
      "number": numberController.text,
      "city": cityValue,
      "dob": FieldValue.serverTimestamp(),
    };

    collectionReference.add(productToAdd);
  }

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

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      imageFile = pickedFile;
    });
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      imageFile = pickedFile;
    });
  }

  Future _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(new Radius.circular(9.0)),
            ),
            title: Center(
              child: Text(
                getTranslated(context, "choose"),
                style: TextStyle(),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  // Divider(
                  //   height: 1,
                  //   color: Color(0xFF4B53F2),
                  // ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                      Navigator.pop(context);
                    },
                    title: Text(
                      getTranslated(context, 'gallery'),
                    ),
                    leading: Icon(
                      Icons.account_box,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                      Navigator.pop(context);
                    },
                    title: Text(getTranslated(context, "cam")),
                    leading: Icon(
                      Icons.camera_alt,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = imageFile.path;
    var file = File(imageFile.path);

    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    final downloadUrl = await taskSnapshot.ref.getDownloadURL();

    locationimage = downloadUrl;
  }
  // uploadImage() async {
  //   final _firebaseStorage = FirebaseStorage.instance;
  //   final _imagePicker = ImagePicker();
  //   PickedFile image;
  //   //Check Permissions
  //   await Permission.photos.request();

  //   var permissionStatus = await Permission.photos.status;

  //   if (permissionStatus.isGranted) {
  //     //Select Image
  //     image = await _imagePicker.getImage(source: ImageSource.gallery);
  //     var file = File(image.path);

  //     if (image != null) {
  //       //Upload to Firebase
  //       var snapshot = await _firebaseStorage
  //           .ref()
  //           .child('images/imageName')
  //           .putFile(file);
  //       var downloadUrl = await snapshot.ref.getDownloadURL();
  //       setState(() {
  //         imageUrl = downloadUrl;
  //       });
  //     } else {
  //       print('No Image Path Received');
  //     }
  //   } else {
  //     print('Permission not granted. Try Again with permission access');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(getTranslated(context, 'selly'),
                  style: Theme.of(context).textTheme.headline6),
              centerTitle: true,
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 25, 15, 0),
                child: Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _showChoiceDialog(context);
                        },
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: imageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(
                                    File(imageFile.path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(50)),
                                  width: 100,
                                  height: 100,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[800],
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(children: [
                          _buildTextField(
                              nameController,
                              getTranslated(context, 'product'),
                              getTranslated(context, 'er1'),
                              TextInputType.name),
                          SizedBox(
                            height: 28,
                          ),
                          _buildTextField(
                            brandController,
                            getTranslated(context, 'sname'),
                            getTranslated(context, 'er2'),
                            TextInputType.name,
                          ),
                          SizedBox(
                            height: 28,
                          ),
                          _buildTextField(
                              priceController,
                              getTranslated(context, "P"),
                              getTranslated(context, 'er3'),
                              TextInputType.number),
                          SizedBox(
                            height: 28,
                          ),
                          _buildTextField(
                            quantityController,
                            getTranslated(context, 'q'),
                            getTranslated(context, 'er4'),
                            TextInputType.number,
                          ),
                          SizedBox(
                            height: 28,
                          ),
                          _buildTextField(
                            pincodeController,
                            getTranslated(context, 'pi'),
                            getTranslated(context, 'er5'),
                            TextInputType.number,
                          ),
                          SizedBox(
                            height: 28,
                          ),
                          _buildTextField(
                            numberController,
                            getTranslated(context, 'ph'),
                            getTranslated(context, 'er6'),
                            TextInputType.number,
                          ),
                          SizedBox(
                            height: 28,
                          ),
                          DropdownButtonFormField(
                            validator: (value) => value == null
                                ? getTranslated(context, 'er7')
                                : null,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                hintText: getTranslated(context, 'city'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0))),
                            hint: Text(getTranslated(context, 'city')),
                            items: ListStates.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            value: cityValue,
                            onChanged: (value) {
                              cityValue = value;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            getTranslated(context, 'tip'),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(70.0, 0, 70, 0),
                            child: Material(
                                elevation: 10.0,
                                borderRadius: BorderRadius.circular(30.0),
                                color: Color(0xFF4B53F2),
                                child: MaterialButton(
                                  minWidth: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.fromLTRB(
                                      0.0, 15.0, 20.0, 15.0),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate() &&
                                        imageFile != null) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await uploadImageToFirebase(context);
                                      await addProduct();

                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    getTranslated(context, 'regp'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ]))
                  ],
                ),
              ),
            ),
          );
  }
}
