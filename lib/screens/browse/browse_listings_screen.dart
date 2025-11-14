import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/listings_provider.dart';
import '../../providers/auth_provider.dart' as app_auth;
import '../listings/post_book_screen.dart';
import '../listings/book_detail_screen.dart';

class BrowseListingsScreen extends StatelessWidget {
  const BrowseListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listingsProvider = Provider.of<ListingsProvider>(context);
    final auth = Provider.of<app_auth.AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF252741),
        elevation: 0,
        title: const Text(
          'Browse Listings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF9D9DB5)),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFF9D9DB5)),
            onPressed: () {
              // TODO: Implement filters
            },
          ),
        ],
      ),
      body: listingsProvider.loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFFD166),
              ),
            )
          : listingsProvider.error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Color(0xFF9D9DB5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          listingsProvider.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF9D9DB5),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Trigger a reload by recreating the provider
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const BrowseListingsScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD166),
                            foregroundColor: const Color(0xFF1A1B2E),
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : listingsProvider.books.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.library_books_outlined,
                            size: 80,
                            color: const Color(0xFF9D9DB5).withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No books available yet',
                            style: TextStyle(
                              color: const Color(0xFF9D9DB5).withOpacity(0.7),
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Be the first to post a book!',
                            style: TextStyle(
                              color: const Color(0xFF9D9DB5).withOpacity(0.5),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      color: const Color(0xFFFFD166),
                      backgroundColor: const Color(0xFF252741),
                      onRefresh: () async {
                        // The provider already auto-refreshes via stream
                        await Future.delayed(const Duration(seconds: 1));
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: listingsProvider.books.length,
                        itemBuilder: (context, index) {
                          final book = listingsProvider.books[index];
                          return _BookCard(
                            book: book,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookDetailScreen(book: book),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PostBookScreen()),
          );
        },
        backgroundColor: const Color(0xFFFFD166),
        foregroundColor: const Color(0xFF1A1B2E),
        icon: const Icon(Icons.add),
        label: const Text(
          'Post Book',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final dynamic book;
  final VoidCallback onTap;

  const _BookCard({
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF252741),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Book Cover
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1B2E),
                borderRadius: BorderRadius.circular(8),
                image: book.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(book.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: book.imageUrl == null
                  ? const Icon(
                      Icons.menu_book_rounded,
                      size: 40,
                      color: Color(0xFF9D9DB5),
                    )
                  : null,
            ),
            const SizedBox(width: 16),

            // Book Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title ?? 'Untitled',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author ?? 'Unknown Author',
                    style: const TextStyle(
                      color: Color(0xFF9D9DB5),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getConditionColor(book.condition).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      book.condition ?? 'Used',
                      style: TextStyle(
                        color: _getConditionColor(book.condition),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF9D9DB5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Color _getConditionColor(String? condition) {
    switch (condition?.toLowerCase()) {
      case 'new':
      case 'like new':
        return const Color(0xFF4CAF50);
      case 'good':
        return const Color(0xFFFFD166);
      case 'fair':
        return const Color(0xFFFF9800);
      case 'poor':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9D9DB5);
    }
  }
}