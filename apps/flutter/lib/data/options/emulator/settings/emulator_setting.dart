/// Reads, writes and weighs one emulator setting that changes how heavy the emulation is.
///
/// It needs no widget reference, so the weight index can be computed anywhere.
abstract class EmulatorSetting<T> {
  const EmulatorSetting();
  double get weightIndex;

  /// How much of [weightIndex] the value [value] costs, from 0.0 (nothing) to 1.0 (all of it).
  double weightFactor(T value);

  /// Returns the stored value.
  T read();

  /// Stores [value] and persists it.
  Future<void> write(T value);

  /// The share of the whole weight index the current value adds.
  double get currentWeight => weightIndex * weightFactor(read());
}
