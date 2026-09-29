package com.karasu256.azahar_reloaded.lib.azahar_for_flutter

/**
 * Runs [AzaharInitProvider] in the `:emulation` process.
 *
 * A content provider is created only in the process it is declared for, so the
 * emulation process needs its own declaration.
 */
class AzaharEmulationInitProvider : AzaharInitProvider()
