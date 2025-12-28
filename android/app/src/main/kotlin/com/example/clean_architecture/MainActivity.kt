package com.example.cleanArchitecture  // Mantén tu paquete exacto

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import com.google.android.gms.maps.MapsInitializer
import com.google.android.gms.maps.MapsInitializer.Renderer
import com.google.android.gms.maps.OnMapsSdkInitializedCallback

class MainActivity: FlutterActivity(), OnMapsSdkInitializedCallback {

  override fun onCreate(savedInstanceState: Bundle?) {
    MapsInitializer.initialize(applicationContext, Renderer.LATEST, this)
    super.onCreate(savedInstanceState)
  }

  override fun onMapsSdkInitialized(renderer: Renderer) {
    android.util.Log.d("GoogleMaps", "Renderer inicializado: $renderer")
  }
}