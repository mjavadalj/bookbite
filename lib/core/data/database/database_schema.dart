/// The initial persisted schema contract. Concrete Drift tables and migrations
/// belong to their owning feature milestones and must advance this version.
abstract final class DatabaseSchema {
  static const initialVersion = 1;
}

abstract interface class DatabaseMigration {
  int get fromVersion;
  int get toVersion;

  Future<void> apply();
}
