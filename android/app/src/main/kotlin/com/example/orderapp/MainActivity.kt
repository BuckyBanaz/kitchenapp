package com.kitchen.jigisha

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.content.pm.PackageManager
import android.os.Build
import java.security.MessageDigest

class MainActivity : FlutterActivity() {


    private val expectedSha256Hex = "35:8A:82:76:BE:6F:33:1B:A0:A4:B5:78:83:0B:A3:1D:6E:2A:59:AE:F6:FC:95:A4:C6:A4:93:D1:55:8E:1F:0E"

    private fun currentCertSha256Hex(): String? {
        return try {
            val pm = packageManager
            val pkg = packageName

            val certBytes: ByteArray? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                // API 28+
                val pi = pm.getPackageInfo(pkg, PackageManager.GET_SIGNING_CERTIFICATES)
                // signingInfo ya array null ho sakta hai → safe calls + getOrNull
                pi.signingInfo
                    ?.apkContentsSigners
                    ?.getOrNull(0)
                    ?.toByteArray()
            } else {
                // Legacy path
                @Suppress("DEPRECATION")
                val pi = pm.getPackageInfo(pkg, PackageManager.GET_SIGNATURES)
                @Suppress("DEPRECATION")
                pi.signatures
                    ?.getOrNull(0)
                    ?.toByteArray()
            }

            if (certBytes == null) return null

            val sha = MessageDigest.getInstance("SHA-256").digest(certBytes)
            sha.joinToString("") { "%02x".format(it) }
        } catch (_: Exception) {
            null
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val actual = currentCertSha256Hex()
        if (actual == null || !actual.equals(expectedSha256Hex, ignoreCase = true)) {

            finish()
            android.os.Process.killProcess(android.os.Process.myPid())
        }
    }
}
