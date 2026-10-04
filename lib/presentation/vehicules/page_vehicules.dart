import 'package:flutter/material.dart';

import '../../coeur/theme/theme_gestauto.dart';
import '../../domaine/entites/vehicule.dart';
import 'controleur_vehicules.dart';
import 'page_vehicule.dart';

class PageVehicules extends StatefulWidget {
  final ControleurVehicules controleur;

  const PageVehicules({
    super.key,
    required this.controleur,
  });

  @override
  State<PageVehicules> createState() => _PageVehiculesState();
}

class _PageVehiculesState extends State<PageVehicules> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes véhicules'),
      ),
      body: SafeArea(
        child: _construireContenu(),
      ),
    );
  }

  Widget _construireContenu() {
    if (widget.controleur.chargement &&
        widget.controleur.vehicules.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (widget.controleur.messageErreur != null &&
        widget.controleur.vehicules.isEmpty) {
      return _construireErreur();
    }

    if (widget.controleur.vehicules.isEmpty) {
      return _construireListeVide();
    }

    return RefreshIndicator(
      onRefresh: widget.controleur.charger,
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: widget.controleur.vehicules.length,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          final vehicule =
              widget.controleur.vehicules[index];

          return _CarteVehicule(
            vehicule: vehicule,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PageVehicule(
                    vehicule: vehicule,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _construireErreur() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 450,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off_outlined,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                widget.controleur.messageErreur!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
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
    );
  }

  Widget _construireListeVide() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: 72,
              color: ThemeGestauto.bleuCobalt,
            ),
            const SizedBox(height: 20),
            Text(
              'Aucun véhicule',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Vous n’avez encore enregistré aucun véhicule.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CarteVehicule extends StatelessWidget {
  final Vehicule vehicule;
  final VoidCallback onTap;

  const _CarteVehicule({
    required this.vehicule,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _construireIcone(),
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
                          .titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vehicule.immatriculation,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _BadgeStatut(
                          statut: vehicule.statut,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${vehicule.kilometrage} km',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construireIcone() {
    final icone = vehicule.type == TypeVehicule.moto
        ? Icons.two_wheeler
        : Icons.directions_car;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: ThemeGestauto.bleuClair,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icone,
        color: ThemeGestauto.bleuCobalt,
        size: 30,
      ),
    );
  }
}

class _BadgeStatut extends StatelessWidget {
  final StatutVehicule statut;

  const _BadgeStatut({
    required this.statut,
  });

  String get _libelle {
    switch (statut) {
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

  Color get _couleur {
    switch (statut) {
      case StatutVehicule.enService:
        return Colors.green;
      case StatutVehicule.disponible:
        return ThemeGestauto.bleuCobalt;
      case StatutVehicule.enMaintenance:
        return Colors.orange;
      case StatutVehicule.enPanne:
        return Colors.red;
      case StatutVehicule.horsService:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _couleur.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _libelle,
        style: TextStyle(
          color: _couleur,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}