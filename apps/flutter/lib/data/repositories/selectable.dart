/// Common contract for repositories that keep one of their values, identified by [K], as the one
/// in use.
abstract class Selectable<K> {
  Future<void> select(K key);
}
