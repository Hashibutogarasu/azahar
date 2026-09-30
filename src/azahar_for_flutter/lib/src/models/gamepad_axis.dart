/// An analog input that can be moved through the gamepad API. [code] is the input code the native
/// side hands to the core. The native side gives [dpad], the D-PAD stick, to the core as the
/// Circle Pad.
enum GamePadAxis {
  dpad(713),
  cStick(718);

  const GamePadAxis(this.code);

  final int code;
}
