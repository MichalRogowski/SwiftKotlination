package fr.jhandguy.swiftkotlination.features.topstories.view

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import dagger.Module
import dagger.Provides
import dagger.android.AndroidInjection
import fr.jhandguy.swiftkotlination.features.topstories.viewmodel.TopStoriesViewModel
import fr.jhandguy.swiftkotlination.navigation.Coordinator
import fr.jhandguy.swiftkotlination.navigation.Navigator
import org.jetbrains.anko.setContentView
import javax.inject.Inject

@Module
object TopStoriesActivityModule {
    @Provides
    @JvmStatic
    fun provideViewModel(coordinator: Coordinator) = TopStoriesViewModel(coordinator)
}

class TopStoriesActivity: AppCompatActivity() {

    @Inject
    lateinit var navigator: Navigator

    @Inject
    lateinit var viewModel: TopStoriesViewModel

    private var adapter = TopStoriesAdapter()

    override fun onCreate(savedInstanceState: Bundle?) {
        AndroidInjection.inject(this)
        super.onCreate(savedInstanceState)

        title = "Top Stories"

        navigator.activity = this

        TopStoriesView(adapter).setContentView(this)
    }

    override fun onStart() {
        super.onStart()

        viewModel
                .topStories
                .subscribe({
                    adapter.topStories = it
                    adapter.notifyDataSetChanged()
                }, {
                    print("Ooops")
                })
    }
}