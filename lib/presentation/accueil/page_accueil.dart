import 'package:flutter/material.dart';

import '../../coeur/theme/controleur_theme.dart';
import '../../coeur/theme/theme_gestauto.dart';
import '../../domaine/entites/tableau_de_bord.dart';
import '../parametres/page_parametres.dart';
import '../widgets/carte_statistique.dart';
import 'controleur_tableau_de_bord.dart';

class PageAccueil extends StatefulWidget {
  final ControleurTableauDeBord controleur;
  final ControleurTheme controleurTheme;
  final Future<void> Function() deconnecter;

  const PageAccueil({
    super.key,
    required this.controleur,
    required this.controleurTheme,
    required this.deconnecter,
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

  void _ouvrirParametres() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PageParametres(
          controleurTheme: widget.controleurTheme,
          deconnecter: widget.deconnecter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tableauDeBord = widget.controleur.tableauDeBord;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GESTAUTO',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: widget.controleur.chargement
                ? null
                : widget.controleur.charger,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Actualiser',
          ),
          IconButton(
            onPressed: _ouvrirParametres,
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Paramètres',
          ),
          const SizedBox(width: 4),
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
      return _construireAucuneDonnee(context);
    }

    return RefreshIndicator(
      onRefresh: widget.controleur.charger,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _construireEntete(context),
                const SizedBox(height: 24),
                _construireCartesStatistiques(
                  context,
                  tableauDeBord,
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
      ),
    );
  }

  Widget _construireEntete(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bonjour 👋',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Voici un aperçu de l’activité de votre flotte.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _construireCartesStatistiques(
    BuildContext context,
    TableauDeBord tableauDeBord,
  ) {
    return LayoutBuilder(
      builder: (context, contraintes) {
        final largeur = contraintes.maxWidth;

        final nombreColonnes = largeur >= 900
            ? 4
            : largeur >= 560
                ? 2
                : 1;

        final espace = 16.0;
        final largeurCarte = nombreColonnes == 1
            ? largeur
            : (largeur -
                    ((nombreColonnes - 1) * espace)) /
                nombreColonnes;

        return Wrap(
          spacing: espace,
          runSpacing: espace,
          children: [
            SizedBox(
              width: largeurCarte,
              child: CarteStatistique(
                titre: 'Véhicules',
                valeur: '${tableauDeBord.nombreVehicules}',
                icone: Icons.directions_car_outlined,
                couleur: ThemeGestauto.bleuCobalt,
              ),
            ),
            SizedBox(
              width: largeurCarte,
              child: CarteStatistique(
                titre: 'Versements reçus',
                valeur: _formaterMontant(
                  tableauDeBord.montantVersementsRecus,
                ),
                icone: Icons.account_balance_wallet_outlined,
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
                icone: Icons.payments_outlined,
                couleur: Colors.orange,
              ),
            ),
            SizedBox(
              width: largeurCarte,
              child: CarteStatistique(
                titre: 'Alertes',
                valeur: '${tableauDeBord.nombreAlertes}',
                icone: Icons.warning_amber_outlined,
                couleur: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _construireResumeFinancier(
    BuildContext context,
    TableauDeBord tableauDeBord,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Résumé financier',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _LigneFinanciere(
                  titre: 'Versements attendus',
                  montant: _formaterMontant(
                    tableauDeBord.montantVersementsAttendus,
                  ),
                ),
                const Divider(height: 24),
                _LigneFinanciere(
                  titre: 'Versements reçus',
                  montant: _formaterMontant(
                    tableauDeBord.montantVersementsRecus,
                  ),
                ),
                const Divider(height: 24),
                _LigneFinanciere(
                  titre: 'Écart des versements',
                  montant: _formaterMontant(
                    tableauDeBord.ecartVersements,
                  ),
                  couleurMontant:
                      tableauDeBord.ecartVersements > 0
                          ? Colors.red
                          : Colors.green,
                ),
                const Divider(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ThemeGestauto.bleuCobalt.withValues(
                      alpha: 0.08,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: _LigneFinanciere(
                    titre: 'Résultat estimé',
                    montant: _formaterMontant(
                      tableauDeBord.resultatEstime,
                    ),
                    important: true,
                    couleurMontant:
                        tableauDeBord.resultatEstime >= 0
                            ? Colors.green
                            : Colors.red,
                  ),
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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activité',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          child: Column(
            children: [
              _LigneActivite(
                icone: Icons.build_outlined,
                couleur: ThemeGestauto.bleuCobalt,
                titre: 'Entretiens à venir',
                valeur:
                    '${tableauDeBord.nombreEntretiensAVenir}',
              ),
              const Divider(height: 1),
              _LigneActivite(
                icone: Icons.warning_amber_outlined,
                couleur: Colors.red,
                titre: 'Alertes',
                valeur: '${tableauDeBord.nombreAlertes}',
              ),
              const Divider(height: 1),
              _LigneActivite(
                icone: Icons.car_repair_outlined,
                couleur: Colors.orange,
                titre: 'Pannes',
                valeur: '${tableauDeBord.nombrePannes}',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _construireErreur(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 450,
          ),
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withValues(
                        alpha: 0.10,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cloud_off_outlined,
                      size: 36,
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Impossible de charger les données',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.controleur.messageErreur!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: widget.controleur.chargement
                        ? null
                        : widget.controleur.charger,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _construireAucuneDonnee(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.dashboard_outlined,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune donnée disponible.',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Les informations de votre tableau de bord '
              'apparaîtront ici.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LigneActivite extends StatelessWidget {
  final IconData icone;
  final Color couleur;
  final String titre;
  final String valeur;

  const _LigneActivite({
    required this.icone,
    required this.couleur,
    required this.titre,
    required this.valeur,
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
      trailing: Container(
        constraints: const BoxConstraints(
          minWidth: 36,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: couleur.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          valeur,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: couleur,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _LigneFinanciere extends StatelessWidget {
  final String titre;
  final String montant;
  final bool important;
  final Color? couleurMontant;

  const _LigneFinanciere({
    required this.titre,
    required this.montant,
    this.important = false,
    this.couleurMontant,
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
                  important ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            montant,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: couleurMontant,
              fontWeight: FontWeight.w800,
              fontSize: important ? 18 : null,
            ),
          ),
        ),
      ],
    );
  }
}