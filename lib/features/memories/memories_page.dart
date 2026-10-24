import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/pearl_colors.dart';
import '../../core/widgets/home_button.dart';
import '../../core/widgets/pearl_widgets.dart';
import 'media_logic.dart';
import 'media_widgets.dart';
import 'memories_repository.dart';
import 'memory_dates.dart';

/// Coming up, yearly occasions, and the timeline of past events.
class MemoriesPage extends ConsumerWidget {
  const MemoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events =
        ref.watch(memoryEventsProvider).value ?? const <MemoryEvent>[];
    final cats =
        ref.watch(memoryCategoriesProvider).value ?? const <MemoryCategory>[];
    final catName = {for (final c in cats) c.id: c.name};
    final allMedia =
        ref.watch(memoryMediaProvider).value ?? const <MemoryMediaItem>[];
    MemoryMediaItem? coverFor(MemoryEvent e) =>
        coverOf(e, allMedia.where((m) => m.eventId == e.id).toList());
    final text = Theme.of(context).textTheme;
    final today = DateTime.now();
    final soon = comingUp(events, today);
    final occasions =
        events.where((e) => e.kind == MemoryKind.occasion.name).toList()
          ..sort((a, b) {
            final da = daysLeft(nextDateOf(a, today) ?? today, today);
            final db = daysLeft(nextDateOf(b, today) ?? today, today);
            return da.compareTo(db);
          });
    final groups = timelineGroups(events);

    return Scaffold(
      appBar: AppBar(
        leading: const HomeButton(),
        title: const Text('Memories'),
        actions: [
          PearlIconButton(
            tooltip: 'Search',
            onPressed: () => context.push('/memories/search'),
            icon: Icons.search,
          ),
          const SizedBox(width: 8),
          PearlIconButton(
            tooltip: 'Calendar',
            onPressed: () => context.push('/memories/calendar'),
            icon: Icons.calendar_month_outlined,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add memory',
        onPressed: () => context.push('/memories/add'),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Pearl.margin,
          Pearl.margin,
          Pearl.margin,
          96,
        ),
        children: [
          if (events.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  'Add a birthday, an anniversary or a trip you want to remember.',
                  textAlign: TextAlign.center,
                  style: text.bodySmall,
                ),
              ),
            ),
          if (soon.isNotEmpty) ...[
            const SectionTitle('Coming up'),
            for (final c in soon) ...[
              _ComingUpCard(
                item: c,
                categoryName: catName[c.event.categoryId] ?? '',
              ),
              const SizedBox(height: Pearl.gutter),
            ],
            const SizedBox(height: Pearl.spaceMd),
          ],
          if (occasions.isNotEmpty) ...[
            const SectionTitle('Yearly occasions'),
            Module(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: RowGroup(
                inset: 0,
                children: [
                  for (final e in occasions)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(e.title),
                      subtitle: Text(
                        formatMemoryDate(e),
                        style: text.bodySmall,
                      ),
                      trailing: Text(
                        countdownText(daysLeft(nextDateOf(e, today)!, today)),
                      ),
                      onTap: () => context.push('/memories/event/${e.id}'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: Pearl.spaceLg),
          ],
          if (groups.isNotEmpty) const SectionTitle('Timeline'),
          for (final g in groups) ...[
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 4),
              child: Text(
                g.month == null
                    ? 'Sometime in ${g.year}'
                    : DateFormat('MMMM y').format(DateTime(g.year, g.month!)),
                style: text.bodySmall,
              ),
            ),
            for (final e in g.events)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: switch (coverFor(e)) {
                  final c? => MediaThumb(item: c, size: 48, badge: false),
                  null => null,
                },
                title: Text(e.title),
                subtitle: Text(
                  [formatMemoryDate(e), ?e.place].join(' · '),
                  style: text.bodySmall,
                ),
                trailing: StatusBadge(label: catName[e.categoryId] ?? ''),
                onTap: () => context.push('/memories/event/${e.id}'),
              ),
          ],
        ],
      ),
    );
  }
}

class _ComingUpCard extends StatelessWidget {
  const _ComingUpCard({required this.item, required this.categoryName});

  final ComingUp item;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final n = item.event.kind == MemoryKind.occasion.name
        ? ordinalCount(item.event.year, item.date.year)
        : null;
    return Module(
      onTap: () => context.push('/memories/event/${item.event.id}'),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.event.title, style: text.titleMedium),
                Text(
                  [
                    DateFormat('EEE d MMM').format(item.date),
                    if (n != null) nthLabel(n, categoryName),
                  ].join(' · '),
                  style: text.bodySmall,
                ),
              ],
            ),
          ),
          StatusBadge(
            label: countdownText(item.daysLeft),
            tone: item.daysLeft == 0 ? BadgeTone.champagne : BadgeTone.neutral,
          ),
        ],
      ),
    );
  }
}
