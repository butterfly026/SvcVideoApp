package com.video.community

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import android.text.TextUtils
import android.widget.Toast
import androidx.core.content.FileProvider
import com.king.zxing.util.CodeUtils
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.File
import java.io.IOException
import java.io.InputStreamReader
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {

    companion object {
        const val REQUEST_CODE_PHOTO = 0x02
        const val REQUEST_CODE_READ_EXTERNAL_STORAGE = 0x99
        const val REQUEST_CODE_INSTALL_APK = 0x01
    }

    private var file: File? = null
    private var uri: Uri? = null
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.video.community")

        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "parseQRCode" -> {
                    val pickIntent =
                        Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI)
                    pickIntent.setDataAndType(
                        MediaStore.Images.Media.EXTERNAL_CONTENT_URI, "image/*"
                    )
                    startActivityForResult(pickIntent, REQUEST_CODE_PHOTO)
                }
                "installApk" -> {
                    installApk(this, call.arguments as String, REQUEST_CODE_INSTALL_APK)
                }
            }
        }

    }

    fun installApk(context: Activity, filePath: String?, requestCode: Int) {
        if (TextUtils.isEmpty(filePath)) {
            Toast.makeText(context, "安装路径出错", Toast.LENGTH_SHORT).show()
            return
        }
        file = File(filePath)
        uri = Uri.fromFile(file)
        if (uri == null) {
            throw RuntimeException("安装路径不正确")
        }
        if (Build.VERSION.SDK_INT >= 24) {
            uri = FileProvider.getUriForFile(
                context, "com.video.community.fileProvider", file!!
            )
        }
        val intent = Intent()
        if (Build.VERSION.SDK_INT < 14) {
            intent.action = Intent.ACTION_VIEW
            intent.setDataAndType(uri, "application/vnd.android.package-archive")
        } else if (Build.VERSION.SDK_INT < 16) {
            intent.action = Intent.ACTION_INSTALL_PACKAGE
            intent.setDataAndType(uri, "application/vnd.android.package-archive")
            intent.putExtra(Intent.EXTRA_RETURN_RESULT, true)
            intent.putExtra(Intent.EXTRA_NOT_UNKNOWN_SOURCE, true)
            intent.putExtra(Intent.EXTRA_ALLOW_REPLACE, true)
        } else if (Build.VERSION.SDK_INT < 24) {
            intent.action = Intent.ACTION_INSTALL_PACKAGE
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            intent.setDataAndType(uri, "application/vnd.android.package-archive")
            intent.putExtra(Intent.EXTRA_RETURN_RESULT, true)
            intent.putExtra(Intent.EXTRA_NOT_UNKNOWN_SOURCE, true)
            intent.putExtra(Intent.EXTRA_ALLOW_REPLACE, true)
        } else {
            intent.action = Intent.ACTION_INSTALL_PACKAGE
            intent.data = uri
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            intent.putExtra(Intent.EXTRA_RETURN_RESULT, true)
            intent.putExtra(Intent.EXTRA_NOT_UNKNOWN_SOURCE, true)
            intent.putExtra(Intent.EXTRA_ALLOW_REPLACE, true)
        }
        try {
            context.startActivityForResult(intent, requestCode)
        } catch (e: java.lang.Exception) {
            Log.e("TAG", e.message!!)
        }
    }

    private fun checkDangerousProps(): Boolean {
        val properties = mapOf(
            "ro.debuggable" to "1", // Debugging should be off; 1 indicates it's on.
            "ro.secure" to "0" // Device should be secure; 0 indicates it's not.
        )

        properties.forEach { (prop, expectedValue) ->
            try {
                val process = Runtime.getRuntime().exec("getprop $prop")
                val reader = BufferedReader(InputStreamReader(process.inputStream))
                val value = reader.readLine()
                if (value == expectedValue) {
                    return true // A dangerous property is found as expected.
                }
            } catch (e: IOException) {
                e.printStackTrace()
            }
        }
        return false
    }

    private val executor = Executors.newSingleThreadExecutor()

    private fun parsePhoto(data: Intent) {
        try {
            val bitmap = MediaStore.Images.Media.getBitmap(
                contentResolver, data.data
            )
            // 异步解析
            asyncThread {
                val result = CodeUtils.parseCode(bitmap)
                runOnUiThread {
                    val dataMap: MutableMap<String, Any> = HashMap()
                    dataMap["code"] = 200
                    dataMap["error"] = ""
                    dataMap["data"] = result
                    methodChannel?.invokeMethod("onQRCodeResponse", dataMap)
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
            val dataMap: MutableMap<String, Any> = HashMap()
            dataMap["code"] = 404
            dataMap["error"] = ""
            dataMap["data"] = ""
            methodChannel?.invokeMethod("onQRCodeResponse", dataMap)
        }
    }

    private fun asyncThread(runnable: Runnable) {
        executor.execute(runnable)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode == Activity.RESULT_OK && data != null) {
            if (requestCode == REQUEST_CODE_PHOTO) {
                parsePhoto(data)
            } else if (requestCode == REQUEST_CODE_INSTALL_APK) {
                installApk();
            }
        }
    }

    private fun installApk() {
        val intent = Intent(Intent.ACTION_VIEW)
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) {
            intent.setDataAndType(uri, "application/vnd.android.package-archive")
        } else {
            // Android7.0之后获取uri要用contentProvider
            val apkUri =
                FileProvider.getUriForFile(this, "com.video.community.fileProvider", file!!)
            // 添加这一句表示对目标应用临时授权该Uri所代表的文件
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            intent.setDataAndType(apkUri, "application/vnd.android.package-archive")
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        baseContext.startActivity(intent)
    }

   

}
