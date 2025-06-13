package com.user.raspi

import android.content.Context
import android.content.pm.PackageManager
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.View
import android.widget.*
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import kotlinx.coroutines.*
import java.io.OutputStream
import java.net.*
import javax.jmdns.JmDNS
import javax.jmdns.ServiceEvent
import javax.jmdns.ServiceListener

class MainActivity : AppCompatActivity() {

    private lateinit var deviceAdapter: DeviceAdapter
    private val devices = mutableListOf<Device>()

    private lateinit var startButton: Button
    private lateinit var stopButton: Button
    private lateinit var statusText: TextView
    private lateinit var timerText: TextView

    private lateinit var scanStatusText: TextView

    private lateinit var scanSubnetButton: Button
    private lateinit var subnetScanList: ListView
    private lateinit var subnetScanAdapter: ArrayAdapter<String>
    private val scannedDevices = mutableListOf<Triple<String, String, Int>>() // hostname, ip, port

    private var jmdns: JmDNS? = null
    private var mdnsJob: Job? = null

    private var isRecording = false
    private var startTime: Long = 0L
    private var timerHandler = Handler(Looper.getMainLooper())
    private var timerRunnable: Runnable? = null

    private val prefsName = "RecordingPrefs"
    private lateinit var scanInstructions: TextView
    private lateinit var addDeviceButton: Button


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        scanStatusText = findViewById(R.id.scanStatusText)


        startButton = findViewById(R.id.startButton)
        stopButton = findViewById(R.id.stopButton)
        statusText = findViewById(R.id.statusText)
        timerText = findViewById(R.id.timerText)

        scanInstructions = findViewById(R.id.scanInstructions)
        addDeviceButton = findViewById(R.id.addDeviceButton)



        scanSubnetButton = findViewById(R.id.scanSubnetButton)
        subnetScanList = findViewById(R.id.subnetScanList)

        // Add this in onCreate() after findViewById calls
        addDeviceButton.visibility = View.GONE
        scanInstructions.visibility = View.GONE

        subnetScanAdapter = ArrayAdapter(this, android.R.layout.simple_list_item_1)
        subnetScanList.adapter = subnetScanAdapter

        val recyclerView = findViewById<RecyclerView>(R.id.deviceRecyclerView)
        recyclerView.layoutManager = LinearLayoutManager(this)


        deviceAdapter = DeviceAdapter(devices) { position ->
            if (isRecording) {
                updateStatus("Cannot remove devices while recording.")
                return@DeviceAdapter
            }

            val device = devices[position]
            AlertDialog.Builder(this)
                .setTitle("Remove Device")
                .setMessage("Do you want to remove ${device.name} (${device.ip}:${device.port})?")
                .setPositiveButton("Yes") { _, _ ->
                    devices.removeAt(position)
                    deviceAdapter.notifyItemRemoved(position)
                    saveDevices()
                    updateStatus("Device removed: ${device.name}")
                }
                .setNegativeButton("Cancel", null)
                .show()
        }

        recyclerView.adapter = deviceAdapter

        loadDevices()
        loadState()

        scanSubnetButton.setOnClickListener {
            startMdnsScan()
        }

        // Replace the existing setOnItemClickListener with just selection handling
        subnetScanList.setOnItemClickListener { _, _, position, _ ->
            // Just show the add button when an item is selected
            addDeviceButton.visibility = View.VISIBLE
        }

// Add new click handler for the Add Device button
        addDeviceButton.setOnClickListener {
            if (isRecording) {
                updateStatus("Cannot add devices while recording is active.")
                return@setOnClickListener
            }

            val selectedPosition = subnetScanList.checkedItemPosition
            if (selectedPosition != ListView.INVALID_POSITION && selectedPosition < scannedDevices.size) {
                val (hostname, ip, port) = scannedDevices[selectedPosition]
                val device = Device(hostname, ip, port)
                devices.add(device)
                deviceAdapter.notifyItemInserted(devices.size - 1)
                saveDevices()
                updateStatus("Added: $hostname ($ip:$port)")

                // Remove from scanned list and UI
                scannedDevices.removeAt(selectedPosition)
                subnetScanAdapter.remove(subnetScanAdapter.getItem(selectedPosition))

                // Hide add button if no more devices
                if (scannedDevices.isEmpty()) {
                    addDeviceButton.visibility = View.GONE
                }
            }
        }



        startButton.setOnClickListener {
            if (!isRecording) {
                devices.forEach { sendCommand("start", it) }
            }
        }

        stopButton.setOnClickListener {
            if (isRecording) {
                devices.forEach { sendCommand("stop", it) }
            }
        }
    }

    private fun startMdnsScan() {
        if (checkSelfPermission(android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION), 1)
            updateStatus("Permission required for mDNS discovery.")
            return
        }
        mdnsJob?.cancel()
        closeJmDNS()

        scannedDevices.clear()
        subnetScanAdapter.clear()
        // Add Tailscale device manually since mDNS won't find it
        // Manually add Tailscale devices (since mDNS won't detect them)

        val manualTailscaleDevices = listOf(
            Triple("Remote RPi", "100.124.247.95", 5000),
            Triple("rasp1", "100.68.119.55", 5001)
        )

        manualTailscaleDevices.forEach { (name, ip, port) ->
            val alreadyAdded = devices.any { it.ip == ip && it.port == port }
            val alreadyScanned = scannedDevices.any { it.second == ip && it.third == port }

            if (!alreadyAdded && !alreadyScanned) {
                scannedDevices.add(Triple(name, ip, port))
                subnetScanAdapter.add("$name ($ip:$port)")
                updateStatus("Manually added Tailscale device: $name ($ip:$port)")
            }
        }


        updateStatus("Starting mDNS discovery...")

        mdnsJob = CoroutineScope(Dispatchers.IO).launch {
            try {
                val ip = getLocalIpAddress()
                if (ip == null) {
                    withContext(Dispatchers.Main) { updateStatus("No local IP found") }
                    return@launch
                }
                jmdns = JmDNS.create(ip)
                val serviceType = "_photo-capture._tcp.local."


                val handler = Handler(Looper.getMainLooper())

                val listener = object : ServiceListener {
                    override fun serviceAdded(event: ServiceEvent) {
                        jmdns?.requestServiceInfo(event.type, event.name, true)
                    }
                    override fun serviceRemoved(event: ServiceEvent) {}
                    override fun serviceResolved(event: ServiceEvent) {
                        val info = event.info
                        val hostname = info.name
                        val ipAddress = info.inet4Addresses.firstOrNull()?.hostAddress ?: return
                        val port = info.port
                        handler.post {
                            val alreadyAdded = devices.any { it.ip == ipAddress && it.port == port }
                            val alreadyScanned = scannedDevices.any { it.second == ipAddress && it.third == port }

                            if (!alreadyAdded && !alreadyScanned) {
                                scannedDevices.add(Triple(hostname, ipAddress, port))
                                subnetScanAdapter.add("$hostname ($ipAddress:$port)")
                                updateStatus("Discovered: $hostname ($ipAddress:$port)")
                            }

                        }
                    }
                }

                jmdns?.addServiceListener(serviceType, listener)

                delay(5000)

                // In your startMdnsScan() function, replace this section:
                withContext(Dispatchers.Main) {
                    if (scannedDevices.isEmpty()) {
                        scanStatusText.text = "No devices found"
                    } else {
                        scanStatusText.text = "Click to add device"
                        // Show instructions when devices are found
                        scanInstructions.visibility = View.VISIBLE
                    }
                    updateStatus("mDNS discovery complete.")
                }

                jmdns?.removeServiceListener(serviceType, listener)
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    updateStatus("mDNS scan error: ${e.message}")
                }
            }
        }
    }

    private fun closeJmDNS() {
        try {
            jmdns?.close()
        } catch (_: Exception) {
        }
        jmdns = null
    }

    private fun getLocalIpAddress(): InetAddress? {
        try {
            val interfaces = NetworkInterface.getNetworkInterfaces()
            for (intf in interfaces) {
                if (!intf.isUp || intf.isLoopback) continue
                for (addr in intf.inetAddresses) {
                    if (!addr.isLoopbackAddress && addr is Inet4Address) {
                        return addr
                    }
                }
            }
        } catch (_: Exception) {
        }
        return null
    }

    private fun sendCommand(command: String, device: Device) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                Socket(device.ip, device.port).use { socket ->
                    val output: OutputStream = socket.getOutputStream()
                    output.write(command.toByteArray())
                    output.flush()

                    val input = socket.getInputStream()
                    val buffer = ByteArray(1024)
                    val bytesRead = input.read(buffer)
                    val response = String(buffer, 0, bytesRead)

                    runOnUiThread {
                        // Normalize and update device status
                        device.status = when {
                            command == "start" && response.contains("started", ignoreCase = true) -> "Started"
                            command == "stop" && response.contains("stopped", ignoreCase = true) -> "Stopped"
                            else -> response
                        }

                        // Check all devices for consistent state
                        val allStarted = devices.isNotEmpty() && devices.all { it.status == "Started" }
                        val allStopped = devices.isNotEmpty() && devices.all { it.status == "Stopped" }

                        if (allStarted && !isRecording) {
                            isRecording = true
                            startTime = System.currentTimeMillis()
                            startTimer()
                            startButton.isEnabled = false
                            scanSubnetButton.isEnabled = false
                            updateStatus("All devices started")
                        } else if (allStopped && isRecording) {
                            isRecording = false
                            stopTimer()
                            startButton.isEnabled = true
                            scanSubnetButton.isEnabled = true
                            updateStatus("All devices stopped")
                        }

                        deviceAdapter.notifyDataSetChanged()
                        saveDevices() // ✅ Persist device statuses
                        saveState()
                    }
                }
            } catch (e: Exception) {
                runOnUiThread {
                    device.status = "Error: ${e.message}"
                    deviceAdapter.notifyDataSetChanged()
                    saveDevices() // ✅ Save error state as well
                }
            }
        }
    }


    private fun startTimer() {
        scanSubnetButton.isEnabled = false
        subnetScanList.isEnabled = false

        timerRunnable = object : Runnable {
            override fun run() {
                val elapsed = System.currentTimeMillis() - startTime
                val seconds = elapsed / 1000
                val h = seconds / 3600
                val m = (seconds % 3600) / 60
                val s = seconds % 60
                timerText.text = String.format("%02d:%02d:%02d", h, m, s)
                timerHandler.postDelayed(this, 1000)
            }
        }
        timerHandler.post(timerRunnable!!)
    }


    private fun stopTimer() {
        scanSubnetButton.isEnabled = true
        subnetScanList.isEnabled = true

        timerHandler.removeCallbacks(timerRunnable!!)
        timerText.text = "00:00:00"
    }


    private fun updateStatus(message: String) {
        statusText.text = message
    }

    private fun saveState() {
        val prefs = getSharedPreferences(prefsName, Context.MODE_PRIVATE)
        prefs.edit().apply {
            putBoolean("isRecording", isRecording)
            putLong("startTime", startTime)
            putString("statusText", statusText.text.toString())
            apply()
        }
    }

    private fun loadState() {
        val prefs = getSharedPreferences(prefsName, Context.MODE_PRIVATE)
        isRecording = prefs.getBoolean("isRecording", false)
        startTime = prefs.getLong("startTime", 0L)
        statusText.text = prefs.getString("statusText", "Status: Not connected")

        if (isRecording) {
            val elapsed = System.currentTimeMillis() - startTime
            if (elapsed > 0) {
                startTimer()
                startButton.isEnabled = false
                scanSubnetButton.isEnabled = false
                subnetScanList.isEnabled = false
            }
        }

    }

    private fun saveDevices() {
        val json = Gson().toJson(devices)
        getSharedPreferences(prefsName, Context.MODE_PRIVATE)
            .edit().putString("deviceList", json).apply()
    }

    private fun loadDevices() {
        val prefs = getSharedPreferences(prefsName, Context.MODE_PRIVATE)
        val json = prefs.getString("deviceList", null)
        if (json != null) {
            val type = object : TypeToken<MutableList<Device>>() {}.type
            val savedDevices: MutableList<Device> = Gson().fromJson(json, type)
            devices.addAll(savedDevices)
        }
    }

    override fun onStop() {
        super.onStop()
        saveState()
    }

    override fun onDestroy() {
        super.onDestroy()
        closeJmDNS()
        mdnsJob?.cancel()
        saveState()
    }
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == 1 && grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            updateStatus("Location permission granted. Starting scan...")
            startMdnsScan()
        } else {
            updateStatus("Location permission denied. Cannot scan.")
        }
    }

}