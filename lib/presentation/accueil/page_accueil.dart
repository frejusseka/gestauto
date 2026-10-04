import 'package:flutter/material.dart';

import '../../coeur/theme/theme_gestauto.dart';
import '../../domaine/entites/tableau_de_bord.dart';
import '../widgets/carte_statistique.dart';
import 'controleur_tableau_de_bord.dart';

class PageAccueil extends StatefulWidget {
  final ControleurTableauDeBord controleur;

  const PageAccueil({
    super.key,
    required this.controleur,
  });

  @override
  State<PageAccueil> createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {
  @override
  void initState() {
    super.initState();

    widget.controleur.addListener(_actualiser);

    widget.controleur.charger();
  }

  @override
  void dispose() {
    widget.controleur.removeListener(_actualiser);
    widget.controleur.dispose();

    super.dispose();
  }

  void _actualiser() {
    if (mounted) {
      setState(() {});
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final tableauDeBord =
        widget.controleur.tableauDeBord;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GESTAUTO'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_outlined,
            ),
            tooltip: 'Notifications',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _construireContenu(
          context,
          tableauDeBord,
        ),
      ),
    );
  }

  Widget _construireContenu(
    BuildContext context,
    TableauDeBord? tableauDeBord,
  ) {
    if (widget.controleur.chargement &&
        tableauDeBord == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (widget.controleur.messageErreur != null &&
        tableauDeBord == null) {
      return _construireErreur(context);
    }

    if (tableauDeBord == null) {
      return const Center(
        child: Text(
          'Aucune donnée disponible.',
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1100,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Bonjour 👋',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Voici un aperçu de votre activité.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge,
              ),
              const SizedBox(height: 28),
              LayoutBuilder(
                builder: (context, contraintes) {
                  final largeur =
                      contraintes.maxWidth;

                  final nombreColonnes =
                      largeur >= 800 ? 4 : 2;

                  final largeurCarte =
                      (largeur -
                              ((nombreColonnes - 1) *
                                  16)) /
                          nombreColonnes;

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(
                        width: largeurCarte,
                        child: CarteStatistique(
                          titre: 'Véhicules',
                          valeur:
                              '${tableauDeBord.nombreVehicules}',
                          icone: Icons
                              .directions_car_outlined,
                          couleur:
                              ThemeGestauto.bleuCobalt,
                        ),
                      ),
                      SizedBox(
                        width: largeurCarte,
                        child: CarteStatistique(
                          titre: 'Versements reçus',
                          valeur: _formaterMontant(
                            tableauDeBord
                                .montantVersementsRecus,
                          ),
                          icone: Icons
                              .account_balance_wallet_outlined,
                          couleur: Colors.green,
                        ),
                      ),
                      SizedBox(
                        width: largeurCarte,
                        child: CarteStatistique(
                          titre: 'Dépenses',
                          valeur: _formaterMontant(
                            tableauDeBord.montantDepenses,
                          ),
                          icone:
                              Icons.payments_outlined,
                          couleur: Colors.orange,
                        ),
                      ),
                      SizedBox(
                        width: largeurCarte,
                        child: CarteStatistique(
                          titre: 'Alertes',
                          valeur:
                              '${tableauDeBord.nombreAlertes}',
                          icone: Icons
                              .warning_amber_outlined,
                          couleur: Colors.red,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
              _construireResumeFinancier(
                context,
                tableauDeBord,
              ),
              const SizedBox(height: 32),
              _construireActivite(
                context,
                tableauDeBord,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construireResumeFinancier(
    BuildContext context,
    TableauDeBord tableauDeBord,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Résumé financier',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _LigneFinanciere(
                  titre: 'Versements attendus',
                  montant: _formaterMontant(
                    tableauDeBord
                        .montantVersementsAttendus,
                  ),
                ),
                const Divider(height: 24),
                _LigneFinanciere(
                  titre: 'Versements reçus',
                  montant: _formaterMontant(
                    tableauDeBord
                        .montantVersementsRecus,
                  ),
                ),
                const Divider(height: 24),
                _LigneFinanciere(
                  titre: 'Écart des versements',
                  montant: _formaterMontant(
                    tableauDeBord.ecartVersements,
                  ),
                ),
                const Divider(height: 24),
                _LigneFinanciere(
                  titre: 'Résultat estimé',
                  montant: _formaterMontant(
                    tableauDeBord.resultatEstime,
                  ),
                  important: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _construireActivite(
    BuildContext context,
    TableauDeBord tableauDeBord,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Activité',
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
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                leading: _iconeActivite(
                  Icons.build_outlined,
                  ThemeGestauto.bleuCobalt,
                ),
                title: const Text(
                  'Entretiens à venir',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Text(
                  '${tableauDeBord.nombreEntretiensAVenir}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                leading: _iconeActivite(
                  Icons.warning_amber_outlined,
                  Colors.red,
                ),
                title: const Text(
                  'Alertes',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Text(
                  '${tableauDeBord.nombreAlertes}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                leading: _iconeActivite(
                  Icons.car_repair_outlined,
                  Colors.orange,
                ),
                title: const Text(
                  'Pannes',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Text(
                  '${tableauDeBord.nombrePannes}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _construireErreur(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 450,
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off_outlined,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                widget.controleur.messageErreur!,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed:
                    widget.controleur.chargement
                        ? null
                        : widget.controleur.charger,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconeActivite(
    IconData icone,
    Color couleur,
  ) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icone,
        color: couleur,
      ),
    );
  }
}

class _LigneFinanciere extends StatelessWidget {
  final String titre;
  final String montant;
  final bool important;

  const _LigneFinanciere({
    required this.titre,
    required this.montant,
    this.important = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            titre,
            style: TextStyle(
              fontWeight:
                  important ? FontWeight.bold : null,
            ),
          ),
        ),
        Text(
          montant,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: important ? 18 : null,
          ),
        ),
      ],
    );
  }
}