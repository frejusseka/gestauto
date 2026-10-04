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
          content: Text(
            'Erreur : $exception',
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
        title: const Text('Inscription'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 450,
            ),
            child: Form(
              key: _formulaire,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Créer un compte',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Rejoignez GESTAUTO',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _controleurNom,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
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
                    decoration: const InputDecoration(
                      labelText: 'Adresse e-mail',
                      border: OutlineInputBorder(),
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
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      border: const OutlineInputBorder(),
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
                    decoration: InputDecoration(
                      labelText: 'Confirmer le mot de passe',
                      border: const OutlineInputBorder(),
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
                  FilledButton(
                    onPressed:
                        _inscriptionEnCours ? null : _soumettre,
                    child: _inscriptionEnCours
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("S'inscrire"),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _inscriptionEnCours
                        ? null
                        : () {
                            Navigator.of(context).pop();
                          },
                    child: const Text(
                      'Déjà un compte ? Se connecter',
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