part of '../user_database.dart';

String _newControllerProfileCuid() => cuid();

/// A set of controller settings that can be switched between, such as one per controller. The
/// key bindings of both the app and the emulation belong to one of them through their profile id.
///
/// [cuid] is generated on insert and identifies the profile. [isBuiltIn] marks the profile that
/// always exists and cannot be deleted.
@DataClassName('ControllerProfileRow')
class ControllerProfiles extends Table {
  TextColumn get cuid => text().clientDefault(_newControllerProfileCuid)();
  TextColumn get name => text()();
  BoolColumn get isBuiltIn => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {cuid};
}
