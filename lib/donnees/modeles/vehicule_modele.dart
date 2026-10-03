import '../../domaine/entites/vehicule.dart';

class VehiculeModele extends Vehicule {
  VehiculeModele({
    required super.id,
    required super.type,
    required super.marque,
    required super.modele,
    required super.immatriculation,
    required super.annee,
    required super.kilometrage,
    required super.dateAcquisition,
    required super.prixAcquisition,
    required super.statut,
    required super.montantVersementAttendu,
    super.photo,
  });

  factory VehiculeModele.fromJson(Map<String, dynamic> json) {
    return VehiculeModele(
      id: json['id'] as String,
      type: TypeVehicule.values.firstWhere(
        (element) => element.name == json['type'],
      ),
      marque: json['marque'] as String,
      modele: json['modele'] as String,
      immatriculation: json['immatriculation'] as String,
      annee: json['annee'] as int,
      kilometrage: json['kilometrage'] as int,
      dateAcquisition: DateTime.parse(
        json['dateAcquisition'] as String,
      ),
      prixAcquisition: (json['prixAcquisition'] as num).toDouble(),
      statut: StatutVehicule.values.firstWhere(
        (element) => element.name == json['statut'],
      ),
      montantVersementAttendu:
          (json['montantVersementAttendu'] as num).toDouble(),
      photo: json['photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'marque': marque,
      'modele': modele,
      'immatriculation': immatriculation,
      'annee': annee,
      'kilometrage': kilometrage,
      'dateAcquisition': dateAcquisition.toIso8601String(),
      'prixAcquisition': prixAcquisition,
      'statut': statut.name,
      'montantVersementAttendu': montantVersementAttendu,
      'photo': photo,
    };
  }

  Vehicule toEntite() {
    return Vehicule(
      id: id,
      type: type,
      marque: marque,
      modele: modele,
      immatriculation: immatriculation,
      annee: annee,
      kilometrage: kilometrage,
      dateAcquisition: dateAcquisition,
      prixAcquisition: prixAcquisition,
      statut: statut,
      montantVersementAttendu: montantVersementAttendu,
      photo: photo,
    );
  }

  factory VehiculeModele.fromEntite(Vehicule vehicule) {
    return VehiculeModele(
      id: vehicule.id,
      type: vehicule.type,
      marque: vehicule.marque,
      modele: vehicule.modele,
      immatriculation: vehicule.immatriculation,
      annee: vehicule.annee,
      kilometrage: vehicule.kilometrage,
      dateAcquisition: vehicule.dateAcquisition,
      prixAcquisition: vehicule.prixAcquisition,
      statut: vehicule.statut,
      montantVersementAttendu: vehicule.montantVersementAttendu,
      photo: vehicule.photo,
    );
  }
}