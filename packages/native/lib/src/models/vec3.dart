import 'package:flutter/foundation.dart';

/// A three-component vector, used for motion sensor values.
///
/// The axes are those of the 3DS: x+ points to the left of the console, y+ out of the screen
/// towards the player and z+ up.
@immutable
class Vec3 {
  const Vec3(this.x, this.y, this.z);

  static const zero = Vec3(0, 0, 0);

  final double x;
  final double y;
  final double z;

  List<double> toList() => [x, y, z];

  static Vec3 fromList(List<Object?> values) => Vec3(
    (values[0] as num).toDouble(),
    (values[1] as num).toDouble(),
    (values[2] as num).toDouble(),
  );

  @override
  bool operator ==(Object other) =>
      other is Vec3 && other.x == x && other.y == y && other.z == z;

  @override
  int get hashCode => Object.hash(x, y, z);

  @override
  String toString() => 'Vec3($x, $y, $z)';
}
