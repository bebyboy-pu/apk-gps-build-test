package com.example.gpstracker

import android.app.Activity
import android.os.Bundle

class MainActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        val textView = android.widget.TextView(this)
        textView.text = "GPS Tracker - Ready!"
        textView.textSize = 20f
        textView.gravity = android.view.Gravity.CENTER
        
        setContentView(textView)
    }
}
