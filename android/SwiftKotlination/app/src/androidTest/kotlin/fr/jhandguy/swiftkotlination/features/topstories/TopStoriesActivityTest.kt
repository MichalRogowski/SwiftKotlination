package fr.jhandguy.swiftkotlination.features.topstories

import android.content.Intent
import androidx.appcompat.widget.AppCompatTextView
import androidx.test.core.app.ApplicationProvider
import androidx.test.espresso.Espresso.onView
import androidx.test.espresso.assertion.ViewAssertions.matches
import androidx.test.espresso.matcher.ViewMatchers.withParent
import androidx.test.espresso.matcher.ViewMatchers.withText
import androidx.test.espresso.matcher.ViewMatchers.withId
import androidx.test.rule.ActivityTestRule
import fr.jhandguy.swiftkotlination.AppMock
import fr.jhandguy.swiftkotlination.R
import fr.jhandguy.swiftkotlination.features.topstories.view.TopStoriesActivity
import fr.jhandguy.swiftkotlination.global.linkedListOf
import fr.jhandguy.swiftkotlination.matchers.RecyclerViewMatcher.Companion.childOfParent
import fr.jhandguy.swiftkotlination.matchers.RecyclerViewMatcher.Companion.withItemCount
import fr.jhandguy.swiftkotlination.network.File
import fr.jhandguy.swiftkotlination.network.NetworkError
import fr.jhandguy.swiftkotlination.network.Request
import fr.jhandguy.swiftkotlination.network.Response
import org.hamcrest.CoreMatchers.allOf
import org.hamcrest.CoreMatchers.instanceOf
import org.junit.Rule
import org.junit.Test

class TopStoriesActivityTest {
    @get:Rule
    val activityRule = ActivityTestRule(TopStoriesActivity::class.java, false, false)

    @Test
    fun testTopStoriesActivity() {
        val application = ApplicationProvider.getApplicationContext<AppMock>()
        application.responses = hashMapOf(
                Pair(Request.FetchTopStories, linkedListOf(
                        Response(File("top_stories", File.Extension.JSON)),
                        Response(File("top_stories", File.Extension.JSON)),
                        Response(File("top_stories", File.Extension.JSON)),
                        Response(error = NetworkError.InvalidResponse())
                )),
                Pair(Request.FetchImage("https://static01.nyt.com/images/2018/08/27/us/28DC-nafta/28DC-nafta-thumbLarge.jpg"), linkedListOf(
                        Response(File("28DC-nafta-thumbLarge", File.Extension.JPG))
                )),
                Pair(Request.FetchImage("https://static01.nyt.com/images/2018/08/27/us/28DC-nafta/28DC-nafta-superJumbo-v2.jpg"), linkedListOf(
                        Response(File("28DC-nafta-superJumbo-v2", File.Extension.JPG))
                )),
                Pair(Request.FetchImage("https://static01.nyt.com/images/2018/08/27/us/27arizpolitics7/27arizpolitics7-thumbLarge.jpg"), linkedListOf(
                        Response(File("27arizpolitics7-thumbLarge", File.Extension.JPG))
                )),
                Pair(Request.FetchImage("https://static01.nyt.com/images/2018/08/27/us/27arizpolitics7/27arizpolitics7-superJumbo-v2.jpg"), linkedListOf(
                        Response(File("27arizpolitics7-superJumbo-v2", File.Extension.JPG))
                ))
        )

        activityRule.launchActivity(Intent())

        onView(instanceOf(AppCompatTextView::class.java))
                .check(matches(withText("Top Stories")))

        onView(withId(R.id.top_stories_list))
                .check(matches(withItemCount(2)))

        onView(allOf(
                withParent(childOfParent(withId(R.id.top_stories_list), 0)),
                withId(R.id.top_stories_item_title)
        ))
                .check(matches(withText("Preliminary Nafta Deal Reached Between U.S. and Mexico")))

        onView(allOf(
                withParent(childOfParent(withId(R.id.top_stories_list), 0)),
                withId(R.id.top_stories_item_byline)
        ))
                .check(matches(withText("By ANA SWANSON and KATIE ROGERS")))
    }
}