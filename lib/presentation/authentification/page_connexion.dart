import 'package:flutter/material.dart';

import '../../domaine/cas_utilisation/connecter_utilisateur.dart';
import '../../domaine/cas_utilisation/inscrire_utilisateur.dart';
import '../navigation/page_navigation_principale.dart';
import 'page_inscription.dart';

class PageConnexion extends StatefulWidget {
  final ConnecterUtilisateur connecterUtilisateur;
  final InscrireUtilisateur inscrireUtilisateur;

  const PageConnexion({
    super.key,
    required this.connecterUtilisateur,
    required this.inscrireUtilisateur,
  });

  @override
  State<PageConnexion> createState() =>
      _PageConnexionState();
}

class _PageConnexionState
    extends State<PageConnexion> {
  final _formulaire =
      GlobalKey<FormState>();

  final _controleurEmail =
      TextEditingController();

  final _controleurMotDePasse =
      TextEditingController();

  bool _motDePasseVisible = false;
  bool _connexionEnCours = false;

  @override
  void dispose() {
    _controleurEmail.dispose();
    _controleurMotDePasse.dispose();

    super.dispose();
  }

  Future<void> _soumettre() async {
    if (!_formulaire.currentState!.validate()) {
      return;
    }

    setState(() {
      _connexionEnCours = true;
    });

    try {
      final resultat =
          await widget.connecterUtilisateur.executer(
        email: _controleurEmail.text.trim(),
        motDePasse: _controleurMotDePasse.text,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Bienvenue ${resultat.utilisateur.nom}',
          ),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              const PageNavigationPrincipale(),
        ),
      );
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
          _connexionEnCours = false;
        });
      }
    }
  }

  void _ouvrirInscription() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PageInscription(
          inscrireUtilisateur:
              widget.inscrireUtilisateur,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
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
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'GESTAUTO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Connectez-vous à votre compte',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller:
                        _controleurEmail,
                    keyboardType:
                        TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Adresse e-mail',
                      border:
                          OutlineInputBorder(),
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
                    controller:
                        _controleurMotDePasse,
                    obscureText:
                        !_motDePasseVisible,
                    decoration: InputDecoration(
                      labelText:
                          'Mot de passe',
                      border:
                          const OutlineInputBorder(),
                      prefixIcon:
                          const Icon(
                        Icons.lock_outline,
                      ),
                      suffixIcon:
                          IconButton(
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
                      if (valeur == null ||
                          valeur.isEmpty) {
                        return 'Veuillez saisir votre mot de passe';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed:
                        _connexionEnCours
                            ? null
                            : _soumettre,
                    child:
                        _connexionEnCours
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Se connecter',
                              ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed:
                        _connexionEnCours
                            ? null
                            : _ouvrirInscription,
                    child: const Text(
                      "Pas encore de compte ? S'inscrire",
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