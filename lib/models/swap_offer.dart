class SwapOffer {
  final String id;
  final String bookId;
  final String fromUserId;
  final String toUserId;
  final String status; // Pending, Accepted, Rejected
  final DateTime createdAt;
  final String? message;

  SwapOffer({
    required this.id,
    required this.bookId,
    required this.fromUserId,
    required this.toUserId,
    required this.status,
    required this.createdAt,
    this.message,
  });

  Map<String, dynamic> toMap() => {
        'bookId': bookId,
        'fromUserId': fromUserId,
        'toUserId': toUserId,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'message': message,
      };

  factory SwapOffer.fromMap(String id, Map<String, dynamic> map) => SwapOffer(
        id: id,
        bookId: map['bookId'] as String? ?? '',
        fromUserId: map['fromUserId'] as String? ?? '',
        toUserId: map['toUserId'] as String? ?? '',
        status: map['status'] as String? ?? 'Pending',
        createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
        message: map['message'] as String?,
      );
}