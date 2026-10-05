enum TypeVehicule {
  voiture,
  moto,
}

enum StatutVehicule {
  enService,
  disponible,
  enMaintenance,
  enPanne,
  horsService,
}

class Vehicule {
  final String id;
  final String utilisateurId;
  final TypeVehicule type;
  final String marque;
  final String modele;
  final String immatriculation;
  final int annee;
  final int kilometrage;
  final DateTime dateAcquisition;
  final double prixAcquisition;
  final StatutVehicule statut;
  final double montantVersementAttendu;
  final String? photo;

  Vehicule({
    required this.id,
    required this.utilisateurId,
    required this.type,
    required this.marque,
    required this.modele,
    required this.immatriculation,
    required this.annee,
    required this.kilometrage,
    required this.dateAcquisition,
    required this.prixAcquisition,
    required this.statut,
    required this.montantVersementAttendu,
    this.photo,
  });
}