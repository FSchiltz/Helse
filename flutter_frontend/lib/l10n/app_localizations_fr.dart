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
  String get deleteMetric => 'Supprimer la métrique ?';

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

  @override
  String get serverurl => 'url du serveur';

  @override
  String get url => 'url';

  @override
  String invalid(String item) {
    return '$item invalide';
  }

  @override
  String get login => 'Connexion';

  @override
  String loginwith(String provider) {
    return 'Connexion via $provider';
  }

  @override
  String get create => 'Créer';

  @override
  String get createAccount => 'Créez votre compte';

  @override
  String get adminDescription => 'C\'est le compte administrateur du serveur';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get welcomenew => 'Utilisateur créé, bienvenue';

  @override
  String get deleteUser => 'Supprimer l\'utilisateur ?';

  @override
  String get delete => 'Supprimer';

  @override
  String get saved => 'Sauvé avec succes';

  @override
  String get save => 'Sauver';

  @override
  String get events => 'Evénements';

  @override
  String get metrics => 'Métriques';

  @override
  String get metricgroups => 'Groupes de métriques';

  @override
  String get visible => 'Visible';

  @override
  String get widgetType => 'Type de widget';

  @override
  String get detailType => 'Type de détail';

  @override
  String get date => 'Date';

  @override
  String get value => 'Valeur';

  @override
  String get tag => 'Tag';

  @override
  String get source => 'Source';

  @override
  String get treatment => 'traitement';

  @override
  String get showOnDashboard => 'Afficher sur le tableau de bord';

  @override
  String get patientsSettings => 'Options des patients';

  @override
  String get localSettings => 'Options';

  @override
  String get general => 'Général';

  @override
  String get healthsync => 'Synchro Health';

  @override
  String get users => 'Utilisateurs';

  @override
  String get enable => 'Activer';

  @override
  String lastRun(String date) {
    return 'Dernière execution';
  }

  @override
  String get resetLastRun => 'Réinitialiser la dernière execution';

  @override
  String get syncFit => 'Synchronisation avec Google health';

  @override
  String get syncBackgroundToggle => 'Synchroniser en arrière plan';

  @override
  String get syncHistoryToggle => 'Synchroniser aussi les données historiques';

  @override
  String get sessions => 'Connexions';

  @override
  String get cleanSessions => 'Supprimer toutes les sessions';

  @override
  String get constants => 'Constantes';

  @override
  String get id => 'Id';

  @override
  String get code => 'Code';

  @override
  String get unit => 'Unité';

  @override
  String get group => 'Groupe';

  @override
  String get summary => 'Résumé';

  @override
  String get total => 'Total';

  @override
  String get mean => 'Moyenne';

  @override
  String eventInformationSummary(String total, String length, String mean) {
    return 'Total de $total en $length sessions avec une moyenne de $mean';
  }

  @override
  String get color => 'Couleur';

  @override
  String searchItem(String item) {
    return 'Search a $item';
  }

  @override
  String get min => 'Minimum';

  @override
  String get max => 'Maximum';
}
