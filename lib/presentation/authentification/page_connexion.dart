import 'package:flutter/material.dart';

import '../../coeur/theme/controleur_theme.dart';
import '../../domaine/cas_utilisation/connecter_utilisateur.dart';
import '../../domaine/cas_utilisation/inscrire_utilisateur.dart';
import '../navigation/page_navigation_principale.dart';
import 'page_inscription.dart';

class PageConnexion extends StatefulWidget {
  final ConnecterUtilisateur connecterUtilisateur;
  final InscrireUtilisateur inscrireUtilisateur;
  final ControleurTheme controleurTheme;

  const PageConnexion({
    super.key,
    required this.connecterUtilisateur,
    required this.inscrireUtilisateur,
    required this.controleurTheme,
  });

  @override
  State<PageConnexion> createState() => _PageConnexionState();
}

class _PageConnexionState extends State<PageConnexion> {
  final _formulaire = GlobalKey<FormState>();

  final _controleurEmail = TextEditingController();
  final _controleurMotDePasse = TextEditingController();

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
      final resultat = await widget.connecterUtilisateur.executer(
        email: _controleurEmail.text.trim(),
        motDePasse: _controleurMotDePasse.text,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Bienvenue ${resultat.utilisateur.nom}',
          ),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => PageNavigationPrincipale(
            controleurTheme: widget.controleurTheme,
          ),
        ),
      );
    } catch (exception) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
            'Connexion impossible : $exception',
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
          inscrireUtilisateur: widget.inscrireUtilisateur,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 440,
              ),
              child: Form(
                key: _formulaire,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _construireEntete(context),
                    const SizedBox(height: 32),
                    Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Connexion',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Accédez à votre espace de gestion de flotte.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color:
                                    theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _controleurEmail,
                              keyboardType:
                                  TextInputType.emailAddress,
                              textInputAction:
                                  TextInputAction.next,
                              autofillHints: const [
                                AutofillHints.username,
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
                              controller:
                                  _controleurMotDePasse,
                              obscureText:
                                  !_motDePasseVisible,
                              textInputAction:
                                  TextInputAction.done,
                              autofillHints: const [
                                AutofillHints.password,
                              ],
                              onFieldSubmitted: (_) {
                                if (!_connexionEnCours) {
                                  _soumettre();
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Mot de passe',
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
                                if (valeur == null ||
                                    valeur.isEmpty) {
                                  return 'Veuillez saisir votre mot de passe';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 50,
                              child: FilledButton.icon(
                                onPressed: _connexionEnCours
                                    ? null
                                    : _soumettre,
                                icon: _connexionEnCours
                                    ? const SizedBox.shrink()
                                    : const Icon(
                                        Icons.login_rounded,
                                      ),
                                label: _connexionEnCours
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Se connecter',
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Vous n’avez pas encore de compte ?',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextButton.icon(
                      onPressed: _connexionEnCours
                          ? null
                          : _ouvrirInscription,
                      icon: const Icon(
                        Icons.person_add_alt_1_outlined,
                      ),
                      label: const Text(
                        'Créer un compte',
                      ),
                    ),
                  ],
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
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Icon(
            Icons.directions_car_filled_outlined,
            size: 40,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'GESTAUTO',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Gestion simple et efficace de votre flotte',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}