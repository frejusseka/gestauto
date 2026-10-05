enum StatutVersement {
  conforme,
  infraction,
}

class Versement {
  final String id;
  final String vehiculeId;
  final DateTime date;
  final double montantAttendu;
  final double montantVerse;

  Versement({
    required this.id,
    required this.vehiculeId,
    required this.date,
    required this.montantAttendu,
    required this.montantVerse,
  });

  double get ecart {
    return montantAttendu - montantVerse;
  }

  StatutVersement get statut {
    if (montantVerse >= montantAttendu) {
      return StatutVersement.conforme;
    }

    return StatutVersement.infraction;
  }
}