// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get administration => 'Administration';

  @override
  String get logout => 'Déconnexion';

  @override
  String get settings => 'Configuration';

  @override
  String get import => 'Importation';

  @override
  String get days => 'jours';

  @override
  String get months => 'mois';

  @override
  String get years => 'années';

  @override
  String get yeartodate => 'Année en cours';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get importHistory => 'Historique des importations';

  @override
  String get syncHistory => 'Historique de la synchronisation';

  @override
  String get initialrange => 'Durée initale';

  @override
  String get start => 'start';

  @override
  String get stop => 'stop';

  @override
  String get end => 'fin';

  @override
  String get notificationTime => 'Date de notification';

  @override
  String error(String error) {
    return 'Erreur: $error';
  }

  @override
  String get password => 'Mot de passe';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get name => 'Nom';

  @override
  String get surname => 'Prénom';

  @override
  String get confirmpassword => 'Confirmation du mot de passe';

  @override
  String get email => 'Email';

  @override
  String get type => 'Type';

  @override
  String get eventSettings => 'Options d\'évenements';

  @override
  String get generalSettings => 'Options générales';

  @override
  String get metricSettings => 'Options des metriques';

  @override
  String get userSettings => 'Options des utilisateurs';

  @override
  String get added => 'Ajouté avec succes';

  @override
  String get add => 'Ajouter';

  @override
  String addItem(String item) {
    return 'Ajouter un $item';
  }

  @override
  String get submit => 'Soumettre';

  @override
  String get description => 'Description';

  @override
  String get addPatients => 'Ajouter un nouveau patient';

  @override
  String get edit => 'Editer';

  @override
  String get share => 'Partager';

  @override
  String get patients => 'Patients';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get deleteEvent => 'Supprimer l\'evenement ?';

  @override
  String detailof(String item) {
    return 'Detail de $item';
  }

  @override
  String range(String from, String to) {
    return 'Du $from au $to';
  }

  @override
  String get nodata => 'Pas de données';

  @override
  String get notask => 'Pas de taches';
}
