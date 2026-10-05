import '../../domaine/entites/panne.dart';

class PanneModele extends Panne {
  PanneModele({
    required super.id,
    required super.vehiculeId,
    required super.date,
    required super.description,
    required super.gravite,
    required super.resolue,
    super.dateResolution,
  });

  factory PanneModele.depuisJson(
    Map<String, dynamic> json,
  ) {
    return PanneModele(
      id: json['id'] as String,
      vehiculeId: json['vehiculeId'] as String,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
      gravite: GravitePanne.values.byName(
        json['gravite'] as String,
      ),
      resolue: json['resolue'] as bool,
      dateResolution: json['dateResolution'] != null
          ? DateTime.parse(
              json['dateResolution'] as String,
            )
          : null,
    );
  }

  Map<String, dynamic> versJson() {
    return {
      'id': id,
      'vehiculeId': vehiculeId,
      'date': date.toIso8601String(),
      'description': description,
      'gravite': gravite.name,
      'resolue': resolue,
      'dateResolution':
          dateResolution?.toIso8601String(),
    };
  }
}