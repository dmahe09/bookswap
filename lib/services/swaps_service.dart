import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/swap_offer.dart';

class SwapsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get swapsRef => _db.collection('swap_offers');

  Future<DocumentReference> createOffer(Map<String, dynamic> data) async {
    return await swapsRef.add(data);
  }

  Stream<List<SwapOffer>> streamOffers(String userId) {
    return swapsRef
        .where('toUserId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => SwapOffer.fromMap(d.id, d.data() as Map<String, dynamic>)).toList());
  }

  Future<void> updateOfferStatus(String id, String status) async {
    await swapsRef.doc(id).update({'status': status});
  }

  Future<void> deleteOffer(String id) async {
    await swapsRef.doc(id).delete();
  }
}