import 'package:flutter/material.dart';

import '../../coeur/theme/theme_gestauto.dart';
import '../../domaine/entites/vehicule.dart';

class PageVehicule extends StatelessWidget {
  final Vehicule vehicule;

  const PageVehicule({
    super.key,
    required this.vehicule,
  });

  String _formaterMontant(double montant) {
    final montantArrondi = montant.round();
    final texte = montantArrondi.toString();

    final tampon = StringBuffer();
    var compteur = 0;

    for (var i = texte.length - 1; i >= 0; i--) {
      tampon.write(texte[i]);
      compteur++;

      if (compteur == 3 && i != 0) {
        tampon.write(' ');
        compteur = 0;
      }
    }

    return '${tampon.toString().split('').reversed.join()} FCFA';
  }

  String _formaterDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _libelleType() {
    switch (vehicule.type) {
      case TypeVehicule.voiture:
        return 'Voiture';
      case TypeVehicule.moto:
        return 'Moto';
    }
  }

  String _libelleStatut() {
    switch (vehicule.statut) {
      case StatutVehicule.enService:
        return 'En service';
      case StatutVehicule.disponible:
        return 'Disponible';
      case StatutVehicule.enMaintenance:
        return 'En maintenance';
      case StatutVehicule.enPanne:
        return 'En panne';
      case StatutVehicule.horsService:
        return 'Hors service';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiche véhicule'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _construireEntete(context),
                const SizedBox(height: 24),
                _construireSection(
                  context,
                  titre: 'Informations générales',
                  enfants: [
                    _LigneInformation(
                      icone: Icons.category_outlined,
                      titre: 'Type',
                      valeur: _libelleType(),
                    ),
                    _LigneInformation(
                      icone: Icons.directions_car_outlined,
                      titre: 'Marque',
                      valeur: vehicule.marque,
                    ),
                    _LigneInformation(
                      icone: Icons.drive_file_rename_outline,
                      titre: 'Modèle',
                      valeur: vehicule.modele,
                    ),
                    _LigneInformation(
                      icone: Icons.confirmation_number_outlined,
                      titre: 'Immatriculation',
                      valeur: vehicule.immatriculation,
                    ),
                    _LigneInformation(
                      icone: Icons.calendar_today_outlined,
                      titre: 'Année',
                      valeur: '${vehicule.annee}',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _construireSection(
                  context,
                  titre: 'Exploitation',
                  enfants: [
                    _LigneInformation(
                      icone: Icons.speed_outlined,
                      titre: 'Kilométrage',
                      valeur:
                          '${vehicule.kilometrage} km',
                    ),
                    _LigneInformation(
                      icone: Icons.info_outline,
                      titre: 'Statut',
                      valeur: _libelleStatut(),
                    ),
                    _LigneInformation(
                      icone: Icons.payments_outlined,
                      titre: 'Versement attendu',
                      valeur: _formaterMontant(
                        vehicule
                            .montantVersementAttendu,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _construireSection(
                  context,
                  titre: 'Acquisition',
                  enfants: [
                    _LigneInformation(
                      icone: Icons.event_outlined,
                      titre: 'Date d’acquisition',
                      valeur: _formaterDate(
                        vehicule.dateAcquisition,
                      ),
                    ),
                    _LigneInformation(
                      icone: Icons.account_balance_wallet_outlined,
                      titre: 'Prix d’acquisition',
                      valeur: _formaterMontant(
                        vehicule.prixAcquisition,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _construireEntete(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: ThemeGestauto.bleuClair,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                vehicule.type == TypeVehicule.moto
                    ? Icons.two_wheeler
                    : Icons.directions_car,
                color: ThemeGestauto.bleuCobalt,
                size: 38,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehicule.marque} ${vehicule.modele}',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    vehicule.immatriculation,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _libelleStatut(),
                    style: TextStyle(
                      color: ThemeGestauto.bleuCobalt,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construireSection(
    BuildContext context, {
    required String titre,
    required List<Widget> enfants,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titre,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              for (var i = 0; i < enfants.length; i++) ...[
                enfants[i],
                if (i < enfants.length - 1)
                  const Divider(height: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _LigneInformation extends StatelessWidget {
  final IconData icone;
  final String titre;
  final String valeur;

  const _LigneInformation({
    required this.icone,
    required this.titre,
    required this.valeur,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      child: Row(
        children: [
          Icon(
            icone,
            color: ThemeGestauto.bleuCobalt,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              titre,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              valeur,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}