/// Common contract for repositories that add a new value built from [T] and return what was
/// added as [R].
///
/// It is the counterpart of [Deletable], which removes a value.
abstract class Creatable<T, R> {
  Future<R> create(T value);
}
