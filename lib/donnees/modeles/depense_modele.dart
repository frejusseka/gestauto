import '../../domaine/entites/depense.dart';

class DepenseModele extends Depense {
  DepenseModele({
    required super.id,
    required super.vehiculeId,
    required super.categorieId,
    required super.date,
    required super.montant,
    super.description,
  });

  factory DepenseModele.fromJson(
    Map<String, dynamic> json,
  ) {
    return DepenseModele(
      id: json['id'] as String,
      vehiculeId: json['vehiculeId'] as String,
      categorieId: json['categorieId'] as String,
      date: DateTime.parse(
        json['date'] as String,
      ),
      montant:
          (json['montant'] as num).toDouble(),
      description:
          json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehiculeId': vehiculeId,
      'categorieId': categorieId,
      'date': date.toIso8601String(),
      'montant': montant,
      'description': description,
    };
  }

  Map<String, dynamic> toJsonPourCreation() {
    return {
      'vehiculeId': vehiculeId,
      'categorieId': categorieId,
      'date': date.toIso8601String(),
      'montant': montant,
      'description': description,
    };
  }

  Depense toEntite() {
    return Depense(
      id: id,
      vehiculeId: vehiculeId,
      categorieId: categorieId,
      date: date,
      montant: montant,
      description: description,
    );
  }

  factory DepenseModele.fromEntite(
    Depense depense,
  ) {
    return DepenseModele(
      id: depense.id,
      vehiculeId: depense.vehiculeId,
      categorieId: depense.categorieId,
      date: depense.date,
      montant: depense.montant,
      description: depense.description,
    );
  }
}