import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/swap_offer.dart';
import '../services/swaps_service.dart';

class SwapsProvider extends ChangeNotifier {
  final SwapsService _service = SwapsService();
  List<SwapOffer> _offers = [];
  bool _loading = true;
  String? _error;

  List<SwapOffer> get offers => _offers;
  bool get loading => _loading;
  String? get error => _error;

  List<SwapOffer> get receivedOffers {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      return userId == null ? [] : _offers.where((o) => o.toUserId == userId).toList();
    } catch (e) {
      return [];
    }
  }

  List<SwapOffer> get sentOffers {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      return userId == null ? [] : _offers.where((o) => o.fromUserId == userId).toList();
    } catch (e) {
      return [];
    }
  }

  SwapsProvider() {
    _init();
  }

  void _init() {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _error = 'Not signed in';
        _loading = false;
        notifyListeners();
        return;
      }

      _service.streamOffers(userId).listen(
        (offers) {
          _offers = offers;
          _loading = false;
          _error = null;
          notifyListeners();
        },
        onError: (e) {
          _error = 'Error loading offers: $e';
          _loading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _error = 'Firebase not configured: $e';
      _loading = false;
      notifyListeners();
    }
  }

  Future<String?> createOffer({
    required String bookId,
    required String toUserId,
    String? message,
  }) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return 'Not signed in';

      await _service.createOffer({
        'bookId': bookId,
        'fromUserId': userId,
        'toUserId': toUserId,
        'status': 'Pending',
        'createdAt': DateTime.now().toIso8601String(),
        if (message != null) 'message': message,
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateOfferStatus(String id, String status) async {
    try {
      await _service.updateOfferStatus(id, status);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteOffer(String id) async {
    try {
      await _service.deleteOffer(id);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}