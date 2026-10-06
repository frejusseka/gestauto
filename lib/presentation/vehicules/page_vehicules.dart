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

  Future<void> _ouvrirCreation() async {
    final succes = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _FormulaireVehicule(
          creationEnCours:
              widget.controleur.creationEnCours,
          onCreer: (vehicule) {
            return widget.controleur.ajouter(
              vehicule,
            );
          },
        );
      },
    );

    if (!mounted || succes != true) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Véhicule ajouté avec succès.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes véhicules'),
        actions: [
          IconButton(
            onPressed:
                widget.controleur.creationEnCours
                    ? null
                    : _ouvrirCreation,
            tooltip: 'Ajouter un véhicule',
            icon: const Icon(Icons.add),
          ),
        ],
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
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          100,
        ),
        itemCount:
            widget.controleur.vehicules.length + 1,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          if (index == 0) {
            return _construireIndicateurSource();
          }

          final vehicule =
              widget.controleur.vehicules[index - 1];

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

  Widget _construireIndicateurSource() {
    if (!widget.controleur.sourceLocale) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            color: Colors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Mode hors ligne',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Les données affichées proviennent du cache local.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),
              ],
            ),
          ),
        ],
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

  Widget _construireListeVide() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
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
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed:
                  widget.controleur.creationEnCours
                      ? null
                      : _ouvrirCreation,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un véhicule'),
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
    final icone =
        vehicule.type == TypeVehicule.moto
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

class _FormulaireVehicule extends StatefulWidget {
  final bool creationEnCours;
  final Future<bool> Function(Vehicule vehicule) onCreer;

  const _FormulaireVehicule({
    required this.creationEnCours,
    required this.onCreer,
  });

  @override
  State<_FormulaireVehicule> createState() =>
      _FormulaireVehiculeState();
}

class _FormulaireVehiculeState
    extends State<_FormulaireVehicule> {
  final _formulaire = GlobalKey<FormState>();

  TypeVehicule _type = TypeVehicule.voiture;
  StatutVehicule _statut =
      StatutVehicule.disponible;
  DateTime _dateAcquisition = DateTime.now();

  final _controleurMarque =
      TextEditingController();
  final _controleurModele =
      TextEditingController();
  final _controleurImmatriculation =
      TextEditingController();
  final _controleurAnnee =
      TextEditingController();
  final _controleurKilometrage =
      TextEditingController();
  final _controleurPrixAcquisition =
      TextEditingController();
  final _controleurVersementAttendu =
      TextEditingController();

  @override
  void dispose() {
    _controleurMarque.dispose();
    _controleurModele.dispose();
    _controleurImmatriculation.dispose();
    _controleurAnnee.dispose();
    _controleurKilometrage.dispose();
    _controleurPrixAcquisition.dispose();
    _controleurVersementAttendu.dispose();

    super.dispose();
  }

  Future<void> _choisirDateAcquisition() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateAcquisition,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (!mounted || date == null) {
      return;
    }

    setState(() {
      _dateAcquisition = date;
    });
  }

  int? _lireEntier(String valeur) {
    return int.tryParse(valeur.trim());
  }

  double? _lireMontant(String valeur) {
    return double.tryParse(
      valeur.trim().replaceAll(',', '.'),
    );
  }

  String _formaterDate(DateTime date) {
    final jour =
        date.day.toString().padLeft(2, '0');
    final mois =
        date.month.toString().padLeft(2, '0');

    return '$jour/$mois/${date.year}';
  }

  Future<void> _soumettre() async {
    if (!_formulaire.currentState!.validate()) {
      return;
    }

    final annee =
        _lireEntier(_controleurAnnee.text);
    final kilometrage =
        _lireEntier(_controleurKilometrage.text);
    final prixAcquisition =
        _lireMontant(
      _controleurPrixAcquisition.text,
    );
    final montantVersementAttendu =
        _lireMontant(
      _controleurVersementAttendu.text,
    );

    if (annee == null ||
        kilometrage == null ||
        prixAcquisition == null ||
        montantVersementAttendu == null) {
      return;
    }

    final vehicule = Vehicule(
      id: '',
      type: _type,
      marque:
          _controleurMarque.text.trim(),
      modele:
          _controleurModele.text.trim(),
      immatriculation:
          _controleurImmatriculation.text
              .trim()
              .toUpperCase(),
      annee: annee,
      kilometrage: kilometrage,
      dateAcquisition: _dateAcquisition,
      prixAcquisition: prixAcquisition,
      statut: _statut,
      montantVersementAttendu:
          montantVersementAttendu,
    );

    final succes =
        await widget.onCreer(vehicule);

    if (!mounted || !succes) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom:
            MediaQuery.of(context)
                    .viewInsets
                    .bottom +
                24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formulaire,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              Text(
                'Nouveau véhicule',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<TypeVehicule>(
                initialValue: _type,
                decoration:
                    const InputDecoration(
                  labelText: 'Type de véhicule',
                  prefixIcon: Icon(
                    Icons.directions_car_outlined,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: TypeVehicule.voiture,
                    child: Text('Voiture'),
                  ),
                  DropdownMenuItem(
                    value: TypeVehicule.moto,
                    child: Text('Moto'),
                  ),
                ],
                onChanged: widget.creationEnCours
                    ? null
                    : (valeur) {
                        if (valeur == null) {
                          return;
                        }

                        setState(() {
                          _type = valeur;
                        });
                      },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller:
                    _controleurMarque,
                textCapitalization:
                    TextCapitalization.words,
                decoration:
                    const InputDecoration(
                  labelText: 'Marque',
                  prefixIcon: Icon(
                    Icons.branding_watermark_outlined,
                  ),
                ),
                validator: (valeur) {
                  if (valeur == null ||
                      valeur.trim().isEmpty) {
                    return 'Saisissez la marque';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller:
                    _controleurModele,
                textCapitalization:
                    TextCapitalization.words,
                decoration:
                    const InputDecoration(
                  labelText: 'Modèle',
                  prefixIcon: Icon(
                    Icons.directions_car_outlined,
                  ),
                ),
                validator: (valeur) {
                  if (valeur == null ||
                      valeur.trim().isEmpty) {
                    return 'Saisissez le modèle';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller:
                    _controleurImmatriculation,
                textCapitalization:
                    TextCapitalization.characters,
                decoration:
                    const InputDecoration(
                  labelText: 'Immatriculation',
                  prefixIcon: Icon(
                    Icons.confirmation_number_outlined,
                  ),
                ),
                validator: (valeur) {
                  if (valeur == null ||
                      valeur.trim().isEmpty) {
                    return 'Saisissez l’immatriculation';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller:
                    _controleurAnnee,
                keyboardType:
                    TextInputType.number,
                decoration:
                    const InputDecoration(
                  labelText: 'Année',
                  prefixIcon: Icon(
                    Icons.calendar_today_outlined,
                  ),
                ),
                validator: (valeur) {
                  final annee =
                      _lireEntier(valeur ?? '');

                  if (annee == null ||
                      annee < 1950 ||
                      annee > DateTime.now().year) {
                    return 'Saisissez une année valide';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller:
                    _controleurKilometrage,
                keyboardType:
                    TextInputType.number,
                decoration:
                    const InputDecoration(
                  labelText: 'Kilométrage',
                  suffixText: 'km',
                  prefixIcon: Icon(
                    Icons.speed_outlined,
                  ),
                ),
                validator: (valeur) {
                  final kilometrage =
                      _lireEntier(valeur ?? '');

                  if (kilometrage == null ||
                      kilometrage < 0) {
                    return 'Saisissez un kilométrage valide';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: widget.creationEnCours
                    ? null
                    : _choisirDateAcquisition,
                borderRadius:
                    BorderRadius.circular(12),
                child: InputDecorator(
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Date d’acquisition',
                    prefixIcon: Icon(
                      Icons.event_outlined,
                    ),
                  ),
                  child: Text(
                    _formaterDate(
                      _dateAcquisition,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller:
                    _controleurPrixAcquisition,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration:
                    const InputDecoration(
                  labelText:
                      'Prix d’acquisition',
                  suffixText: 'FCFA',
                  prefixIcon: Icon(
                    Icons.payments_outlined,
                  ),
                ),
                validator: (valeur) {
                  final montant =
                      _lireMontant(
                    valeur ?? '',
                  );

                  if (montant == null ||
                      montant < 0) {
                    return 'Saisissez un prix valide';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<StatutVehicule>(
                initialValue: _statut,
                decoration:
                    const InputDecoration(
                  labelText: 'Statut',
                  prefixIcon: Icon(
                    Icons.toggle_on_outlined,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value:
                        StatutVehicule.enService,
                    child: Text('En service'),
                  ),
                  DropdownMenuItem(
                    value:
                        StatutVehicule.disponible,
                    child: Text('Disponible'),
                  ),
                  DropdownMenuItem(
                    value:
                        StatutVehicule.enMaintenance,
                    child: Text(
                      'En maintenance',
                    ),
                  ),
                  DropdownMenuItem(
                    value:
                        StatutVehicule.enPanne,
                    child: Text('En panne'),
                  ),
                  DropdownMenuItem(
                    value:
                        StatutVehicule.horsService,
                    child: Text(
                      'Hors service',
                    ),
                  ),
                ],
                onChanged: widget.creationEnCours
                    ? null
                    : (valeur) {
                        if (valeur == null) {
                          return;
                        }

                        setState(() {
                          _statut = valeur;
                        });
                      },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller:
                    _controleurVersementAttendu,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration:
                    const InputDecoration(
                  labelText:
                      'Versement attendu',
                  suffixText: 'FCFA',
                  prefixIcon: Icon(
                    Icons
                        .account_balance_wallet_outlined,
                  ),
                ),
                validator: (valeur) {
                  final montant =
                      _lireMontant(
                    valeur ?? '',
                  );

                  if (montant == null ||
                      montant < 0) {
                    return 'Saisissez un montant valide';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed:
                    widget.creationEnCours
                        ? null
                        : _soumettre,
                child:
                    widget.creationEnCours
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Enregistrer le véhicule',
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}