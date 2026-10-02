// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.profiles

import android.content.Context
import android.database.Cursor
import android.database.MatrixCursor
import android.net.Uri
import android.os.CancellationSignal
import android.os.ParcelFileDescriptor
import android.provider.DocumentsContract
import android.provider.DocumentsContract.Document
import android.provider.DocumentsContract.Root
import android.provider.DocumentsProvider
import android.webkit.MimeTypeMap
import androidx.documentfile.provider.DocumentFile
import java.io.File
import java.io.FileNotFoundException

/**
 * Shows every profile as a root of the system file manager and serves the files of its folder.
 *
 * The built-in profile and the user profiles only differ in where their folder is: a folder in
 * the app's documents or a folder the user picked. Both are reached through [DocumentFile], so
 * every profile goes through the same code. The core also reaches the folder of the current
 * profile through this provider, by the tree URI that [treeUri] returns.
 *
 * A document id is the hash of the profile followed by the path of the document inside the
 * profile's folder, built as the path segments of a [Uri].
 */
class ProfilesDocumentsProvider : DocumentsProvider() {
    private val store by lazy { ProfileStore(requireContext()) }

    override fun onCreate(): Boolean = true

    override fun queryRoots(projection: Array<out String>?): Cursor {
        val cursor = MatrixCursor(projection ?: DEFAULT_ROOT_PROJECTION)
        store.entries().forEach { entry ->
            cursor.newRow()
                .add(Root.COLUMN_ROOT_ID, entry.hash)
                .add(Root.COLUMN_DOCUMENT_ID, documentId(entry.hash, emptyList()))
                .add(Root.COLUMN_TITLE, entry.name)
                .add(
                    Root.COLUMN_FLAGS,
                    Root.FLAG_SUPPORTS_CREATE or Root.FLAG_SUPPORTS_IS_CHILD
                )
                .add(Root.COLUMN_ICON, requireContext().applicationInfo.icon)
        }
        return cursor
    }

    override fun queryDocument(documentId: String, projection: Array<out String>?): Cursor {
        val cursor = MatrixCursor(projection ?: DEFAULT_DOCUMENT_PROJECTION)
        addRow(cursor, documentId, resolve(documentId))
        return cursor
    }

    override fun queryChildDocuments(
        parentDocumentId: String,
        projection: Array<out String>?,
        sortOrder: String?
    ): Cursor {
        val cursor = MatrixCursor(projection ?: DEFAULT_DOCUMENT_PROJECTION)
        val parent = resolve(parentDocumentId)
        parent.listFiles().forEach { child ->
            val name = child.name ?: return@forEach
            addRow(cursor, childId(parentDocumentId, name), child)
        }
        return cursor
    }

    override fun openDocument(
        documentId: String,
        mode: String,
        signal: CancellationSignal?
    ): ParcelFileDescriptor {
        val document = resolve(documentId)
        return requireContext().contentResolver.openFileDescriptor(document.uri, mode, signal)
            ?: throw FileNotFoundException(documentId)
    }

    override fun createDocument(
        parentDocumentId: String,
        mimeType: String,
        displayName: String
    ): String {
        val parent = resolve(parentDocumentId)
        val created = if (mimeType == Document.MIME_TYPE_DIR) {
            parent.createDirectory(displayName)
        } else {
            parent.createFile(mimeType, displayName)
        } ?: throw FileNotFoundException(displayName)
        val documentId = childId(parentDocumentId, created.name ?: displayName)
        notifyChildrenChanged(parentDocumentId)
        return documentId
    }

    override fun deleteDocument(documentId: String) {
        if (!resolve(documentId).delete()) {
            throw FileNotFoundException(documentId)
        }
        parentId(documentId)?.let(::notifyChildrenChanged)
    }

    override fun renameDocument(documentId: String, displayName: String): String {
        val document = resolve(documentId)
        if (!document.renameTo(displayName)) {
            throw FileNotFoundException(documentId)
        }
        val parent = parentId(documentId) ?: return documentId
        notifyChildrenChanged(parent)
        return childId(parent, document.name ?: displayName)
    }

    override fun isChildDocument(parentDocumentId: String, documentId: String): Boolean {
        val parent = segments(parentDocumentId)
        val child = segments(documentId)
        return child.size > parent.size && child.subList(0, parent.size) == parent
    }

    override fun getDocumentType(documentId: String): String = mimeType(resolve(documentId))

    private fun addRow(cursor: MatrixCursor, documentId: String, document: DocumentFile) {
        val isDirectory = document.isDirectory
        var flags = Document.FLAG_SUPPORTS_DELETE or Document.FLAG_SUPPORTS_RENAME
        flags = flags or if (isDirectory) {
            Document.FLAG_DIR_SUPPORTS_CREATE
        } else {
            Document.FLAG_SUPPORTS_WRITE
        }
        val name = if (segments(documentId).size == 1) {
            store.entry(segments(documentId).first())?.name
        } else {
            document.name
        }
        cursor.newRow()
            .add(Document.COLUMN_DOCUMENT_ID, documentId)
            .add(Document.COLUMN_DISPLAY_NAME, name ?: document.name)
            .add(Document.COLUMN_MIME_TYPE, mimeType(document))
            .add(Document.COLUMN_SIZE, if (isDirectory) null else document.length())
            .add(Document.COLUMN_LAST_MODIFIED, document.lastModified())
            .add(Document.COLUMN_FLAGS, flags)
    }

    /** Finds the document [documentId] inside the folder of its profile. */
    private fun resolve(documentId: String): DocumentFile {
        val segments = segments(documentId)
        val entry = segments.firstOrNull()?.let(store::entry)
            ?: throw FileNotFoundException(documentId)
        var document = root(entry.location) ?: throw FileNotFoundException(documentId)
        segments.drop(1).forEach { name ->
            document = document.findFile(name) ?: throw FileNotFoundException(documentId)
        }
        return document
    }

    private fun root(location: Uri): DocumentFile? {
        return if (location.scheme == "file") {
            DocumentFile.fromFile(File(location.path!!))
        } else {
            DocumentFile.fromTreeUri(requireContext(), location)
        }
    }

    private fun mimeType(document: DocumentFile): String {
        if (document.isDirectory) return Document.MIME_TYPE_DIR
        document.type?.let { return it }
        val extension = document.name?.substringAfterLast('.', "")?.lowercase()
        return extension
            ?.let { MimeTypeMap.getSingleton().getMimeTypeFromExtension(it) }
            ?: "application/octet-stream"
    }

    private fun notifyChildrenChanged(parentDocumentId: String) {
        requireContext().contentResolver.notifyChange(
            DocumentsContract.buildChildDocumentsUri(authority(requireContext()), parentDocumentId),
            null
        )
    }

    companion object {
        private val DEFAULT_ROOT_PROJECTION = arrayOf(
            Root.COLUMN_ROOT_ID,
            Root.COLUMN_DOCUMENT_ID,
            Root.COLUMN_TITLE,
            Root.COLUMN_FLAGS,
            Root.COLUMN_ICON
        )

        private val DEFAULT_DOCUMENT_PROJECTION = arrayOf(
            Document.COLUMN_DOCUMENT_ID,
            Document.COLUMN_DISPLAY_NAME,
            Document.COLUMN_MIME_TYPE,
            Document.COLUMN_SIZE,
            Document.COLUMN_LAST_MODIFIED,
            Document.COLUMN_FLAGS
        )

        fun authority(context: Context): String =
            "${context.packageName}.azahar_for_flutter.profiles"

        /** The tree URI that gives the core the folder of the profile [hash]. */
        fun treeUri(context: Context, hash: String): Uri =
            DocumentsContract.buildTreeDocumentUri(authority(context), documentId(hash, emptyList()))

        /** Hands the profiles over to the provider and refreshes the roots of the file manager. */
        internal fun setProfiles(context: Context, entries: List<ProfileStore.Entry>) {
            ProfileStore(context).replace(entries)
            context.contentResolver.notifyChange(
                DocumentsContract.buildRootsUri(authority(context)),
                null
            )
        }

        private fun documentId(hash: String, path: List<String>): String {
            val builder = Uri.Builder().appendPath(hash)
            path.forEach { builder.appendPath(it) }
            return builder.build().encodedPath!!
        }

        private fun segments(documentId: String): List<String> =
            Uri.parse(documentId).pathSegments

        private fun childId(parentDocumentId: String, name: String): String {
            val segments = segments(parentDocumentId)
            return documentId(segments.first(), segments.drop(1) + name)
        }

        private fun parentId(documentId: String): String? {
            val segments = segments(documentId)
            if (segments.size <= 1) return null
            return documentId(segments.first(), segments.drop(1).dropLast(1))
        }
    }
}
