// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

enum DatePreset {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('today')
  today('today'),
  @JsonValue('week')
  week('week'),
  @JsonValue('month')
  month('month'),
  @JsonValue('trimestre')
  trimestre('trimestre'),
  @JsonValue('halfYear')
  halfyear('halfYear'),
  @JsonValue('year')
  year('year'),
  @JsonValue('yearToDate')
  yeartodate('yearToDate');

  final String? value;

  const DatePreset(this.value);
}

enum FileTypes {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('None')
  none('None'),
  @JsonValue('RedmiWatch')
  redmiwatch('RedmiWatch'),
  @JsonValue('GoogleHealthConnect')
  googlehealthconnect('GoogleHealthConnect'),
  @JsonValue('Clue')
  clue('Clue'),
  @JsonValue('BabyTracker')
  babytracker('BabyTracker');

  final String? value;

  const FileTypes(this.value);
}

enum GraphKind {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('Text')
  text('Text'),
  @JsonValue('Line')
  line('Line'),
  @JsonValue('Bar')
  bar('Bar');

  final String? value;

  const GraphKind(this.value);
}

enum JobStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('NotStarted')
  notstarted('NotStarted'),
  @JsonValue('InProgress')
  inprogress('InProgress'),
  @JsonValue('Done')
  done('Done'),
  @JsonValue('InError')
  inerror('InError'),
  @JsonValue('Cancel')
  cancel('Cancel');

  final String? value;

  const JobStatus(this.value);
}

enum MetricDataType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('Text')
  text('Text'),
  @JsonValue('Number')
  number('Number');

  final String? value;

  const MetricDataType(this.value);
}

enum MetricSummary {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('Latest')
  latest('Latest'),
  @JsonValue('Sum')
  sum('Sum'),
  @JsonValue('Mean')
  mean('Mean');

  final String? value;

  const MetricSummary(this.value);
}

enum RightType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('View')
  view('View'),
  @JsonValue('Edit')
  edit('Edit');

  final String? value;

  const RightType(this.value);
}

enum Theme {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('System')
  system('System'),
  @JsonValue('Dark')
  dark('Dark'),
  @JsonValue('Light')
  light('Light');

  final String? value;

  const Theme(this.value);
}

enum TreatmentType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('Care')
  care('Care');

  final String? value;

  const TreatmentType(this.value);
}

enum UserType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('Admin')
  admin('Admin'),
  @JsonValue('Caregiver')
  caregiver('Caregiver'),
  @JsonValue('User')
  user('User');

  final String? value;

  const UserType(this.value);
}
