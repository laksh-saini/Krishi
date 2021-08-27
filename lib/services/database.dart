import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_app/models/grains.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection("grains");

  Future<void> updateUserData(
    String name,
  ) async {
    return await dataCollection.doc(uid).set({
      "name": name,
    });
  }

  List<Grains> _grainslistFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Grains(
        name: doc.data()['name'] ?? " ",
      );
    }).toList();
  }

  //brew list from snapshot
  Stream<List<Grains>> get grains {
    return dataCollection.snapshots().map(_grainslistFromSnapshot);
  }
}
