import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> setDocument(String path, Map<String, dynamic> data) async {
    await _db.doc(path).set(data, SetOptions(merge: true));
  }

  Future<void> addDocument(String collectionPath, Map<String, dynamic> data) async {
    await _db.collection(collectionPath).add(data);
  }

  Future<void> deleteDocument(String path) async {
    await _db.doc(path).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> collectionStream(String path, {String? orderByField, bool descending = false}) {
    Query<Map<String, dynamic>> query = _db.collection(path);
    if (orderByField != null) {
      query = query.orderBy(orderByField, descending: descending);
    }
    return query.snapshots();
  }
  
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(String path) async {
    return await _db.doc(path).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> documentStream(String path) {
    return _db.doc(path).snapshots();
  }
}
