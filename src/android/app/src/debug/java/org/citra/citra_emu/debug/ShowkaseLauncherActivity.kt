// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.debug

import android.app.Activity
import android.os.Bundle
import com.airbnb.android.showkase.ui.ShowkaseBrowserActivity

/**
 * Debug-only entry point that opens the Showkase component browser.
 *
 * Registered as its own home screen launcher icon in debug builds only
 * (see the debug `AndroidManifest.xml`), so migrated Compose screens can
 * be inspected without wiring a menu entry into the production UI.
 */
class ShowkaseLauncherActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        startActivity(
            ShowkaseBrowserActivity.getIntent(this, AzaharShowkaseRoot::class.java.name)
        )
        finish()
    }
}
