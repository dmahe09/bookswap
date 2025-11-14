class Book {
  final String id;
  final String title;
  final String author;
  final String condition; // New, Like New, Good, Used
  final String? imageUrl;
  final String ownerId;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.condition,
    this.imageUrl,
    required this.ownerId,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'author': author,
        'condition': condition,
        'imageUrl': imageUrl,
        'ownerId': ownerId,
      };

  factory Book.fromMap(String id, Map<String, dynamic> map) => Book(
        id: id,
        title: map['title'] as String? ?? '',
        author: map['author'] as String? ?? '',
        condition: map['condition'] as String? ?? 'Used',
        imageUrl: map['imageUrl'] as String?,
        ownerId: map['ownerId'] as String? ?? '',
      );
}
