package com.example.netshift

import android.content.ComponentName
import android.content.Intent
import android.content.ServiceConnection
import android.net.VpnService
import android.net.TrafficStats
import android.os.Bundle
import android.os.IBinder
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import android.app.*
import android.content.*
import android.content.pm.PackageManager
import android.os.*
import android.Manifest
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.Log
import com.example.netshift.ForegroundService


class MainActivity : FlutterActivity() {
    private val vpnStatusChannel = "com.netshift.dnschanger/netdnsStatus"
    private val vpnControlChannel = "com.netshift.dnschanger/netdns"
    private val dataUsageChannel = "com.netshift.dnschanger/dataUsage"
    private val timerChannel = "com.netshift.dnschanger/timer"
    private val flutterToast = "com.netshift.dnschanger/toast"
    companion object {


        var methodChannel: MethodChannel? = null
    }
    private var eventSink: EventChannel.EventSink? = null
    private val REQUEST_CODE_NOTIF = 1001

    private var vpnService: NetShiftService? = null
    private var isBound = false
    private val defaultDns1 = "78.157.42.100"
    private val defaultDns2 = "78.157.42.101"
    private var initialDownloadBytes: Long = 0
    private var initialUploadBytes: Long = 0
    private var isServiceRunning: Boolean = false
    
    private var receiver: BroadcastReceiver? = null

    private val connection = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
            val binder = service as NetShiftService.LocalBinder
            vpnService = binder.getService()
            vpnService?.setStatusListener { status ->
                eventSink?.success(status)
            }
            isBound = true
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            vpnService = null
            isBound = false
        }
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requestNotificationPermission()
        // disableBatteryOptimization()
        methodChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, vpnControlChannel)
        methodChannel!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "prepareDns" -> prepareVpn(result)
                "startDns" -> {
                    
                    val dns1 = call.argument<String>("dns1") ?: defaultDns1
                    val dns2 = call.argument<String>("dns2") ?: defaultDns2
                    val disallowedApps = call.argument<List<String>>("disallowedApps") ?: listOf()
                    vpnService?.setDnsServers(listOf(dns1, dns2))
                    vpnService?.startDns(disallowedApps)
                    initialDownloadBytes = TrafficStats.getTotalRxBytes()
                    initialUploadBytes = TrafficStats.getTotalTxBytes()
                    isServiceRunning = true
                    result.success("NetShift started with DNS: $dns1, $dns2")
                }
                "stopDns" -> {
                    vpnService?.stopDns()
                    initialDownloadBytes = 0
                    initialUploadBytes = 0
                    isServiceRunning = false
                    result.success("NetShift stopped")
                }
                "startService" -> {
                    val contentText = call.argument<String>("contentText") ?: "Foreground Service Running"
                    startForegroundService(contentText)
                    result.success("Service Started")
                }
                "stopService" -> {
                    stopForegroundService()
                    result.success("Service Stopped")
                }
                "getServiceStatus" -> {
                    val status = ForegroundService.isServiceRunning
                    result.success(status) 
                }
                
                else -> result.notImplemented()
            }
        }
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, flutterToast).setMethodCallHandler {call, result ->
        when(call.method) {
            "showToast" -> {
                val message = call.argument<String>("message")
                Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
                result.success(message)
            }
        }
    
    }
        EventChannel(flutterEngine!!.dartExecutor, vpnStatusChannel).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })

        bindVpnService()
    }
    
    private fun prepareVpn(result: MethodChannel.Result) {
        val intent = VpnService.prepare(this)
        if (intent != null) {
            startActivityForResult(intent, 0)
            result.success("NetShift preparation started")
        } else {
            result.success("NetShift already prepared")
        }
    }
    override fun onPause() {
        super.onPause()
        if (receiver != null) {
            unregisterReceiver(receiver)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 0) {
            if (resultCode == RESULT_OK) {
                Toast.makeText(this, "NetShift permission granted", Toast.LENGTH_SHORT).show()
            } else {
                Toast.makeText(this, "NetShift permission denied", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun bindVpnService() {
        val intent = Intent(this, NetShiftService::class.java)
        bindService(intent, connection, BIND_AUTO_CREATE)
    }

    override fun onDestroy() {
        super.onDestroy()
        if (isBound) {
            unbindService(connection)
            isBound = false
        }
    }
    fun sendMessageToFlutter(dataUsage: Map<String, Long>) {
        val intent = Intent("DATA_USAGE_UPDATE")
        intent.putExtra("download", dataUsage["download"] ?: 0L)
        intent.putExtra("upload", dataUsage["upload"] ?: 0L)
        sendBroadcast(intent)
    }
    
    private fun startForegroundService(contentText: String) {
        val serviceIntent = Intent(this, ForegroundService::class.java).apply {
            putExtra("contentText", contentText)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ContextCompat.startForegroundService(this, serviceIntent)
        } else {
            startService(serviceIntent)
        }
    }

    private fun stopForegroundService() {
        val serviceIntent = Intent(this, ForegroundService::class.java)
        stopService(serviceIntent)
    }
    // fun getDataUsage(): Map<String, Long> {
    //     if (isServiceRunning) {
    //         val currentDownloadBytes = TrafficStats.getTotalRxBytes()
    //         val currentUploadBytes = TrafficStats.getTotalTxBytes()
            
    //         val downloadBytes = currentDownloadBytes - initialDownloadBytes
    //         val uploadBytes = currentUploadBytes - initialUploadBytes
            
    //         return mapOf(
    //             "download" to downloadBytes,
    //             "upload" to uploadBytes
    //         )
    //     } else {
    //         return mapOf(
    //             "download" to 0L,
    //             "upload" to 0L
    //         )
    //     }
    // }
    
    private fun requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) { 
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS)
                != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.POST_NOTIFICATIONS), REQUEST_CODE_NOTIF)
            }
        }
    }

    // private fun disableBatteryOptimization() {
    //     val pm = getSystemService(PowerManager::class.java)
    //     val packageName = packageName
    //     if (!pm.isIgnoringBatteryOptimizations(packageName)) {
    //         val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
    //         intent.data = android.net.Uri.parse("package:$packageName")
    //         intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
    //         startActivity(intent)
    //     }
    // }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_CODE_NOTIF && grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            
        }
    }
}