import 'package:flutter/material.dart';

import '../../coeur/theme/theme_gestauto.dart';
import '../widgets/carte_statistique.dart';

class PageAccueil extends StatelessWidget {
  const PageAccueil({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      final largeur = contraintes.maxWidth;

                      final nombreColonnes =
                          largeur >= 800 ? 4 : 2;

                      final largeurCarte =
                          (largeur -
                                  ((nombreColonnes - 1) * 16)) /
                              nombreColonnes;

                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: largeurCarte,
                            child: CarteStatistique(
                              titre: 'Véhicules',
                              valeur: '12',
                              icone: Icons.directions_car_outlined,
                              couleur:
                                  ThemeGestauto.bleuCobalt,
                            ),
                          ),
                          SizedBox(
                            width: largeurCarte,
                            child: CarteStatistique(
                              titre: 'Versements',
                              valeur: '185 000 FCFA',
                              icone:
                                  Icons.account_balance_wallet_outlined,
                              couleur: Colors.green,
                            ),
                          ),
                          SizedBox(
                            width: largeurCarte,
                            child: CarteStatistique(
                              titre: 'Dépenses',
                              valeur: '72 000 FCFA',
                              icone:
                                  Icons.payments_outlined,
                              couleur: Colors.orange,
                            ),
                          ),
                          SizedBox(
                            width: largeurCarte,
                            child: CarteStatistique(
                              titre: 'Alertes',
                              valeur: '3',
                              icone:
                                  Icons.warning_amber_outlined,
                              couleur: Colors.red,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Activité récente',
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
                        _ActiviteRecente(
                          icone:
                              Icons.account_balance_wallet_outlined,
                          titre: 'Versement véhicule',
                          description:
                              'Versement enregistré',
                          montant: '20 000 FCFA',
                          couleur: Colors.green,
                        ),
                        const Divider(
                          height: 1,
                        ),
                        _ActiviteRecente(
                          icone:
                              Icons.build_outlined,
                          titre: 'Entretien véhicule',
                          description:
                              'Entretien préventif',
                          montant: '15 000 FCFA',
                          couleur: ThemeGestauto.bleuCobalt,
                        ),
                        const Divider(
                          height: 1,
                        ),
                        _ActiviteRecente(
                          icone:
                              Icons.receipt_long_outlined,
                          titre: 'Dépense administrative',
                          description:
                              'Renouvellement document',
                          montant: '30 000 FCFA',
                          couleur: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiviteRecente extends StatelessWidget {
  final IconData icone;
  final String titre;
  final String description;
  final String montant;
  final Color couleur;

  const _ActiviteRecente({
    required this.icone,
    required this.titre,
    required this.description,
    required this.montant,
    required this.couleur,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      leading: Container(
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
      ),
      title: Text(
        titre,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(description),
      trailing: Text(
        montant,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}