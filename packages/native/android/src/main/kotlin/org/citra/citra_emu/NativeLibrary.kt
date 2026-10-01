// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu

import android.Manifest.permission
import android.app.Dialog
import android.content.Context
import android.content.DialogInterface
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.net.Uri
import android.net.wifi.WifiManager
import android.os.Bundle
import android.os.SystemClock
import android.text.Html
import android.text.method.LinkMovementMethod
import android.view.KeyEvent
import android.view.MotionEvent
import android.view.Surface
import android.view.View
import android.widget.TextView
import androidx.annotation.Keep
import androidx.core.content.ContextCompat
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.FragmentActivity
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.R
import org.citra.citra_emu.channel.EmulationController
import org.citra.citra_emu.utils.EmulationMenuSettings
import org.citra.citra_emu.utils.FileUtil
import org.citra.citra_emu.utils.Log
import org.citra.citra_emu.utils.LogLineRelay
import java.lang.ref.WeakReference
import java.util.Date

/**
 * Class which contains methods that interact
 * with the native side of the Citra code.
 */
object NativeLibrary {
    /**
     * Default touchscreen device
     */
    const val TouchScreenDevice = "Touchscreen"

    @JvmField
    var sEmulationActivity = WeakReference<FragmentActivity?>(null)
    private var alertResult = false
    val alertLock = Object()

    init {
        try {
            System.loadLibrary("citra-android")
        } catch (ex: UnsatisfiedLinkError) {
            Log.error("[NativeLibrary] $ex")
        }
    }

    /**
     * Handles button press events for a gamepad.
     *
     * @param device The input descriptor of the gamepad.
     * @param button Key code identifying which button was pressed.
     * @param action Mask identifying which action is happening (button pressed down, or button released).
     * @return If we handled the button press.
     */
    external fun onGamePadEvent(device: String, button: Int, action: Int): Boolean

    /**
     * Handles gamepad movement events.
     *
     * @param device The device ID of the gamepad.
     * @param axis   The axis ID
     * @param xAxis The value of the x-axis represented by the given ID.
     * @param yAxis The value of the y-axis represented by the given ID
     */
    external fun onGamePadMoveEvent(device: String, axis: Int, xAxis: Float, yAxis: Float): Boolean

    /**
     * Handles gamepad movement events.
     *
     * @param device   The device ID of the gamepad.
     * @param axisId  The axis ID
     * @param axisVal The value of the axis represented by the given ID.
     */
    external fun onGamePadAxisEvent(device: String?, axisId: Int, axisVal: Float): Boolean

    /** Records a virtual (touch overlay) button's pressed state, merged by GameControllerManager. */
    external fun setVirtualButton(button: Int, pressed: Boolean)

    /** Records a virtual (touch overlay) stick's position, merged by GameControllerManager. */
    external fun setVirtualStick(axis: Int, xAxis: Float, yAxis: Float)

    /** Releases every virtual (touch overlay) button/stick tracked by GameControllerManager. */
    external fun clearVirtualControllerInputs()

    /**
     * Selects whether a gyroscope-capable physical controller's gyroscope should be used in
     * place of the Android device's own gyroscope. Has no effect when no such controller is
     * connected; the device's own gyroscope is used in that case regardless of this setting.
     */
    external fun setGyroPreferExternalController(preferExternal: Boolean)

    /**
     * Sets the gyroscope's per-axis output multiplier (1.0 = unchanged), applied regardless of
     * whether the device's own gyroscope or a physical controller's is currently active.
     */
    external fun setGyroSensitivity(verticalScale: Float, horizontalScale: Float)

    /** Sets whether each gyroscope axis (see [setGyroSensitivity]) should be negated. */
    external fun setGyroInvert(invertVertical: Boolean, invertHorizontal: Boolean)

    /**
     * Sets the latest motion sensor sample the core reads, given by the frontend instead of being
     * read from the device's sensors. Acceleration is in g and angular velocity in degrees per
     * second, both with the axes of the 3DS.
     */
    external fun setMotion(
        accelX: Float,
        accelY: Float,
        accelZ: Float,
        gyroX: Float,
        gyroY: Float,
        gyroZ: Float
    )

    /**
     * Handles touch events.
     *
     * @param xAxis  The value of the x-axis.
     * @param yAxis  The value of the y-axis
     * @param pressed To identify if the touch held down or released.
     * @return true if the pointer is within the touchscreen
     */
    external fun onTouchEvent(xAxis: Float, yAxis: Float, pressed: Boolean): Boolean

    /**
     * Handles touch movement.
     *
     * @param xAxis The value of the instantaneous x-axis.
     * @param yAxis The value of the instantaneous y-axis.
     */
    external fun onTouchMoved(xAxis: Float, yAxis: Float)

    external fun reloadSettings()

    external fun getTitleId(filename: String): Long

    external fun getIsSystemTitle(path: String): Boolean

    /**
     * Sets the current working user directory
     * If not set, it auto-detects a location
     */
    external fun setUserDirectory(directory: String)

    /**
     * Gives the native side the context of the application, for the audio output of a session
     * to query the audio system with.
     */
    external fun setApplicationContext(context: Context)
    external fun getInstalledGamePaths(roots: Array<String>, paths: Array<String>): Array<String?>

    // Create the config.ini file.
    external fun createConfigFile()
    external fun startLogging()
    external fun logUserDirectory(directory: String)

    /** Enables or disables the native console log backend. */
    external fun setConsoleLogEnabled(enabled: Boolean)

    /**
     * Receives one UTF-8 encoded log line from the native logging backend.
     */
    @JvmStatic
    fun onLogLine(line: ByteArray) = LogLineRelay.push(line)

    /**
     * Called by the native logging backend when the log should be persisted. Lines are
     * forwarded in batches, so there is nothing to flush here.
     */
    @JvmStatic
    fun flushLog() = Unit

    /**
     * Begins emulation.
     */
    external fun run(path: String)

    /**
     * Surface handling. The "primary" surface always renders the 3DS top screen; the
     * "secondary" surface always renders the bottom screen. The app decides where each is
     * displayed on screen (order, size, swap) independently of these native entry points.
     */
    external fun surfaceChanged(surf: Surface)
    external fun surfaceDestroyed()
    external fun doFrame()
    external fun surfaceChangedSecondary(surf: Surface)
    external fun surfaceDestroyedSecondary()
    external fun doFrameSecondary()

    /**
     * Initializes the Android Game Controller Library so physical controllers can be
     * auto-detected and mapped to standardized inputs, instead of relying on manual bindings.
     */
    external fun initGameControllerManager(context: Context)
    external fun shutdownGameControllerManager()

    /**
     * Merges the virtual controller with, when readPhysicalControllers is true, every connected
     * physical controller, and forwards the result to the emulated core. Must be called once per
     * frame regardless of controller input mode, since the virtual overlay is always active.
     * invertLeftStickY flips a physical left stick's Y axis back to Android's raw convention.
     */
    external fun updateGameControllers(invertLeftStickY: Boolean, readPhysicalControllers: Boolean)

    /**
     * Forwards a physical controller key/motion event for auto-detect processing. Returns false
     * (and does nothing) on API levels below 31, letting the caller fall back to manual mapping.
     */
    external fun onGameControllerKeyEvent(event: KeyEvent): Boolean
    external fun onGameControllerMotionEvent(event: MotionEvent): Boolean

    /**
     * Unpauses emulation from a paused state.
     */
    external fun unPauseEmulation()

    /**
     * Pauses emulation.
     */
    external fun pauseEmulation()

    /**
     * Stops emulation.
     */
    external fun stopEmulation()

    /**
     * Advances emulation by exactly one frame while paused.
     */
    external fun advanceFrame()

    /**
     * Dumps the current FCRAM contents of the running session.
     *
     * @return the raw FCRAM bytes.
     */
    external fun dumpCurrentMemory(): ByteArray

    /**
     * Starts capturing FCRAM snapshots into sequentially numbered binary files under the given
     * directory, taking one snapshot every intervalFrames emulated frames.
     *
     * @param outputDirPath absolute path of an existing directory to write frame dumps into.
     * @param intervalFrames number of emulated frames between successive snapshots.
     */
    external fun startMemoryRecording(outputDirPath: String, intervalFrames: Int)

    /**
     * Stops the active memory recording session.
     *
     * @return the number of frames that were written.
     */
    external fun stopMemoryRecording(): Int

    /**
     * Returns true if emulation is running (or is paused).
     */
    external fun isRunning(): Boolean

    /**
     * Returns the title ID of the currently running title, or 0 on failure.
     */
    external fun getRunningTitleId(): Long

    /**
     * Returns the performance stats for the current game
     */
    external fun getPerfStats(): DoubleArray

    /**
     * Notifies the core emulation that the layout should be updated
     */
    external fun updateFramebuffer(isPortrait: Boolean)

    /**
     * Swaps the top and bottom screens.
     */
    external fun swapScreens(swapScreens: Boolean, rotation: Int)

    external fun initializeGpuDriver(
        hookLibDir: String?,
        customDriverDir: String?,
        customDriverName: String?,
        fileRedirectDir: String?
    )

    external fun areKeysAvailable(): Boolean

    external fun getHomeMenuPath(region: Int): String

    external fun getSystemTitleIds(systemType: Int, region: Int): LongArray

    external fun areSystemTitlesInstalled(): BooleanArray

    external fun uninstallSystemFiles(old3DS: Boolean)

    external fun isFullConsoleLinked(): Boolean

    external fun unlinkConsole()

    private var coreErrorAlertResult = false
    private val coreErrorAlertLock = Object()

    private fun onCoreErrorImpl(title: String, message: String, canContinue: Boolean) {
        val emulationActivity = sEmulationActivity.get()
        if (emulationActivity == null) {
            Log.error("[NativeLibrary] EmulationActivity not present")
            return
        }
        val fragment = CoreErrorDialogFragment.newInstance(title, message, canContinue)
        fragment.show(emulationActivity.supportFragmentManager, CoreErrorDialogFragment.TAG)
    }

    /**
     * Handles a core error.
     * @return true: continue; false: abort
     */
    @Keep
    @JvmStatic
    fun onCoreError(error: CoreError?, details: String): Boolean {
        val emulationActivity = sEmulationActivity.get()
        if (emulationActivity == null) {
            Log.error("[NativeLibrary] EmulationActivity not present")
            return false
        }
        val title: String
        val message: String
        val canContinue: Boolean
        when (error) {
            CoreError.ErrorSystemFiles -> {
                title = emulationActivity.getString(R.string.system_archive_not_found)
                message = emulationActivity.getString(
                    R.string.system_archive_not_found_message,
                    details.ifEmpty { emulationActivity.getString(R.string.system_archive_general) }
                )
                canContinue = true
            }

            CoreError.ErrorSavestate -> {
                title = emulationActivity.getString(R.string.save_load_error)
                message = details
                canContinue = true
            }

            CoreError.ErrorArticDisconnected -> {
                title = emulationActivity.getString(R.string.artic_base)
                message = emulationActivity.getString(R.string.artic_server_comm_error)
                canContinue = false
            }

            CoreError.ErrorUnknown -> {
                title = emulationActivity.getString(R.string.fatal_error)
                message = emulationActivity.getString(R.string.fatal_error_message)
                canContinue = true
            }

            else -> {
                return true
            }
        }

        // Show the AlertDialog on the main thread.
        emulationActivity.runOnUiThread(Runnable { onCoreErrorImpl(title, message, canContinue) })

        // Wait for the lock to notify that it is complete.
        synchronized(coreErrorAlertLock) {
            try {
                coreErrorAlertLock.wait()
            } catch (ignored: Exception) {
            }
        }
        return coreErrorAlertResult
    }

    @get:Keep
    @get:JvmStatic
    val isPortraitMode: Boolean
        get() = CitraApplication.appContext.resources.configuration.orientation ==
                Configuration.ORIENTATION_PORTRAIT

    @Keep
    @JvmStatic
    fun displayAlertMsg(title: String, message: String, yesNo: Boolean): Boolean {
        Log.error("[NativeLibrary] Alert: $message")
        val emulationActivity = sEmulationActivity.get()
        var result = false
        if (emulationActivity == null) {
            Log.warning("[NativeLibrary] EmulationActivity is null, can't do panic alert.")
        } else {
            // Show the AlertDialog on the main thread.
            emulationActivity.runOnUiThread {
                AlertMessageDialogFragment.newInstance(title, message, yesNo).showNow(
                    emulationActivity.supportFragmentManager,
                    AlertMessageDialogFragment.TAG
                )
            }

            // Wait for the lock to notify that it is complete.
            synchronized(alertLock) {
                try {
                    alertLock.wait()
                } catch (_: Exception) {
                }
            }
            if (yesNo) result = alertResult
        }
        return result
    }

    class AlertMessageDialogFragment : DialogFragment() {
        override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
            // Create object used for waiting.
            val builder = MaterialAlertDialogBuilder(requireContext())
                .setTitle(requireArguments().getString(TITLE))
                .setMessage(requireArguments().getString(MESSAGE))

            // If not yes/no dialog just have one button that dismisses modal,
            // otherwise have a yes and no button that sets alertResult accordingly.
            if (!requireArguments().getBoolean(YES_NO)) {
                builder
                    .setCancelable(false)
                    .setPositiveButton(android.R.string.ok) { _: DialogInterface, _: Int ->
                        synchronized(alertLock) { alertLock.notify() }
                    }
            } else {
                alertResult = false
                builder
                    .setPositiveButton(android.R.string.yes) { _: DialogInterface, _: Int ->
                        alertResult = true
                        synchronized(alertLock) { alertLock.notify() }
                    }
                    .setNegativeButton(android.R.string.no) { _: DialogInterface, _: Int ->
                        alertResult = false
                        synchronized(alertLock) { alertLock.notify() }
                    }
            }

            return builder.show()
        }

        companion object {
            const val TAG = "AlertMessageDialogFragment"

            const val TITLE = "title"
            const val MESSAGE = "message"
            const val YES_NO = "yesNo"

            fun newInstance(
                title: String,
                message: String,
                yesNo: Boolean
            ): AlertMessageDialogFragment {
                val args = Bundle()
                args.putString(TITLE, title)
                args.putString(MESSAGE, message)
                args.putBoolean(YES_NO, yesNo)
                val fragment = AlertMessageDialogFragment()
                fragment.arguments = args
                return fragment
            }
        }
    }

    /**
     * Called from native code when the Game Controller Library detects a physical controller
     * connecting or disconnecting, so the UI can react (e.g. auto-hide the virtual overlay).
     */
    @Keep
    @JvmStatic
    fun onControllerConnectionChanged(connected: Boolean) {
        if (connected && EmulationMenuSettings.autoDisableOverlayOnController) {
            EmulationMenuSettings.overlayAutoHidden = true
        }
    }

    @Keep
    @JvmStatic
    fun exitEmulationActivity(resultCode: Int) {
        val emulationActivity = sEmulationActivity.get()
        if (emulationActivity == null) {
            Log.warning("[NativeLibrary] EmulationActivity is null, can't exit.")
            return
        }

        if (resultCode == EmulationErrorDialogFragment.ShutdownRequested) {
            emulationActivity.finish()
            return
        }

        emulationActivity.runOnUiThread {
            EmulationErrorDialogFragment.newInstance(resultCode).showNow(
                emulationActivity.supportFragmentManager,
                EmulationErrorDialogFragment.TAG
            )
        }
    }

    class EmulationErrorDialogFragment : DialogFragment() {
        private lateinit var emulationActivity: FragmentActivity

        override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
            emulationActivity = requireActivity() as FragmentActivity

            var captionId = R.string.loader_error_invalid_format
            val result = requireArguments().getInt(RESULT_CODE)
            if (result == ErrorLoader_ErrorEncrypted) {
                captionId = R.string.loader_error_encrypted
            }
            if (result == ErrorArticDisconnected) {
                captionId = R.string.artic_base
            }

            val alert = MaterialAlertDialogBuilder(requireContext())
                .setTitle(captionId)
                .setMessage(
                    Html.fromHtml(
                        if (result == ErrorArticDisconnected)
                            CitraApplication.appContext.resources.getString(R.string.artic_server_comm_error)
                        else
                            CitraApplication.appContext.resources.getString(R.string.redump_games),
                    Html.FROM_HTML_MODE_LEGACY
                    )
                )
                .setPositiveButton(android.R.string.ok) { _: DialogInterface?, _: Int ->
                    emulationActivity.finish()
                }
                .create()
            alert.show()

            val alertMessage = alert.findViewById<View>(android.R.id.message) as TextView
            alertMessage.movementMethod = LinkMovementMethod.getInstance()

            isCancelable = false
            return alert
        }

        companion object {
            const val TAG = "EmulationErrorDialogFragment"

            const val RESULT_CODE = "resultcode"

            const val Success = 0
            const val ErrorNotInitialized = 1
            const val ErrorGetLoader = 2
            const val ErrorSystemMode = 3
            const val ErrorLoader = 4
            const val ErrorLoader_ErrorEncrypted = 5
            const val ErrorLoader_ErrorInvalidFormat = 6
            const val ErrorLoader_ErrorGBATitle = 7
            const val ErrorSystemFiles = 8
            const val ErrorSavestate = 9
            const val ErrorArticDisconnected = 10
            const val ShutdownRequested = 11
            const val ErrorUnknown = 12

            fun newInstance(resultCode: Int): EmulationErrorDialogFragment {
                val args = Bundle()
                args.putInt(RESULT_CODE, resultCode)
                val fragment = EmulationErrorDialogFragment()
                fragment.arguments = args
                return fragment
            }
        }
    }

    fun setEmulationActivity(emulationActivity: FragmentActivity?) {
        Log.debug("[NativeLibrary] Registering EmulationActivity.")
        sEmulationActivity = WeakReference(emulationActivity)
    }

    fun clearEmulationActivity() {
        Log.debug("[NativeLibrary] Unregistering EmulationActivity.")
        sEmulationActivity.clear()
    }

    private val cameraPermissionLock = Object()
    private var cameraPermissionGranted = false
    const val REQUEST_CODE_NATIVE_CAMERA = 800

    @Keep
    @JvmStatic
    fun requestCameraPermission(): Boolean {
        val emulationActivity = sEmulationActivity.get()
        if (emulationActivity == null) {
            Log.error("[NativeLibrary] EmulationActivity not present")
            return false
        }
        if (ContextCompat.checkSelfPermission(emulationActivity, permission.CAMERA) ==
            PackageManager.PERMISSION_GRANTED
        ) {
            // Permission already granted
            return true
        }
        emulationActivity.requestPermissions(arrayOf(permission.CAMERA), REQUEST_CODE_NATIVE_CAMERA)

        // Wait until result is returned
        synchronized(cameraPermissionLock) {
            try {
                cameraPermissionLock.wait()
            } catch (ignored: InterruptedException) {
            }
        }
        return cameraPermissionGranted
    }

    fun cameraPermissionResult(granted: Boolean) {
        cameraPermissionGranted = granted
        synchronized(cameraPermissionLock) { cameraPermissionLock.notify() }
    }

    private val micPermissionLock = Object()
    private var micPermissionGranted = false
    const val REQUEST_CODE_NATIVE_MIC = 900

    @Keep
    @JvmStatic
    fun requestMicPermission(): Boolean {
        val emulationActivity = sEmulationActivity.get()
        if (emulationActivity == null) {
            Log.error("[NativeLibrary] EmulationActivity not present")
            return false
        }
        if (ContextCompat.checkSelfPermission(emulationActivity, permission.RECORD_AUDIO) ==
            PackageManager.PERMISSION_GRANTED
        ) {
            // Permission already granted
            return true
        }
        emulationActivity.requestPermissions(
            arrayOf(permission.RECORD_AUDIO),
            REQUEST_CODE_NATIVE_MIC
        )

        // Wait until result is returned
        synchronized(micPermissionLock) {
            try {
                micPermissionLock.wait()
            } catch (ignored: InterruptedException) {
            }
        }
        return micPermissionGranted
    }

    fun micPermissionResult(granted: Boolean) {
        micPermissionGranted = granted
        synchronized(micPermissionLock) { micPermissionLock.notify() }
    }

    private val wifiPermissionLock = Object()
    private var wifiPermissionGranted = false
    private var wifiPermissionPending = false
    const val REQUEST_CODE_NATIVE_WIFI = 1000

    private const val WIFI_SCAN_INTERVAL_MS = 30_000L
    private val WIFI_24_GHZ_RANGE = 2400..2499
    private const val WIFI_CHANNEL_0_FREQUENCY = 2407
    private const val WIFI_CHANNEL_14_FREQUENCY = 2484
    private const val WIFI_CHANNEL_WIDTH = 5
    private val WIFI_SECURITY_KEYS = listOf("WPA", "RSN", "WEP", "SAE")
    private var lastWifiScanTime = 0L

    /**
     * Requests the location permission that Android requires to read Wi-Fi scan results, and
     * blocks the calling thread until the user has answered.
     *
     * @return True if the permission is granted.
     */
    @Keep
    @JvmStatic
    fun requestWifiPermission(): Boolean {
        val emulationActivity = sEmulationActivity.get()
        if (emulationActivity == null) {
            Log.error("[NativeLibrary] EmulationActivity not present")
            return false
        }
        if (ContextCompat.checkSelfPermission(emulationActivity, permission.ACCESS_FINE_LOCATION) ==
            PackageManager.PERMISSION_GRANTED
        ) {
            return true
        }

        synchronized(wifiPermissionLock) {
            wifiPermissionPending = true
            emulationActivity.requestPermissions(
                arrayOf(permission.ACCESS_FINE_LOCATION),
                REQUEST_CODE_NATIVE_WIFI
            )
            while (wifiPermissionPending) {
                try {
                    wifiPermissionLock.wait()
                } catch (e: InterruptedException) {
                    Thread.currentThread().interrupt()
                    return false
                }
            }
            return wifiPermissionGranted
        }
    }

    fun wifiPermissionResult(granted: Boolean) {
        synchronized(wifiPermissionLock) {
            wifiPermissionGranted = granted
            wifiPermissionPending = false
            wifiPermissionLock.notifyAll()
        }
    }

    private var virtualAccessPoints: Array<String>? = null

    /**
     * Overrides the access points returned by [scanWifiAccessPoints] with [entries], formatted the
     * same way ("bssid|rssi|channel|security|ssid" per entry). Pass null to go back to reporting
     * the device's real Wi-Fi scan results.
     */
    fun setVirtualAccessPoints(entries: Array<String>?) {
        virtualAccessPoints = entries
    }

    /**
     * Returns the Wi-Fi access points of the 2.4 GHz band seen by the device, including the hidden
     * networks, or the entries set via [setVirtualAccessPoints] when an override is active.
     *
     * Every entry has the form "bssid|rssi|channel|security|ssid", where the security is 0 for an
     * open network, 1 for a secured one and 2 when TKIP is allowed.
     *
     * @return The access points, an empty array when the scan found none, and null when the scan
     * is unavailable because the permission is missing.
     */
    @Keep
    @JvmStatic
    fun scanWifiAccessPoints(): Array<String>? {
        return virtualAccessPoints ?: scanRealWifiAccessPoints()
    }

    /**
     * Called from native code to create a screen texture for a session.
     *
     * @return The id of the texture, or -1 when no engine is available.
     */
    @Keep
    @JvmStatic
    fun createSessionTexture(width: Int, height: Int, secondary: Boolean): Long {
        return EmulationController.current?.createSessionTexture(width, height, secondary) ?: -1L
    }

    /**
     * Called from native code to get the surface of a screen texture of a session.
     *
     * @return The surface, or null when no engine or no texture is available.
     */
    @Keep
    @JvmStatic
    fun getSessionSurface(secondary: Boolean): Surface? {
        return EmulationController.current?.sessionSurface(secondary)
    }

    /**
     * Called from native code to release the screen textures of a session.
     */
    @Keep
    @JvmStatic
    fun releaseSessionTextures() {
        EmulationController.current?.releaseSessionTextures()
    }

    /**
     * Performs the actual device Wi-Fi scan, ignoring any override set via [setVirtualAccessPoints].
     * A new scan is requested at most once every 30 seconds to stay within the scan throttling of
     * Android, the cached results are returned in between. See [scanWifiAccessPoints] for the
     * entry format and return value semantics.
     */
    @Suppress("DEPRECATION")
    fun scanRealWifiAccessPoints(): Array<String>? {
        val context = sEmulationActivity.get() ?: return null
        if (ContextCompat.checkSelfPermission(context, permission.ACCESS_FINE_LOCATION) !=
            PackageManager.PERMISSION_GRANTED
        ) {
            return null
        }
        val wifiManager = context.applicationContext.getSystemService(Context.WIFI_SERVICE)
            as? WifiManager ?: return null

        val now = SystemClock.elapsedRealtime()
        if (now - lastWifiScanTime >= WIFI_SCAN_INTERVAL_MS) {
            lastWifiScanTime = now
            try {
                wifiManager.startScan()
            } catch (e: SecurityException) {
                Log.error("[NativeLibrary] Wi-Fi scan request denied: ${e.message}")
            }
        }

        val results = try {
            wifiManager.scanResults
        } catch (e: SecurityException) {
            Log.error("[NativeLibrary] Wi-Fi scan results denied: ${e.message}")
            return null
        }

        return results
            .filter { it.BSSID != null && it.frequency in WIFI_24_GHZ_RANGE }
            .map {
                val channel = if (it.frequency == WIFI_CHANNEL_14_FREQUENCY) {
                    14
                } else {
                    (it.frequency - WIFI_CHANNEL_0_FREQUENCY) / WIFI_CHANNEL_WIDTH
                }
                val capabilities = it.capabilities.orEmpty()
                val security = when {
                    WIFI_SECURITY_KEYS.none { key -> capabilities.contains(key) } -> 0
                    capabilities.contains("TKIP") -> 2
                    else -> 1
                }
                val ssid = if (it.SSID == "<unknown ssid>") "" else it.SSID.orEmpty()
                "${it.BSSID}|${it.level}|$channel|$security|$ssid"
            }
            .toTypedArray()
    }

    // Notifies that the activity is now in foreground and camera devices can now be reloaded
    external fun reloadCameraDevices()

    external fun loadAmiibo(path: String?): Boolean

    external fun removeAmiibo()

    const val SAVESTATE_SLOT_COUNT = 11
    const val QUICKSAVE_SLOT = 0

    external fun getSavestateInfo(): Array<SaveStateInfo>?

    external fun saveState(slot: Int)

    fun loadStateIfAvailable(slot: Int): Boolean {
        var available = false
        getSavestateInfo()?.forEach {
            if (it.slot == slot){
                available = true
                return@forEach
            }
        }
        if (available) {
            loadState(slot)
            return true
        }
        return false
    }

    external fun loadState(slot: Int)

    /**
     * Logs the Citra version, Android version and, CPU.
     */
    external fun logDeviceInfo()

    @Keep
    @JvmStatic
    fun createFile(directory: String, filename: String): Boolean =
        if (FileUtil.isNativePath(directory)) {
            CitraApplication.documentsTree.createFile(directory, filename)
        } else {
            FileUtil.createFile(directory, filename) != null
        }

    @Keep
    @JvmStatic
    fun createDir(directory: String, directoryName: String): Boolean =
        if (FileUtil.isNativePath(directory)) {
            try {
                CitraApplication.documentsTree.createDir(directory, directoryName)
            } catch (e: Exception) {
                false
            }
        } else {
            FileUtil.createDir(directory, directoryName) != null
        }

    @Keep
    @JvmStatic
    fun openContentUri(path: String, openMode: String): Int =
        if (FileUtil.isNativePath(path)) {
            CitraApplication.documentsTree.openContentUri(path, openMode)
        } else {
            FileUtil.openContentUri(path, openMode)
        }

    @Keep
    @JvmStatic
    fun getFilesName(path: String): Array<String?> =
        if (FileUtil.isNativePath(path)) {
            CitraApplication.documentsTree.getFilesName(path)
        } else {
            FileUtil.getFilesName(path)
        }

    @Keep
    @JvmStatic
    fun getSize(path: String): Long =
        if (FileUtil.isNativePath(path)) {
            CitraApplication.documentsTree.getFileSize(path)
        } else {
            FileUtil.getFileSize(path)
        }

    @Keep
    @JvmStatic
    fun fileExists(path: String): Boolean =
        if (FileUtil.isNativePath(path)) {
            CitraApplication.documentsTree.exists(path)
        } else {
            FileUtil.exists(path)
        }

    @Keep
    @JvmStatic
    fun isDirectory(path: String): Boolean =
        if (FileUtil.isNativePath(path)) {
            CitraApplication.documentsTree.isDirectory(path)
        } else {
            FileUtil.isDirectory(path)
        }

    @Keep
    @JvmStatic
    fun copyFile(
        sourcePath: String,
        destinationParentPath: String,
        destinationFilename: String
    ): Boolean =
        if (FileUtil.isNativePath(sourcePath) &&
            FileUtil.isNativePath(destinationParentPath)
        ) {
            CitraApplication.documentsTree
                .copyFile(sourcePath, destinationParentPath, destinationFilename)
        } else {
            FileUtil.copyFile(
                Uri.parse(sourcePath),
                Uri.parse(destinationParentPath),
                destinationFilename
            )
        }

    @Keep
    @JvmStatic
    fun renameFile(path: String, destinationFilename: String): Boolean =
        if (FileUtil.isNativePath(path)) {
            try {
                CitraApplication.documentsTree.renameFile(path, destinationFilename)
            } catch (e: Exception) {
                false
            }
        } else {
            FileUtil.renameFile(path, destinationFilename)
        }

    @Keep
    @JvmStatic
    fun deleteDocument(path: String): Boolean =
        if (FileUtil.isNativePath(path)) {
            CitraApplication.documentsTree.deleteDocument(path)
        } else {
            FileUtil.deleteDocument(path)
        }

    enum class CoreError {
        ErrorSystemFiles,
        ErrorSavestate,
        ErrorArticDisconnected,
        ErrorUnknown
    }

    enum class InstallStatus {
        Success,
        ErrorFailedToOpenFile,
        ErrorFileNotFound,
        ErrorAborted,
        ErrorInvalid,
        ErrorEncrypted,
        Cancelled
    }

    class CoreErrorDialogFragment : DialogFragment() {
        private var userChosen = false
        override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
            val title = requireArguments().getString(TITLE)
            val message = requireArguments().getString(MESSAGE)
            val canContinue = requireArguments().getBoolean(CAN_CONTINUE)
            val dialog = MaterialAlertDialogBuilder(requireContext())
                .setTitle(title)
                .setMessage(message)
            if (canContinue) {
                dialog.setPositiveButton(R.string.continue_button) { _: DialogInterface?, _: Int ->
                    coreErrorAlertResult = true
                    userChosen = true
                }
            }
            dialog.setNegativeButton(R.string.abort_button) { _: DialogInterface?, _: Int ->
                coreErrorAlertResult = false
                userChosen = true
            }
            return dialog.show()
        }

        override fun onDismiss(dialog: DialogInterface) {
            super.onDismiss(dialog)
            val canContinue = requireArguments().getBoolean(CAN_CONTINUE)
            if (!userChosen) {
                coreErrorAlertResult = canContinue
            }
            synchronized(coreErrorAlertLock) { coreErrorAlertLock.notify() }
        }

        companion object {
            const val TAG = "CoreErrorDialogFragment"

            const val TITLE = "title"
            const val MESSAGE = "message"
            const val CAN_CONTINUE = "canContinue"

            fun newInstance(title: String, message: String, canContinue: Boolean): CoreErrorDialogFragment {
                val frag = CoreErrorDialogFragment()
                val args = Bundle()
                args.putString(TITLE, title)
                args.putString(MESSAGE, message)
                args.putBoolean(CAN_CONTINUE, canContinue)
                frag.arguments = args
                return frag
            }
        }
    }

    @Keep
    class SaveStateInfo {
        var slot = 0
        var time: Date? = null
    }

    /**
     * Button type for use in onTouchEvent
     */
    object ButtonType {
        const val BUTTON_A = 700
        const val BUTTON_B = 701
        const val BUTTON_X = 702
        const val BUTTON_Y = 703
        const val BUTTON_START = 704
        const val BUTTON_SELECT = 705
        const val BUTTON_HOME = 706
        const val BUTTON_ZL = 707
        const val BUTTON_ZR = 708
        const val DPAD_UP = 709
        const val DPAD_DOWN = 710
        const val DPAD_LEFT = 711
        const val DPAD_RIGHT = 712
        const val STICK_LEFT = 713
        const val STICK_LEFT_UP = 714
        const val STICK_LEFT_DOWN = 715
        const val STICK_LEFT_LEFT = 716
        const val STICK_LEFT_RIGHT = 717
        const val STICK_C = 718
        const val STICK_C_UP = 719
        const val STICK_C_DOWN = 720
        const val STICK_C_LEFT = 771
        const val STICK_C_RIGHT = 772
        const val TRIGGER_L = 773
        const val TRIGGER_R = 774
        const val DPAD = 780
        const val BUTTON_DEBUG = 781
        const val BUTTON_GPIO14 = 782
        const val BUTTON_SWAP = 800
    }

    /**
     * Button states
     */
    object ButtonState {
        const val RELEASED = 0
        const val PRESSED = 1
    }
}
