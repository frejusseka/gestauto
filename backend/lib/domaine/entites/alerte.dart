enum TypeAlerte {
  document,
  entretien,
}

enum NiveauAlerte {
  information,
  avertissement,
  urgent,
}

class Alerte {
  final TypeAlerte type;
  final String vehiculeId;
  final String titre;
  final String message;
  final NiveauAlerte niveau;

  Alerte({
    required this.type,
    required this.vehiculeId,
    required this.titre,
    required this.message,
    required this.niveau,
  });
}