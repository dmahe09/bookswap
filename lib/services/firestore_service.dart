import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/book.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get booksRef => _db.collection('books');

  Future<DocumentReference> createBook(Map<String, dynamic> data) async {
    return await booksRef.add(data);
  }

  Stream<List<Book>> streamBooks() {
    return booksRef.snapshots().map((snap) => snap.docs.map((d) => Book.fromMap(d.id, d.data() as Map<String, dynamic>)).toList());
  }

  Future<void> updateBook(String id, Map<String, dynamic> data) async {
    await booksRef.doc(id).update(data);
  }

  Future<void> deleteBook(String id) async {
    await booksRef.doc(id).delete();
  }
}
