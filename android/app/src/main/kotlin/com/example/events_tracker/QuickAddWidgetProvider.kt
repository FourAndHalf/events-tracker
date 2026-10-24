package com.example.events_tracker

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * 2x1 home-screen widget with two buttons (QuickAddWidget2x2Provider stacks them). Each opens the app on a link like
 * events://add-sleep, which the Flutter side turns into the action.
 */
open class QuickAddWidgetProvider : HomeWidgetProvider() {
    protected open val layout = R.layout.widget_quick_add

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, layout).apply {
                setOnClickPendingIntent(R.id.btn_sleep, launch(context, "events://add-sleep"))
                setOnClickPendingIntent(R.id.btn_read, launch(context, "events://add-read"))
            }
            appWidgetManager.updateAppWidget(id, views)
        }
    }

    private fun launch(context: Context, uri: String) =
        HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse(uri))
}
