import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/workout_model.dart';
import '../services/firestore_service.dart';

class WorkoutViewModel extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  final String _collection = 'workouts';
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  String get _path {
    if (_uid == null) throw Exception("User not authenticated");
    return 'users/$_uid/$_collection';
  }

  Stream<List<WorkoutModel>> get workoutStream {
    if (_uid == null) return const Stream.empty();
    return _firestore.collectionStream(_path, orderByField: 'date', descending: true)
      .map((snapshot) => snapshot.docs.map((doc) => WorkoutModel.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addWorkout(WorkoutModel workout) async {
    if (_uid == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      await _firestore.addDocument(_path, workout.toMap());
    } catch (e) {
      debugPrint("Error adding workout: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteWorkout(String id) async {
    if (_uid == null) return;
    try {
      await _firestore.deleteDocument('$_path/$id');
    } catch (e) {
      debugPrint("Error deleting workout: $e");
    }
  }
}
