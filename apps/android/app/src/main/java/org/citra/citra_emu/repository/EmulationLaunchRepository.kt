// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.repository

import android.content.Intent
import android.net.Uri
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.activities.EmulationActivity
import org.citra.citra_emu.fragments.EmulationFragmentArgs
import org.citra.citra_emu.model.Game

/**
 * Builds the deep-link [Intent] that starts [EmulationActivity] for a given [Game].
 *
 * [EmulationActivity] forwards its intent extras to
 * [org.citra.citra_emu.fragments.EmulationFragment] as Navigation Safe Args, which is where the
 * fragment actually reads the [Game] to run. Setting [Intent.setData] alone is not enough: the
 * fragment's fallback reconstructs a [Game] from the URI's file extension, which only works for
 * on-disk/SAF game files and fails for synthetic paths such as the HOME Menu NCCH path or an
 * Artic Base connection. This repository is the single place responsible for attaching the Safe
 * Args extra so every launch path resolves the [Game] the same, reliable way.
 */
class EmulationLaunchRepository {
    /**
     * Returns an [Intent] that starts [EmulationActivity] for [game], carrying both the legacy
     * [Intent.setData] (kept for compatibility with app shortcuts and external VIEW intents) and
     * the Safe Args extra that [org.citra.citra_emu.fragments.EmulationFragment] reads its [Game]
     * from.
     */
    fun createLaunchIntent(game: Game): Intent =
        Intent(CitraApplication.appContext, EmulationActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = if (game.isInstalled) {
                CitraApplication.documentsTree.getUri(game.path)
            } else {
                Uri.parse(game.path)
            }
            putExtras(EmulationFragmentArgs(game).toBundle())
        }
}
