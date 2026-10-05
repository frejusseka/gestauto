enum GravitePanne {
  faible,
  moyenne,
  grave,
}

class Panne {
  final String id;
  final String vehiculeId;
  final DateTime date;
  final String description;
  final GravitePanne gravite;
  final bool resolue;
  final DateTime? dateResolution;

  Panne({
    required this.id,
    required this.vehiculeId,
    required this.date,
    required this.description,
    required this.gravite,
    required this.resolue,
    this.dateResolution,
  });
}