import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/water_model.dart';
import '../services/firestore_service.dart';

class WaterViewModel extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  final String _collection = 'water';
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  String get _path {
    if (_uid == null) throw Exception("User not authenticated");
    return 'users/$_uid/$_collection';
  }

  Stream<List<WaterModel>> get waterHistoryStream {
    if (_uid == null) return const Stream.empty();
    return _firestore.collectionStream(_path, orderByField: 'date', descending: true)
      .map((snapshot) => snapshot.docs.map((doc) => WaterModel.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addWater(int amountMl) async {
    if (_uid == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      final water = WaterModel(id: '', amountMl: amountMl, date: DateTime.now());
      await _firestore.addDocument(_path, water.toMap());
    } catch (e) {
      debugPrint("Error adding water: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
