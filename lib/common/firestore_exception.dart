class FirestoreException implements Exception {
  final String? message;

  FirestoreException({
    required this.message,
  });
}
