/// A button that can be pressed through the gamepad API. [code] is the input code the native side
/// hands to the core.
enum GamePadButton {
  a(700),
  b(701),
  x(702),
  y(703),
  start(704),
  select(705),
  home(706),
  zl(707),
  zr(708),
  up(709),
  down(710),
  left(711),
  right(712),
  l(773),
  r(774);

  const GamePadButton(this.code);

  final int code;
}
