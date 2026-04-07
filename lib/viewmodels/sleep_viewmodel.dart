import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/sleep_model.dart';
import '../services/firestore_service.dart';

class SleepViewModel extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  final String _collection = 'sleep';
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  String get _path {
    if (_uid == null) throw Exception("User not authenticated");
    return 'users/$_uid/$_collection';
  }

  Stream<List<SleepModel>> get sleepStream {
    if (_uid == null) return const Stream.empty();
    return _firestore.collectionStream(_path, orderByField: 'date', descending: true)
      .map((snapshot) => snapshot.docs.map((doc) => SleepModel.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addSleepEntry(SleepModel sleep) async {
    if (_uid == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      await _firestore.addDocument(_path, sleep.toMap());
    } catch (e) {
      debugPrint("Error adding sleep: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
