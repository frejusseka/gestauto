import '../entites/alerte.dart';
import '../entites/document.dart';
import '../entites/entretien.dart';
import '../entites/type_document.dart';
import '../entites/vehicule.dart';

abstract class ServiceAlertes {
  List<Alerte> genererAlertes({
    required List<Vehicule> vehicules,
    required List<Document> documents,
    required List<TypeDocument> typesDocuments,
    required List<Entretien> entretiens,
    required DateTime dateActuelle,
  });
}