/// Common contract for repositories/value stores that persist a value they hold in memory.
///
/// It is the counterpart of [Loadable], which hydrates the in-memory state from persistent storage.
abstract class Writable<T> {
  Future<void> write(T value);
}
