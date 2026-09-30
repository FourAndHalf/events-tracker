package com.example.events_tracker

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Home-screen widget: sleep/reading/spend stats plus three tappable tiles.
 * Each tile opens the app on a link like events://sleep-toggle, which the
 * Flutter side turns into the action. All text is written by the app (see
 * widget_bridge.dart).
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
                setTextViewText(R.id.sleep_percent, widgetData.getString("sleep_percent", "0%"))
                setTextViewText(R.id.sleep_hours_label, widgetData.getString("sleep_hours_label", "0h 00m"))
                setTextViewText(R.id.sleep_state, widgetData.getString("sleep_state", "Awake"))
                setTextViewText(R.id.pages_percent, widgetData.getString("pages_percent", "0%"))
                setTextViewText(R.id.pages_label, widgetData.getString("pages_label", "0/0p"))
                setTextViewText(R.id.read_state, widgetData.getString("read_state", "Idle"))
                setTextViewText(R.id.spend_status, widgetData.getString("spend_status", "On Track"))
                setTextViewText(R.id.spend_label, widgetData.getString("spend_label", "₹0.00 spent today"))
                setTextViewText(R.id.spend_percent, widgetData.getString("spend_percent", "0%"))
                setTextViewText(R.id.spend_of_budget_label, widgetData.getString("spend_of_budget_label", "no budget set"))
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
