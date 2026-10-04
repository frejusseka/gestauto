import '../../domaine/entites/versement.dart';

class VersementModele extends Versement {
  VersementModele({
    required super.id,
    required super.vehiculeId,
    required super.date,
    required super.montantAttendu,
    required super.montantVerse,
  });

  factory VersementModele.fromJson(
    Map<String, dynamic> json,
  ) {
    return VersementModele(
      id: json['id'] as String,
      vehiculeId: json['vehiculeId'] as String,
      date: DateTime.parse(
        json['date'] as String,
      ),
      montantAttendu:
          (json['montantAttendu'] as num).toDouble(),
      montantVerse:
          (json['montantVerse'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehiculeId': vehiculeId,
      'date': date.toIso8601String(),
      'montantAttendu': montantAttendu,
      'montantVerse': montantVerse,
    };
  }

  Versement toEntite() {
    return Versement(
      id: id,
      vehiculeId: vehiculeId,
      date: date,
      montantAttendu: montantAttendu,
      montantVerse: montantVerse,
    );
  }
}