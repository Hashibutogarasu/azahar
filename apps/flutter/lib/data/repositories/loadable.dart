/// Common contract for repositories/value stores that need to hydrate their in-memory state
/// from persistent storage before it can be read.
abstract class Loadable {
  Future<void> load();
}
