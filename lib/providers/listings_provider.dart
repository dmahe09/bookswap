import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../models/book.dart';
import '../services/firestore_service.dart';

class ListingsProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  List<Book> _books = [];
  bool _loading = true;
  String? _error;
  StreamSubscription? _subscription;

  List<Book> get books => _books;
  bool get loading => _loading;
  String? get error => _error;

  List<Book> get myListings {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      return userId == null ? [] : _books.where((b) => b.ownerId == userId).toList();
    } catch (e) {
      return [];
    }
  }

  ListingsProvider() {
    _init();
  }

  void _init() {
    try {
      // Cancel any existing subscription
      _subscription?.cancel();
      
      _subscription = _service.streamBooks().listen(
        (books) {
          _books = books;
          _loading = false;
          _error = null;
          notifyListeners();
        },
        onError: (e) {
          debugPrint('❌ Error in ListingsProvider stream: $e');
          _error = 'Error loading books. Please check your connection.';
          _loading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint('❌ Error initializing ListingsProvider: $e');
      _error = 'Could not connect to database';
      _loading = false;
      notifyListeners();
    }
  }

  Future<String?> createBook({
    required String title,
    required String author,
    required String condition,
    String? imageUrl,
  }) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return 'Not signed in';

      await _service.createBook({
        'title': title,
        'author': author,
        'condition': condition,
        'imageUrl': imageUrl,
        'ownerId': userId,
        'createdAt': DateTime.now().toIso8601String(),
      });
      return null;
    } catch (e) {
      debugPrint('❌ Error creating book: $e');
      return 'Failed to create book: ${e.toString()}';
    }
  }

  Future<String?> updateBook(String id, {
    String? title,
    String? author,
    String? condition,
    String? imageUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (title != null) updates['title'] = title;
      if (author != null) updates['author'] = author;
      if (condition != null) updates['condition'] = condition;
      if (imageUrl != null) updates['imageUrl'] = imageUrl;
      updates['updatedAt'] = DateTime.now().toIso8601String();

      await _service.updateBook(id, updates);
      return null;
    } catch (e) {
      debugPrint('❌ Error updating book: $e');
      return 'Failed to update book: ${e.toString()}';
    }
  }

  Future<String?> deleteBook(String id) async {
    try {
      await _service.deleteBook(id);
      return null;
    } catch (e) {
      debugPrint('❌ Error deleting book: $e');
      return 'Failed to delete book: ${e.toString()}';
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}