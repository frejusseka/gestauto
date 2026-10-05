import '../../domaine/entites/categorie_depense.dart';

class CategorieDepenseModele
    extends CategorieDepense {
  CategorieDepenseModele({
    required super.id,
    required super.nom,
  });

  factory CategorieDepenseModele.fromJson(
    Map<String, dynamic> json,
  ) {
    return CategorieDepenseModele(
      id: json['id'] as String,
      nom: json['nom'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
    };
  }

  Map<String, dynamic> toJsonPourCreation() {
    return {
      'nom': nom,
    };
  }

  CategorieDepense toEntite() {
    return CategorieDepense(
      id: id,
      nom: nom,
    );
  }

  factory CategorieDepenseModele.fromEntite(
    CategorieDepense categorie,
  ) {
    return CategorieDepenseModele(
      id: categorie.id,
      nom: categorie.nom,
    );
  }
}