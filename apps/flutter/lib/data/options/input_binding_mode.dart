/// What pressing a control on a controller or the keyboard binds in an `InputBindingOption`: the
/// raw key of the first controller button pressed as the platform names it, a key combination of
/// every button, stick direction and key held together, or a whole analog stick, which is either a
/// stick of a controller or four keys pressed in the order up, down, left and right. The last two
/// are written by `GamepadKeyCombo.serialize`.
enum InputBindingMode { rawKey, combo, stick }
