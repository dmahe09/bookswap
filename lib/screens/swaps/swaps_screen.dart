import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/swap_offer.dart';
import '../../providers/swaps_provider.dart';

class SwapsScreen extends StatelessWidget {
  const SwapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Swaps'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Received'),
              Tab(text: 'Sent'),
            ],
          ),
        ),
        body: Consumer<SwapsProvider>(
          builder: (context, provider, _) {
            if (provider.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    provider.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }

            return TabBarView(
              children: [
                _SwapsList(offers: provider.receivedOffers, isReceived: true),
                _SwapsList(offers: provider.sentOffers, isReceived: false),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SwapsList extends StatelessWidget {
  final List<SwapOffer> offers;
  final bool isReceived;

  const _SwapsList({required this.offers, required this.isReceived});

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return Center(
        child: Text(
          isReceived
              ? 'No swap requests received'
              : 'No swap requests sent',
        ),
      );
    }

    return ListView.builder(
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text('Book ID: ${offer.bookId}'), // TODO: Show book details
            subtitle: Text(
              '${offer.status} • ${_formatDate(offer.createdAt)}',
              style: TextStyle(
                color: _getStatusColor(offer.status),
              ),
            ),
            trailing: isReceived && offer.status == 'Pending'
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => _updateStatus(context, offer.id, 'Accepted'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _updateStatus(context, offer.id, 'Rejected'),
                      ),
                    ],
                  )
                : null,
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Accepted':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _updateStatus(BuildContext context, String offerId, String status) async {
    final provider = Provider.of<SwapsProvider>(context, listen: false);
    final error = await provider.updateOfferStatus(offerId, status);
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }
}