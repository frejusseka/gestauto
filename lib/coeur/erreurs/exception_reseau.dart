class ExceptionReseau implements Exception {
  final String message;
  final int? codeStatut;

  ExceptionReseau({
    required this.message,
    this.codeStatut,
  });

  @override
  String toString() {
    return message;
  }
}