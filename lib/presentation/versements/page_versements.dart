import 'package:flutter/material.dart';

import '../../coeur/theme/theme_gestauto.dart';
import '../../domaine/entites/vehicule.dart';
import '../../domaine/entites/versement.dart';
import '../vehicules/controleur_vehicules.dart';
import 'controleur_versements.dart';

class PageVersements extends StatefulWidget {
  final ControleurVersements controleur;
  final ControleurVehicules controleurVehicules;

  const PageVersements({
    super.key,
    required this.controleur,
    required this.controleurVehicules,
  });

  @override
  State<PageVersements> createState() =>
      _PageVersementsState();
}

class _PageVersementsState
    extends State<PageVersements> {
  @override
  void initState() {
    super.initState();

    widget.controleur.addListener(_actualiser);
    widget.controleurVehicules.addListener(_actualiser);

    widget.controleur.charger();
    widget.controleurVehicules.charger();
  }

  @override
  void dispose() {
    widget.controleur.removeListener(_actualiser);
    widget.controleurVehicules.removeListener(_actualiser);

    widget.controleur.dispose();
    widget.controleurVehicules.dispose();

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

  String _formaterDate(DateTime date) {
    final jour =
        date.day.toString().padLeft(2, '0');
    final mois =
        date.month.toString().padLeft(2, '0');

    return '$jour/$mois/${date.year}';
  }

  Vehicule? _trouverVehicule(
    String vehiculeId,
  ) {
    for (final vehicule
        in widget.controleurVehicules.vehicules) {
      if (vehicule.id == vehiculeId) {
        return vehicule;
      }
    }

    return null;
  }

  String _nomVehicule(String vehiculeId) {
    final vehicule = _trouverVehicule(vehiculeId);

    if (vehicule == null) {
      return 'Véhicule inconnu';
    }

    return '${vehicule.marque} ${vehicule.modele}';
  }

  Future<void> _ouvrirCreation() async {
    if (widget.controleurVehicules.vehicules.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ajoutez d’abord un véhicule.',
          ),
        ),
      );

      return;
    }

    final succes = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _FormulaireVersement(
          vehicules:
              widget.controleurVehicules.vehicules,
          creationEnCours:
              widget.controleur.creationEnCours,
          onCreer: ({
            required vehiculeId,
            required date,
            required montantAttendu,
            required montantVerse,
          }) {
            return widget.controleur.creer(
              vehiculeId: vehiculeId,
              date: date,
              montantAttendu: montantAttendu,
              montantVerse: montantVerse,
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
          'Versement enregistré avec succès.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final versements =
        widget.controleur.versements;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Versements'),
      ),
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed:
            widget.controleur.creationEnCours
                ? null
                : _ouvrirCreation,
        icon: const Icon(Icons.add),
        label: const Text('Nouveau'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await widget.controleur.charger();
          await widget.controleurVehicules.charger();
        },
        child: _construireContenu(
          context,
          versements,
        ),
      ),
    );
  }

  Widget _construireContenu(
    BuildContext context,
    List<Versement> versements,
  ) {
    if (widget.controleur.chargement &&
        versements.isEmpty) {
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 500,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      );
    }

    if (widget.controleur.messageErreur != null &&
        versements.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 500,
            child: _construireErreur(context),
          ),
        ],
      );
    }

    if (versements.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 500,
            child: _construireVide(context),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        100,
      ),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: versements.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final versement = versements[index];

        return _CarteVersement(
          versement: versement,
          nomVehicule:
              _nomVehicule(versement.vehiculeId),
          dateFormatee:
              _formaterDate(versement.date),
          formaterMontant: _formaterMontant,
        );
      },
    );
  }

  Widget _construireVide(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.payments_outlined,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun versement',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enregistrez votre premier versement.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _construireErreur(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
    );
  }
}

class _CarteVersement extends StatelessWidget {
  final Versement versement;
  final String nomVehicule;
  final String dateFormatee;
  final String Function(double) formaterMontant;

  const _CarteVersement({
    required this.versement,
    required this.nomVehicule,
    required this.dateFormatee,
    required this.formaterMontant,
  });

  @override
  Widget build(BuildContext context) {
    final conforme =
        versement.statut ==
            StatutVersement.conforme;

    final couleur =
        conforme ? Colors.green : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: ThemeGestauto.bleuClair,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.payments_outlined,
                    color: ThemeGestauto.bleuCobalt,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        nomVehicule,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(dateFormatee),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: couleur.withValues(
                      alpha: 0.12,
                    ),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    conforme
                        ? 'Conforme'
                        : 'Infraction',
                    style: TextStyle(
                      color: couleur,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _LigneMontant(
              titre: 'Montant attendu',
              montant: formaterMontant(
                versement.montantAttendu,
              ),
            ),
            const SizedBox(height: 8),
            _LigneMontant(
              titre: 'Montant versé',
              montant: formaterMontant(
                versement.montantVerse,
              ),
            ),
            const Divider(height: 24),
            _LigneMontant(
              titre: 'Écart',
              montant: formaterMontant(
                versement.ecart,
              ),
              important: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _LigneMontant extends StatelessWidget {
  final String titre;
  final String montant;
  final bool important;

  const _LigneMontant({
    required this.titre,
    required this.montant,
    this.important = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(titre),
        ),
        Text(
          montant,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: important ? 17 : null,
          ),
        ),
      ],
    );
  }
}

class _FormulaireVersement extends StatefulWidget {
  final List<Vehicule> vehicules;
  final bool creationEnCours;

  final Future<bool> Function({
    required String vehiculeId,
    required DateTime date,
    required double montantAttendu,
    required double montantVerse,
  }) onCreer;

  const _FormulaireVersement({
    required this.vehicules,
    required this.creationEnCours,
    required this.onCreer,
  });

  @override
  State<_FormulaireVersement> createState() =>
      _FormulaireVersementState();
}

class _FormulaireVersementState
    extends State<_FormulaireVersement> {
  final _formulaire =
      GlobalKey<FormState>();

  String? _vehiculeId;
  DateTime _date = DateTime.now();

  final _controleurMontantAttendu =
      TextEditingController();

  final _controleurMontantVerse =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _vehiculeId = widget.vehicules.first.id;

    final montant =
        widget.vehicules.first.montantVersementAttendu;

    if (montant > 0) {
      _controleurMontantAttendu.text =
          montant.round().toString();
    }
  }

  @override
  void dispose() {
    _controleurMontantAttendu.dispose();
    _controleurMontantVerse.dispose();

    super.dispose();
  }

  Future<void> _choisirDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (!mounted) {
      return;
    }

    if (date != null) {
      setState(() {
        _date = date;
      });
    }
  }

  double? _lireMontant(
    String valeur,
  ) {
    return double.tryParse(
      valeur.trim().replaceAll(',', '.'),
    );
  }

  Future<void> _soumettre() async {
    if (!_formulaire.currentState!.validate()) {
      return;
    }

    final montantAttendu = _lireMontant(
      _controleurMontantAttendu.text,
    );

    final montantVerse = _lireMontant(
      _controleurMontantVerse.text,
    );

    if (montantAttendu == null ||
        montantVerse == null ||
        _vehiculeId == null) {
      return;
    }

    final succes = await widget.onCreer(
      vehiculeId: _vehiculeId!,
      date: _date,
      montantAttendu: montantAttendu,
      montantVerse: montantVerse,
    );

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
                'Nouveau versement',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                initialValue: _vehiculeId,
                decoration:
                    const InputDecoration(
                  labelText: 'Véhicule',
                  prefixIcon: Icon(
                    Icons.directions_car_outlined,
                  ),
                ),
                items: widget.vehicules.map(
                  (vehicule) {
                    return DropdownMenuItem<String>(
                      value: vehicule.id,
                      child: Text(
                        '${vehicule.marque} '
                        '${vehicule.modele} — '
                        '${vehicule.immatriculation}',
                      ),
                    );
                  },
                ).toList(),
                onChanged: widget.creationEnCours
                    ? null
                    : (valeur) {
                        if (valeur == null) {
                          return;
                        }

                        setState(() {
                          _vehiculeId = valeur;
                        });

                        final vehicule =
                            widget.vehicules
                                .firstWhere(
                          (element) =>
                              element.id == valeur,
                        );

                        if (_controleurMontantAttendu
                            .text
                            .isEmpty &&
                            vehicule
                                .montantVersementAttendu >
                                0) {
                          _controleurMontantAttendu
                              .text =
                              vehicule
                                  .montantVersementAttendu
                                  .round()
                                  .toString();
                        }
                      },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: widget.creationEnCours
                    ? null
                    : _choisirDate,
                borderRadius:
                    BorderRadius.circular(12),
                child: InputDecorator(
                  decoration:
                      const InputDecoration(
                    labelText: 'Date',
                    prefixIcon: Icon(
                      Icons.calendar_today_outlined,
                    ),
                  ),
                  child: Text(
                    '${_date.day.toString().padLeft(2, '0')}/'
                    '${_date.month.toString().padLeft(2, '0')}/'
                    '${_date.year}',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller:
                    _controleurMontantAttendu,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration:
                    const InputDecoration(
                  labelText: 'Montant attendu',
                  suffixText: 'FCFA',
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
              const SizedBox(height: 16),
              TextFormField(
                controller:
                    _controleurMontantVerse,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration:
                    const InputDecoration(
                  labelText: 'Montant versé',
                  suffixText: 'FCFA',
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
                            'Enregistrer le versement',
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}