import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/count_data.dart';

class CountDataDao {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('collection_count');

  void saveCountData(CountData countData) {
    _collection.add(countData.toJson());
  }

  Stream<QuerySnapshot> getSnapshots() {
    return _collection
        .orderBy('dateTime', descending: true)
        .limit(5)
        .snapshots();
  }
}
