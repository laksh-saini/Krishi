import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  String brand;
  String imageUrl;
  String name;
  String price;
  String uid;

  Products(this.brand, this.imageUrl, this.name, this.price, this.uid);

  Products.fromMap(Map<String, dynamic> data) {
    brand = data['brand'];
    imageUrl = data['imageUrl'];
    name = data['name'];
    price = data['price'];
    uid = data['uid'];
  }

  Products.fromSnapshot(DocumentSnapshot snapshot)
      : brand = snapshot['brand'],
        imageUrl = snapshot['imageUrl'],
        name = snapshot['name'],
        price = snapshot['price'],
        uid = snapshot['uid'];
}
