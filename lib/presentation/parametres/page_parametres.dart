import 'package:flutter/material.dart';

import '../../coeur/theme/controleur_theme.dart';

class PageParametres extends StatelessWidget {
  final ControleurTheme controleurTheme;
  final Future<void> Function() deconnecter;

  const PageParametres({
    super.key,
    required this.controleurTheme,
    required this.deconnecter,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controleurTheme,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Paramètres'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Apparence',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Card(
                child: SwitchListTile(
                  secondary: Icon(
                    controleurTheme.modeSombre
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                  title: const Text('Mode sombre'),
                  subtitle: Text(
                    controleurTheme.modeSombre
                        ? 'Le thème sombre est activé.'
                        : 'Le thème clair est activé.',
                  ),
                  value: controleurTheme.modeSombre,
                  onChanged: controleurTheme.changerMode,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Compte',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.logout,
                  ),
                  title: const Text('Déconnexion'),
                  subtitle: const Text(
                    'Fermer la session actuelle.',
                  ),
                  onTap: () async {
                    final confirmer =
                        await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            'Déconnexion',
                          ),
                          content: const Text(
                            'Voulez-vous vraiment vous déconnecter ?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(false);
                              },
                              child: const Text(
                                'Annuler',
                              ),
                            ),
                            FilledButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(true);
                              },
                              child: const Text(
                                'Déconnexion',
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmer != true) {
                      return;
                    }

                    await deconnecter();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}