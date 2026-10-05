class IdentifiantsInvalidesException implements Exception {
  final String message;

  IdentifiantsInvalidesException({
    this.message = 'Email ou mot de passe incorrect.',
  });

  @override
  String toString() {
    return message;
  }
}