// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import android.provider.DocumentsContract

/**
 * Opens folders of a documents provider in the Files app that comes with Android.
 */
object FilesApp {
    /**
     * The packages of the Files app, which is the Google build on most devices and the AOSP build
     * on the others.
     */
    private val PACKAGES = listOf("com.google.android.documentsui", "com.android.documentsui")

    /**
     * Shows [folder], a document URI of a folder with or without its tree, in the Files app.
     * Falls back to any app that views folders when the Files app cannot be started. Returns
     * false when no app could be started.
     */
    fun openFolder(activity: Activity, folder: Uri): Boolean {
        val documentId = runCatching { DocumentsContract.getDocumentId(folder) }.getOrNull()
            ?: return false
        val intent = Intent(Intent.ACTION_VIEW)
            .setDataAndType(
                DocumentsContract.buildDocumentUri(folder.authority, documentId),
                DocumentsContract.Document.MIME_TYPE_DIR
            )
            .addFlags(
                Intent.FLAG_GRANT_READ_URI_PERMISSION or
                    Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                    Intent.FLAG_ACTIVITY_NEW_TASK
            )
        return (PACKAGES + null).any { packageName ->
            try {
                activity.startActivity(Intent(intent).setPackage(packageName))
                true
            } catch (e: ActivityNotFoundException) {
                false
            }
        }
    }

    /**
     * The folder that holds the document [file], kept in the same tree so that the permission
     * granted on the tree still applies. Document ids are opaque, so this relies on the providers
     * that hold games, such as the external storage and the profiles, building the id of a
     * document from the id of its folder followed by `/` and its name.
     */
    fun parentFolder(file: Uri): Uri? {
        val documentId = runCatching { DocumentsContract.getDocumentId(file) }.getOrNull()
            ?: return null
        val separator = documentId.lastIndexOf('/')
        val parentId = when {
            separator > 0 -> documentId.substring(0, separator)
            documentId.contains(':') -> documentId.substringBefore(':') + ":"
            else -> return null
        }
        return if (DocumentsContract.isTreeUri(file)) {
            DocumentsContract.buildDocumentUriUsingTree(file, parentId)
        } else {
            DocumentsContract.buildDocumentUri(file.authority, parentId)
        }
    }
}
