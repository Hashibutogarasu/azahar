/// What pressing a control on a controller binds in an `InputBindingOption`: the raw key of the
/// first button pressed as the platform names it, a key combination of everything held together,
/// or a whole analog stick. The last two are written by `GamepadKeyCombo.serialize`.
enum InputBindingMode { rawKey, combo, stick }
