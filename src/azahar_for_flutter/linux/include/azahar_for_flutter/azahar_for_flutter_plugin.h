#ifndef FLUTTER_PLUGIN_AZAHAR_FOR_FLUTTER_PLUGIN_H_
#define FLUTTER_PLUGIN_AZAHAR_FOR_FLUTTER_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

/**
 * azahar_for_flutter_plugin_register_with_registrar:
 * @registrar: the registrar of the Flutter view that hosts the plugin.
 *
 * Registers the Azahar bridge channels on the engine of the view and hooks the
 * close request of the toplevel window so that Dart can stop a running game
 * before the application exits.
 */
FLUTTER_PLUGIN_EXPORT void azahar_for_flutter_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_AZAHAR_FOR_FLUTTER_PLUGIN_H_
