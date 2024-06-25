package com.video.community

import android.app.Application
import com.umeng.commonsdk.UMConfigure


class MyApp : Application() {
    override fun onCreate() {
        super.onCreate()
        UMConfigure.setLogEnabled(true)
        UMConfigure.preInit(this, "65c316ae95b14f599d24b346", "Umeng")
    }
}