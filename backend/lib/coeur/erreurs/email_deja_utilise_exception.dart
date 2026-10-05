class EmailDejaUtiliseException implements Exception {
  final String message;

  EmailDejaUtiliseException({
    this.message = 'Cette adresse email est déjà utilisée.',
  });

  @override
  String toString() {
    return message;
  }
}