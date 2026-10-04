/// Common contract for repositories that remove one of the values they persist, identified by
/// [K].
///
/// It is the counterpart of [Writable], which persists a value.
abstract class Deletable<K> {
  Future<void> delete(K key);
}
