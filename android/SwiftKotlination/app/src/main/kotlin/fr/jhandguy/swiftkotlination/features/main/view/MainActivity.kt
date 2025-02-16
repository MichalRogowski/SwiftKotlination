package fr.jhandguy.swiftkotlination.features.main.view

import android.app.Activity
import fr.jhandguy.swiftkotlination.App
import fr.jhandguy.swiftkotlination.coordinator.CoordinatorInterface
import fr.jhandguy.swiftkotlination.coordinator.factory.CoordinatorFactory

class MainActivity : Activity() {

    private val factory: CoordinatorFactory by lazy { (application as App).factory }
    private val coordinator: CoordinatorInterface by lazy { factory.makeCoordinator(this) }

    override fun onStart() {
        super.onStart()
        coordinator.start()
    }
}