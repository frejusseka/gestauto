import 'package:flutter/material.dart';

import '../../domaine/entites/panne.dart';
import '../../domaine/entites/vehicule.dart';
import '../vehicules/controleur_vehicules.dart';
import 'controleur_pannes.dart';

String _texteGravite(GravitePanne gravite) {
  switch (gravite) {
    case GravitePanne.faible:
      return 'Faible';
    case GravitePanne.moyenne:
      return 'Moyenne';
    case GravitePanne.grave:
      return 'Grave';
  }
}

IconData _iconeGravite(GravitePanne gravite) {
  switch (gravite) {
    case GravitePanne.faible:
      return Icons.info_outline;
    case GravitePanne.moyenne:
      return Icons.warning_amber_outlined;
    case GravitePanne.grave:
      return Icons.error_outline;
  }
}

class PagePannes extends StatefulWidget {
  final ControleurPannes controleur;
  final ControleurVehicules controleurVehicules;

  const PagePannes({
    super.key,
    required this.controleur,
    required this.controleurVehicules,
  });

  @override
  State<PagePannes> createState() => _PagePannesState();
}

class _PagePannesState extends State<PagePannes> {
  @override
  void initState() {
    super.initState();

    widget.controleur.chargerPannes();
    widget.controleurVehicules.charger();
  }

  String _nomVehicule(String vehiculeId) {
    for (final vehicule in widget.controleurVehicules.vehicules) {
      if (vehicule.id == vehiculeId) {
        return '${vehicule.marque} ${vehicule.modele}';
      }
    }

    return 'Véhicule inconnu';
  }

  String _formaterDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> _ouvrirCreation() async {
    await widget.controleurVehicules.charger();

    if (!mounted) {
      return;
    }

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

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _FormulairePanne(
          controleur: widget.controleur,
          vehicules: widget.controleurVehicules.vehicules,
        );
      },
    );
  }

  Future<void> _ouvrirModification(Panne panne) async {
    await widget.controleurVehicules.charger();

    if (!mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _FormulairePanne(
          controleur: widget.controleur,
          vehicules: widget.controleurVehicules.vehicules,
          panne: panne,
        );
      },
    );
  }

  Future<void> _confirmerSuppression(Panne panne) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Supprimer la panne ?',
          ),
          content: const Text(
            'Cette action est définitive.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (confirmation != true || !mounted) {
      return;
    }

    final succes = await widget.controleur.supprimer(
      panneId: panne.id,
    );

    if (!mounted) {
      return;
    }

    if (!succes) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.controleur.erreur ??
                'Impossible de supprimer la panne.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.controleur,
        widget.controleurVehicules,
      ]),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Pannes'),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _ouvrirCreation,
            icon: const Icon(Icons.add),
            label: const Text(
              'Nouvelle panne',
            ),
          ),
          body: _construireContenu(),
        );
      },
    );
  }

  Widget _construireContenu() {
    if (widget.controleur.chargement &&
        widget.controleur.pannes.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (widget.controleur.erreur != null &&
        widget.controleur.pannes.isEmpty) {
      return _EtatErreur(
        message: widget.controleur.erreur!,
        onReessayer: widget.controleur.chargerPannes,
      );
    }

    if (widget.controleur.pannes.isEmpty) {
      return _EtatVide(
        onAjouter: _ouvrirCreation,
      );
    }

    return RefreshIndicator(
      onRefresh: widget.controleur.chargerPannes,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          100,
        ),
        itemCount: widget.controleur.pannes.length,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          final panne = widget.controleur.pannes[index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: panne.resolue
                              ? Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                              : Theme.of(context)
                                  .colorScheme
                                  .errorContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          panne.resolue
                              ? Icons.check_circle_outline
                              : Icons.build_circle_outlined,
                          color: panne.resolue
                              ? Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer
                              : Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              _nomVehicule(panne.vehiculeId),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formaterDate(panne.date),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall,
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (valeur) {
                          if (valeur == 'modifier') {
                            _ouvrirModification(panne);
                          }

                          if (valeur == 'supprimer') {
                            _confirmerSuppression(panne);
                          }
                        },
                        itemBuilder: (context) {
                          return const [
                            PopupMenuItem(
                              value: 'modifier',
                              child: Text('Modifier'),
                            ),
                            PopupMenuItem(
                              value: 'supprimer',
                              child: Text('Supprimer'),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    panne.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        _iconeGravite(panne.gravite),
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Gravité : ${_texteGravite(panne.gravite)}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        panne.resolue
                            ? Icons.check_circle_outline
                            : Icons.pending_outlined,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        panne.resolue
                            ? 'Résolue'
                            : 'Non résolue',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  if (panne.dateResolution != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Résolution : '
                      '${_formaterDate(panne.dateResolution!)}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FormulairePanne extends StatefulWidget {
  final ControleurPannes controleur;
  final List<Vehicule> vehicules;
  final Panne? panne;

  const _FormulairePanne({
    required this.controleur,
    required this.vehicules,
    this.panne,
  });

  @override
  State<_FormulairePanne> createState() => _FormulairePanneState();
}

class _FormulairePanneState extends State<_FormulairePanne> {
  final _formulaireKey = GlobalKey<FormState>();

  final _descriptionControleur = TextEditingController();

  String? _vehiculeIdSelectionne;
  GravitePanne _graviteSelectionnee = GravitePanne.faible;

  DateTime _dateSelectionnee = DateTime.now();

  bool _resolue = false;
  DateTime? _dateResolution;

  bool get _modeModification => widget.panne != null;

  @override
  void initState() {
    super.initState();

    final panne = widget.panne;

    if (panne != null) {
      _vehiculeIdSelectionne = panne.vehiculeId;
      _graviteSelectionnee = panne.gravite;
      _dateSelectionnee = panne.date;
      _descriptionControleur.text = panne.description;
      _resolue = panne.resolue;
      _dateResolution = panne.dateResolution;
    } else if (widget.vehicules.isNotEmpty) {
      _vehiculeIdSelectionne = widget.vehicules.first.id;
    }
  }

  @override
  void dispose() {
    _descriptionControleur.dispose();
    super.dispose();
  }

  String _formaterDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> _selectionnerDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateSelectionnee,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        _dateSelectionnee = date;
      });
    }
  }

  Future<void> _selectionnerDateResolution() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateResolution ?? DateTime.now(),
      firstDate: _dateSelectionnee,
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        _dateResolution = date;
        _resolue = true;
      });
    }
  }

  Future<void> _enregistrer() async {
    if (!_formulaireKey.currentState!.validate()) {
      return;
    }

    if (_vehiculeIdSelectionne == null) {
      return;
    }

    if (_resolue && _dateResolution == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sélectionnez la date de résolution.',
          ),
        ),
      );
      return;
    }

    if (!_resolue) {
      _dateResolution = null;
    }

    final panne = Panne(
      id: widget.panne?.id ?? '',
      vehiculeId: _vehiculeIdSelectionne!,
      date: _dateSelectionnee,
      description: _descriptionControleur.text.trim(),
      gravite: _graviteSelectionnee,
      resolue: _resolue,
      dateResolution: _dateResolution,
    );

    final bool succes;

    if (_modeModification) {
      succes = await widget.controleur.modifier(
        panne: panne,
      );
    } else {
      succes = await widget.controleur.creer(
        panne: panne,
      );
    }

    if (!mounted) {
      return;
    }

    if (succes) {
      Navigator.of(context).pop();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.controleur.erreur ??
              'Impossible d’enregistrer la panne.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom:
              MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFF7F9FC),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Form(
          key: _formulaireKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _modeModification
                            ? 'Modifier la panne'
                            : 'Nouvelle panne',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  initialValue: _vehiculeIdSelectionne,
                  decoration: const InputDecoration(
                    labelText: 'Véhicule',
                    prefixIcon: Icon(
                      Icons.directions_car_outlined,
                    ),
                  ),
                  items: widget.vehicules
                      .map(
                        (vehicule) => DropdownMenuItem(
                          value: vehicule.id,
                          child: Text(
                            '${vehicule.marque} '
                            '${vehicule.modele} — '
                            '${vehicule.immatriculation}',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (valeur) {
                    setState(() {
                      _vehiculeIdSelectionne = valeur;
                    });
                  },
                  validator: (valeur) {
                    if (valeur == null) {
                      return 'Sélectionnez un véhicule.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _selectionnerDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date de la panne',
                      prefixIcon: Icon(
                        Icons.calendar_today_outlined,
                      ),
                    ),
                    child: Text(
                      _formaterDate(_dateSelectionnee),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<GravitePanne>(
                  initialValue: _graviteSelectionnee,
                  decoration: const InputDecoration(
                    labelText: 'Gravité',
                    prefixIcon: Icon(
                      Icons.warning_amber_outlined,
                    ),
                  ),
                  items: GravitePanne.values
                      .map(
                        (gravite) => DropdownMenuItem(
                          value: gravite,
                          child: Text(
                            _texteGravite(gravite),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (valeur) {
                    if (valeur != null) {
                      setState(() {
                        _graviteSelectionnee = valeur;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionControleur,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Ex. Problème de freinage',
                    prefixIcon: Icon(
                      Icons.notes_outlined,
                    ),
                    alignLabelWithHint: true,
                  ),
                  validator: (valeur) {
                    if (valeur == null ||
                        valeur.trim().isEmpty) {
                      return 'Décrivez la panne.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Panne résolue',
                  ),
                  subtitle: Text(
                    _resolue
                        ? 'La panne est résolue.'
                        : 'La panne est encore en cours.',
                  ),
                  value: _resolue,
                  onChanged: (valeur) {
                    setState(() {
                      _resolue = valeur;

                      if (!valeur) {
                        _dateResolution = null;
                      }
                    });
                  },
                ),
                if (_resolue) ...[
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectionnerDateResolution,
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date de résolution',
                        prefixIcon: Icon(
                          Icons.event_available_outlined,
                        ),
                      ),
                      child: Text(
                        _dateResolution == null
                            ? 'Sélectionner une date'
                            : _formaterDate(
                                _dateResolution!,
                              ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: widget.controleur,
                  builder: (context, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed:
                            widget.controleur.chargement
                                ? null
                                : _enregistrer,
                        icon: widget.controleur.chargement
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.save_outlined,
                              ),
                        label: Text(
                          widget.controleur.chargement
                              ? 'Enregistrement...'
                              : _modeModification
                                  ? 'Enregistrer les modifications'
                                  : 'Enregistrer la panne',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EtatVide extends StatelessWidget {
  final VoidCallback onAjouter;

  const _EtatVide({
    required this.onAjouter,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.build_circle_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune panne',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enregistrez une panne pour suivre '
              'les problèmes de votre flotte.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onAjouter,
              icon: const Icon(Icons.add),
              label: const Text(
                'Ajouter une panne',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EtatErreur extends StatelessWidget {
  final String message;
  final VoidCallback onReessayer;

  const _EtatErreur({
    required this.message,
    required this.onReessayer,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onReessayer,
              icon: const Icon(
                Icons.refresh,
              ),
              label: const Text(
                'Réessayer',
              ),
            ),
          ],
        ),
      ),
    );
  }
}