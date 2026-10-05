import 'package:flutter/material.dart';

import '../../domaine/entites/categorie_depense.dart';
import '../../domaine/entites/vehicule.dart';
import '../vehicules/controleur_vehicules.dart';
import 'controleur_categories_depenses.dart';
import 'controleur_depenses.dart';

class PageDepenses extends StatefulWidget {
  final ControleurDepenses controleur;
  final ControleurCategoriesDepenses
      controleurCategories;
  final ControleurVehicules controleurVehicules;

  const PageDepenses({
    super.key,
    required this.controleur,
    required this.controleurCategories,
    required this.controleurVehicules,
  });

  @override
  State<PageDepenses> createState() => _PageDepensesState();
}

class _PageDepensesState extends State<PageDepenses> {
  @override
  void initState() {
    super.initState();

    widget.controleur.charger();
    widget.controleurCategories.charger();
    widget.controleurVehicules.charger();
  }

  String _nomVehicule(String vehiculeId) {
    for (final vehicule
        in widget.controleurVehicules.vehicules) {
      if (vehicule.id == vehiculeId) {
        return '${vehicule.marque} ${vehicule.modele}';
      }
    }

    return 'Véhicule inconnu';
  }

  String _nomCategorie(String categorieId) {
    for (final categorie
        in widget.controleurCategories.categories) {
      if (categorie.id == categorieId) {
        return categorie.nom;
      }
    }

    return 'Catégorie inconnue';
  }

  String _formaterMontant(double montant) {
    return '${montant.toStringAsFixed(0)} FCFA';
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

    await widget.controleurCategories.charger();

    if (!mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _FormulaireDepense(
          controleur: widget.controleur,
          controleurCategories:
              widget.controleurCategories,
          vehicules:
              widget.controleurVehicules.vehicules,
        );
      },
    );
  }

  Future<void> _ouvrirCreationCategorie() async {
    final resultat =
        await showDialog<CategorieDepense>(
      context: context,
      builder: (context) {
        return _DialogueNouvelleCategorie(
          controleur:
              widget.controleurCategories,
        );
      },
    );

    if (resultat != null && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.controleur,
        widget.controleurCategories,
        widget.controleurVehicules,
      ]),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dépenses'),
            actions: [
              IconButton(
                tooltip: 'Nouvelle catégorie',
                onPressed:
                    _ouvrirCreationCategorie,
                icon: const Icon(
                  Icons.category_outlined,
                ),
              ),
            ],
          ),
          floatingActionButton:
              FloatingActionButton.extended(
            onPressed: _ouvrirCreation,
            icon: const Icon(Icons.add),
            label: const Text(
              'Nouvelle dépense',
            ),
          ),
          body: _construireContenu(),
        );
      },
    );
  }

  Widget _construireContenu() {
    if (widget.controleur.chargement &&
        widget.controleur.depenses.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (widget.controleur.messageErreur != null &&
        widget.controleur.depenses.isEmpty) {
      return _EtatErreur(
        message: widget.controleur.messageErreur!,
        onReessayer:
            widget.controleur.charger,
      );
    }

    if (widget.controleur.depenses.isEmpty) {
      return _EtatVide(
        onAjouter: _ouvrirCreation,
      );
    }

    return RefreshIndicator(
      onRefresh: widget.controleur.charger,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          100,
        ),
        itemCount:
            widget.controleur.depenses.length,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          final depense =
              widget.controleur.depenses[index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.receipt_long_outlined,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nomCategorie(
                            depense.categorieId,
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _nomVehicule(
                            depense.vehiculeId,
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _formaterDate(
                            depense.date,
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall,
                        ),
                        if (depense.description !=
                                null &&
                            depense.description!
                                .trim()
                                .isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            depense.description!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _formaterMontant(
                      depense.montant,
                    ),
                    textAlign: TextAlign.end,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(
                          fontWeight:
                              FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FormulaireDepense extends StatefulWidget {
  final ControleurDepenses controleur;
  final ControleurCategoriesDepenses
      controleurCategories;
  final List<Vehicule> vehicules;

  const _FormulaireDepense({
    required this.controleur,
    required this.controleurCategories,
    required this.vehicules,
  });

  @override
  State<_FormulaireDepense> createState() =>
      _FormulaireDepenseState();
}

class _FormulaireDepenseState
    extends State<_FormulaireDepense> {
  final _formulaireKey =
      GlobalKey<FormState>();

  final _montantControleur =
      TextEditingController();

  final _descriptionControleur =
      TextEditingController();

  String? _vehiculeIdSelectionne;
  String? _categorieIdSelectionnee;
  DateTime _dateSelectionnee =
      DateTime.now();

  @override
  void initState() {
    super.initState();

    if (widget.vehicules.isNotEmpty) {
      _vehiculeIdSelectionne =
          widget.vehicules.first.id;
    }

    if (widget.controleurCategories
        .categories.isNotEmpty) {
      _categorieIdSelectionnee =
          widget.controleurCategories
              .categories.first.id;
    }
  }

  @override
  void dispose() {
    _montantControleur.dispose();
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

  Future<void> _creerCategorie() async {
    final resultat =
        await showDialog<CategorieDepense>(
      context: context,
      builder: (context) {
        return _DialogueNouvelleCategorie(
          controleur:
              widget.controleurCategories,
        );
      },
    );

    if (resultat != null && mounted) {
      setState(() {
        _categorieIdSelectionnee =
            resultat.id;
      });
    }
  }

  Future<void> _enregistrer() async {
    if (!_formulaireKey.currentState!
        .validate()) {
      return;
    }

    final montant = double.tryParse(
      _montantControleur.text
          .trim()
          .replaceAll(',', '.'),
    );

    if (montant == null || montant <= 0) {
      return;
    }

    final succes =
        await widget.controleur.creer(
      vehiculeId:
          _vehiculeIdSelectionne!,
      categorieId:
          _categorieIdSelectionnee!,
      date: _dateSelectionnee,
      montant: montant,
      description:
          _descriptionControleur.text
                  .trim()
                  .isEmpty
              ? null
              : _descriptionControleur.text
                  .trim(),
    );

    if (!mounted) {
      return;
    }

    if (succes) {
      Navigator.of(context).pop();
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          widget.controleur.messageErreur ??
              'Impossible de créer la dépense.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        widget.controleurCategories.categories;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom:
              MediaQuery.of(context)
                      .viewInsets
                      .bottom +
                  20,
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Nouvelle dépense',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop();
                      },
                      icon: const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  initialValue:
                      _vehiculeIdSelectionne,
                  decoration:
                      const InputDecoration(
                    labelText: 'Véhicule',
                    prefixIcon: Icon(
                      Icons
                          .directions_car_outlined,
                    ),
                  ),
                  items: widget.vehicules
                      .map(
                        (vehicule) =>
                            DropdownMenuItem(
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
                      _vehiculeIdSelectionne =
                          valeur;
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
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child:
                          DropdownButtonFormField<
                              String>(
                        initialValue:
                            _categorieIdSelectionnee,
                        decoration:
                            const InputDecoration(
                          labelText: 'Catégorie',
                          prefixIcon: Icon(
                            Icons
                                .category_outlined,
                          ),
                        ),
                        items: categories
                            .map(
                              (categorie) =>
                                  DropdownMenuItem(
                                value:
                                    categorie.id,
                                child: Text(
                                  categorie.nom,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged:
                            categories.isEmpty
                                ? null
                                : (valeur) {
                                    setState(() {
                                      _categorieIdSelectionnee =
                                          valeur;
                                    });
                                  },
                        validator: (valeur) {
                          if (valeur == null) {
                            return 'Sélectionnez une catégorie.';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip:
                          'Créer une catégorie',
                      onPressed:
                          _creerCategorie,
                      icon: const Icon(
                        Icons
                            .add_circle_outline,
                      ),
                    ),
                  ],
                ),
                if (categories.isEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Aucune catégorie. '
                    'Créez-en une avec le bouton +.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  ),
                ],
                const SizedBox(height: 16),
                InkWell(
                  onTap: _selectionnerDate,
                  borderRadius:
                      BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration:
                        const InputDecoration(
                      labelText: 'Date',
                      prefixIcon: Icon(
                        Icons
                            .calendar_today_outlined,
                      ),
                    ),
                    child: Text(
                      _formaterDate(
                        _dateSelectionnee,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller:
                      _montantControleur,
                  keyboardType:
                      const TextInputType
                          .numberWithOptions(
                    decimal: true,
                  ),
                  decoration:
                      const InputDecoration(
                    labelText: 'Montant',
                    hintText: 'Ex. 15000',
                    suffixText: 'FCFA',
                    prefixIcon: Icon(
                      Icons.payments_outlined,
                    ),
                  ),
                  validator: (valeur) {
                    if (valeur == null ||
                        valeur.trim().isEmpty) {
                      return 'Saisissez un montant.';
                    }

                    final montant =
                        double.tryParse(
                      valeur
                          .trim()
                          .replaceAll(',', '.'),
                    );

                    if (montant == null ||
                        montant <= 0) {
                      return 'Saisissez un montant valide.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller:
                      _descriptionControleur,
                  maxLines: 3,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Description (facultative)',
                    hintText:
                        'Ex. Changement de plaquettes',
                    prefixIcon: Icon(
                      Icons.notes_outlined,
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: widget.controleur,
                  builder: (context, child) {
                    return FilledButton.icon(
                      onPressed:
                          widget.controleur
                                  .creationEnCours
                              ? null
                              : _enregistrer,
                      icon: widget.controleur
                              .creationEnCours
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
                        widget.controleur
                                .creationEnCours
                            ? 'Enregistrement...'
                            : 'Enregistrer la dépense',
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

class _DialogueNouvelleCategorie
    extends StatefulWidget {
  final ControleurCategoriesDepenses
      controleur;

  const _DialogueNouvelleCategorie({
    required this.controleur,
  });

  @override
  State<_DialogueNouvelleCategorie>
      createState() =>
          _DialogueNouvelleCategorieState();
}

class _DialogueNouvelleCategorieState
    extends State<_DialogueNouvelleCategorie> {
  final _formulaireKey =
      GlobalKey<FormState>();

  final _nomControleur =
      TextEditingController();

  @override
  void dispose() {
    _nomControleur.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!_formulaireKey.currentState!
        .validate()) {
      return;
    }

    final nom = _nomControleur.text.trim();

    final nombreAvant =
        widget.controleur.categories.length;

    final succes =
        await widget.controleur.creer(
      nom: nom,
    );

    if (!mounted) {
      return;
    }

    if (succes &&
        widget.controleur.categories.length >
            nombreAvant) {
      final categorie =
          widget.controleur.categories.last;

      Navigator.of(context).pop(categorie);
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          widget.controleur.messageErreur ??
              'Impossible de créer la catégorie.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Nouvelle catégorie',
      ),
      content: Form(
        key: _formulaireKey,
        child: TextFormField(
          controller: _nomControleur,
          autofocus: true,
          decoration:
              const InputDecoration(
            labelText: 'Nom',
            hintText: 'Ex. Carburant',
            prefixIcon: Icon(
              Icons.category_outlined,
            ),
          ),
          validator: (valeur) {
            if (valeur == null ||
                valeur.trim().isEmpty) {
              return 'Saisissez un nom.';
            }

            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
        AnimatedBuilder(
          animation: widget.controleur,
          builder: (context, child) {
            return FilledButton(
              onPressed:
                  widget.controleur
                          .creationEnCours
                      ? null
                      : _enregistrer,
              child: widget.controleur
                      .creationEnCours
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Créer'),
            );
          },
        ),
      ],
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
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Theme.of(context)
                  .colorScheme
                  .primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune dépense',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                    fontWeight:
                        FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enregistrez votre première dépense '
              'pour commencer le suivi.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onAjouter,
              icon: const Icon(Icons.add),
              label: const Text(
                'Ajouter une dépense',
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
          mainAxisAlignment:
              MainAxisAlignment.center,
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