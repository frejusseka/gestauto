import 'package:flutter/material.dart';

import '../../domaine/cas_utilisation/inscrire_utilisateur.dart';

class PageInscription extends StatefulWidget {
  final InscrireUtilisateur inscrireUtilisateur;

  const PageInscription({
    super.key,
    required this.inscrireUtilisateur,
  });

  @override
  State<PageInscription> createState() => _PageInscriptionState();
}

class _PageInscriptionState extends State<PageInscription> {
  final _formulaire = GlobalKey<FormState>();

  final _controleurNom = TextEditingController();
  final _controleurEmail = TextEditingController();
  final _controleurMotDePasse = TextEditingController();
  final _controleurConfirmation = TextEditingController();

  bool _motDePasseVisible = false;
  bool _confirmationVisible = false;
  bool _inscriptionEnCours = false;

  @override
  void dispose() {
    _controleurNom.dispose();
    _controleurEmail.dispose();
    _controleurMotDePasse.dispose();
    _controleurConfirmation.dispose();

    super.dispose();
  }

  Future<void> _soumettre() async {
    if (!_formulaire.currentState!.validate()) {
      return;
    }

    setState(() {
      _inscriptionEnCours = true;
    });

    try {
      await widget.inscrireUtilisateur.executer(
        nom: _controleurNom.text.trim(),
        email: _controleurEmail.text.trim(),
        motDePasse: _controleurMotDePasse.text,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Compte créé avec succès. Vous pouvez maintenant vous connecter.',
          ),
        ),
      );

      Navigator.of(context).pop();
    } catch (exception) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
            'Inscription impossible : $exception',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _inscriptionEnCours = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Créer un compte',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 440,
              ),
              child: Form(
                key: _formulaire,
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _construireEntete(context),
                        const SizedBox(height: 28),
                        TextFormField(
                          controller: _controleurNom,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [
                            AutofillHints.name,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Nom',
                            hintText: 'Votre nom',
                            prefixIcon: Icon(
                              Icons.person_outline,
                            ),
                          ),
                          validator: (valeur) {
                            if (valeur == null ||
                                valeur.trim().isEmpty) {
                              return 'Veuillez saisir votre nom';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _controleurEmail,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [
                            AutofillHints.email,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Adresse e-mail',
                            hintText: 'exemple@email.com',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                            ),
                          ),
                          validator: (valeur) {
                            if (valeur == null ||
                                valeur.trim().isEmpty) {
                              return 'Veuillez saisir votre adresse e-mail';
                            }

                            if (!valeur.contains('@')) {
                              return 'Veuillez saisir une adresse e-mail valide';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _controleurMotDePasse,
                          obscureText: !_motDePasseVisible,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [
                            AutofillHints.newPassword,
                          ],
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            helperText: 'Minimum 8 caractères',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _motDePasseVisible =
                                      !_motDePasseVisible;
                                });
                              },
                              tooltip: _motDePasseVisible
                                  ? 'Masquer le mot de passe'
                                  : 'Afficher le mot de passe',
                              icon: Icon(
                                _motDePasseVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          validator: (valeur) {
                            if (valeur == null || valeur.isEmpty) {
                              return 'Veuillez saisir votre mot de passe';
                            }

                            if (valeur.length < 8) {
                              return 'Le mot de passe doit contenir au moins 8 caractères';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _controleurConfirmation,
                          obscureText: !_confirmationVisible,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [
                            AutofillHints.newPassword,
                          ],
                          onFieldSubmitted: (_) {
                            if (!_inscriptionEnCours) {
                              _soumettre();
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Confirmer le mot de passe',
                            prefixIcon: const Icon(
                              Icons.lock_reset_outlined,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _confirmationVisible =
                                      !_confirmationVisible;
                                });
                              },
                              tooltip: _confirmationVisible
                                  ? 'Masquer la confirmation'
                                  : 'Afficher la confirmation',
                              icon: Icon(
                                _confirmationVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          validator: (valeur) {
                            if (valeur == null || valeur.isEmpty) {
                              return 'Veuillez confirmer votre mot de passe';
                            }

                            if (valeur !=
                                _controleurMotDePasse.text) {
                              return 'Les mots de passe ne correspondent pas';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 50,
                          child: FilledButton.icon(
                            onPressed:
                                _inscriptionEnCours ? null : _soumettre,
                            icon: _inscriptionEnCours
                                ? const SizedBox.shrink()
                                : const Icon(
                                    Icons.person_add_alt_1_rounded,
                                  ),
                            label: _inscriptionEnCours
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Créer mon compte',
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton.icon(
                          onPressed: _inscriptionEnCours
                              ? null
                              : () {
                                  Navigator.of(context).pop();
                                },
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                          ),
                          label: const Text(
                            'J’ai déjà un compte',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _construireEntete(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(
              alpha: 0.10,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_add_alt_1_outlined,
            size: 32,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Créer votre espace GESTAUTO',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Commencez à gérer votre flotte en quelques étapes.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}