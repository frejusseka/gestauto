import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestauto/donnees/sources/distantes/source_vehicule_distante_api.dart';
import 'package:gestauto/domaine/entites/vehicule.dart';

void main() {
  test(
    'obtenirTous doit convertir la réponse API en véhicules',
    () async {
      final dio = Dio();

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'vehicules': [
                    {
                      'id': 'vehicule-1',
                      'type': 'voiture',
                      'marque': 'Toyota',
                      'modele': 'Yaris',
                      'immatriculation': '1234 AB 01',
                      'annee': 2022,
                      'kilometrage': 85000,
                      'dateAcquisition':
                          '2024-05-10T00:00:00.000',
                      'prixAcquisition': 8500000,
                      'statut': 'enService',
                      'montantVersementAttendu': 20000,
                      'photo': null,
                    },
                  ],
                },
              ),
            );
          },
        ),
      );

      final source = SourceVehiculeDistanteApi(
        dio: dio,
      );

      final vehicules = await source.obtenirTous();

      expect(vehicules.length, 1);
      expect(vehicules.first, isA<Vehicule>());
      expect(vehicules.first.id, 'vehicule-1');
      expect(vehicules.first.marque, 'Toyota');
      expect(vehicules.first.modele, 'Yaris');
      expect(
        vehicules.first.type,
        TypeVehicule.voiture,
      );
      expect(
        vehicules.first.kilometrage,
        85000,
      );
      expect(
        vehicules.first.statut,
        StatutVehicule.enService,
      );
    },
  );

  test(
    'obtenirParId doit convertir la réponse API en véhicule',
    () async {
      final dio = Dio();

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'vehicule': {
                    'id': 'vehicule-2',
                    'type': 'moto',
                    'marque': 'Yamaha',
                    'modele': 'XMAX',
                    'immatriculation': '5678 CD 01',
                    'annee': 2023,
                    'kilometrage': 45000,
                    'dateAcquisition':
                        '2025-02-15T00:00:00.000',
                    'prixAcquisition': 2500000,
                    'statut': 'disponible',
                    'montantVersementAttendu': 20000,
                    'photo': 'xmax.jpg',
                  },
                },
              ),
            );
          },
        ),
      );

      final source = SourceVehiculeDistanteApi(
        dio: dio,
      );

      final vehicule =
          await source.obtenirParId('vehicule-2');

      expect(vehicule, isNotNull);
      expect(vehicule!.id, 'vehicule-2');
      expect(
        vehicule.type,
        TypeVehicule.moto,
      );
      expect(
        vehicule.marque,
        'Yamaha',
      );
      expect(
        vehicule.modele,
        'XMAX',
      );
      expect(
        vehicule.immatriculation,
        '5678 CD 01',
      );
      expect(
        vehicule.kilometrage,
        45000,
      );
      expect(
        vehicule.statut,
        StatutVehicule.disponible,
      );
      expect(
        vehicule.photo,
        'xmax.jpg',
      );
    },
  );

  test(
    'ajouter doit envoyer le véhicule à l API',
    () async {
      final dio = Dio();

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(
              options.method,
              'POST',
            );
            expect(
              options.path,
              '/protegee/vehicules',
            );

            final donnees =
                options.data as Map<String, dynamic>;

            expect(
              donnees.containsKey('id'),
              false,
            );
            expect(
              donnees['type'],
              'voiture',
            );
            expect(
              donnees['marque'],
              'Renault',
            );
            expect(
              donnees['modele'],
              'Clio',
            );
            expect(
              donnees['immatriculation'],
              '9999 EF 01',
            );
            expect(
              donnees['annee'],
              2024,
            );
            expect(
              donnees['kilometrage'],
              30000,
            );
            expect(
              donnees['prixAcquisition'],
              7000000,
            );
            expect(
              donnees['statut'],
              'enService',
            );
            expect(
              donnees['montantVersementAttendu'],
              20000,
            );

            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 201,
                data: {
                  'message':
                      'Véhicule créé avec succès.',
                  'vehicule': {
                    'id': 'vehicule-3',
                    'type': 'voiture',
                    'marque': 'Renault',
                    'modele': 'Clio',
                    'immatriculation': '9999 EF 01',
                    'annee': 2024,
                    'kilometrage': 30000,
                    'dateAcquisition':
                        '2025-01-10T00:00:00.000',
                    'prixAcquisition': 7000000,
                    'statut': 'enService',
                    'montantVersementAttendu': 20000,
                    'photo': null,
                  },
                },
              ),
            );
          },
        ),
      );

      final source = SourceVehiculeDistanteApi(
        dio: dio,
      );

      final vehicule = Vehicule(
        id: '',
        type: TypeVehicule.voiture,
        marque: 'Renault',
        modele: 'Clio',
        immatriculation: '9999 EF 01',
        annee: 2024,
        kilometrage: 30000,
        dateAcquisition: DateTime(
          2025,
          1,
          10,
        ),
        prixAcquisition: 7000000,
        statut: StatutVehicule.enService,
        montantVersementAttendu: 20000,
      );

      final vehiculeCree =
          await source.ajouter(vehicule);

      expect(
        vehiculeCree.id,
        'vehicule-3',
      );
      expect(
        vehiculeCree.marque,
        'Renault',
      );
      expect(
        vehiculeCree.modele,
        'Clio',
      );
    },
  );

  test(
    'modifier doit envoyer le véhicule modifié à l API',
    () async {
      final dio = Dio();

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(
              options.method,
              'PUT',
            );
            expect(
              options.path,
              '/protegee/vehicules/vehicule-4',
            );

            final donnees =
                options.data as Map<String, dynamic>;

            expect(
              donnees['id'],
              'vehicule-4',
            );
            expect(
              donnees['type'],
              'moto',
            );
            expect(
              donnees['marque'],
              'Yamaha',
            );
            expect(
              donnees['modele'],
              'XMAX',
            );
            expect(
              donnees['kilometrage'],
              50000,
            );
            expect(
              donnees['statut'],
              'enMaintenance',
            );
            expect(
              donnees['montantVersementAttendu'],
              20000,
            );

            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: donnees,
              ),
            );
          },
        ),
      );

      final source = SourceVehiculeDistanteApi(
        dio: dio,
      );

      final vehicule = Vehicule(
        id: 'vehicule-4',
        type: TypeVehicule.moto,
        marque: 'Yamaha',
        modele: 'XMAX',
        immatriculation: '5678 CD 01',
        annee: 2023,
        kilometrage: 50000,
        prixAcquisition: 2500000,
        dateAcquisition: DateTime(
          2025,
          2,
          15,
        ),
        statut: StatutVehicule.enMaintenance,
        montantVersementAttendu: 20000,
      );

      await source.modifier(vehicule);
    },
  );

  test(
    'supprimer doit envoyer une requête DELETE à l API',
    () async {
      final dio = Dio();

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(
              options.method,
              'DELETE',
            );
            expect(
              options.path,
              '/protegee/vehicules/vehicule-5',
            );

            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 204,
              ),
            );
          },
        ),
      );

      final source = SourceVehiculeDistanteApi(
        dio: dio,
      );

      await source.supprimer('vehicule-5');
    },
  );
}