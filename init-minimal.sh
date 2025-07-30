#!/data/data/com.termux/files/usr/bin/bash

echo "📦 กำลังติดตั้งโปรเจกต์ GPS Tracker แบบ Minimal..."

rm -rf app .github shared-test spotless screenshots CODEOWNERS CONTRIBUTING.md renovate.json

mkdir -p app/src/main/java/com/example/gpstracker
mkdir -p app/src/main/res/layout
mkdir -p .github/workflows

# AndroidManifest.xml
cat > app/src/main/AndroidManifest.xml << 'EOL'
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.gpstracker">

    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:allowBackup="true"
        android:label="GPS Tracker"
        android:supportsRtl="true"
        android:theme="@android:style/Theme.Material.Light.NoActionBar">
        <activity android:name=".MainActivity">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
EOL

# MainActivity.java
cat > app/src/main/java/com/example/gpstracker/MainActivity.java << 'EOL'
package com.example.gpstracker;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.widget.TextView;
import androidx.core.app.ActivityCompat;

public class MainActivity extends Activity implements LocationListener {

    TextView locationText;
    LocationManager locationManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        locationText = new TextView(this);
        setContentView(locationText);

        locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, 1);
            return;
        }
        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 5000, 0, this);
    }

    @Override
    public void onLocationChanged(Location location) {
        locationText.setText("Lat: " + location.getLatitude() + "\nLng: " + location.getLongitude());
    }
}
EOL

# build.gradle
cat > app/build.gradle << 'EOL'
plugins {
    id 'com.android.application'
}

android {
    compileSdk 33
    defaultConfig {
        applicationId "com.example.gpstracker"
        minSdk 21
        targetSdk 33
        versionCode 1
        versionName "1.0"
    }
    buildTypes {
        release {
            minifyEnabled false
        }
    }
}

dependencies {}
EOL

# settings.gradle
cat > settings.gradle << 'EOL'
include ':app'
rootProject.name = "gps-tracker"
EOL

# .github/workflows/android.yml
cat > .github/workflows/android.yml << 'EOL'
name: Android CI

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Setup JDK
      uses: actions/setup-java@v4
      with:
        distribution: 'zulu'
        java-version: '17'
    - name: Grant execute permission
      run: chmod +x ./gradlew
    - name: Build Debug APK
      run: ./gradlew assembleDebug
EOL

chmod +x gradlew
echo "✅ เสร็จสิ้น! พร้อม push ขึ้น GitHub ได้เลย"
