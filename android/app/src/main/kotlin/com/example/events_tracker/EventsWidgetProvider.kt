package com.example.events_tracker

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Home-screen widget with three buttons. Each opens the app on a link like
 * events://sleep-toggle, which the Flutter side turns into the action. The
 * labels under the buttons are written by the app (see widget_bridge.dart).
 */
class EventsWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_events).apply {
                setTextViewText(R.id.sleep_status, widgetData.getString("sleep_label", "Tap to start"))
                setTextViewText(R.id.read_status, widgetData.getString("read_label", "Tap to start"))
                setOnClickPendingIntent(R.id.btn_sleep, launch(context, "events://sleep-toggle"))
                setOnClickPendingIntent(R.id.btn_read, launch(context, "events://read-toggle"))
                setOnClickPendingIntent(R.id.btn_expense, launch(context, "events://add-expense"))
            }
            appWidgetManager.updateAppWidget(id, views)
        }
    }

    private fun launch(context: Context, uri: String) =
        HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse(uri))
}
