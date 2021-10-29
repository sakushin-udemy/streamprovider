import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streamprovider/data/message.dart';

class MessageDao {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('message');

  void saveMessage(Message message) {
    collection.add(message.toJson());
  }

  Stream<QuerySnapshot> getSnapshots() {
    return collection
        .orderBy('dateTime', descending: true)
        .limit(5)
        .snapshots();
  }
}
