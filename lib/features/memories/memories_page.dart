import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
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
      appBar: AppBar(title: const Text('Memories')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/memories/add'),
        backgroundColor: Aura.memory,
        foregroundColor: Aura.canvas,
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Aura.margin,
          Aura.margin,
          Aura.margin,
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
            const Overline('Coming up', color: Aura.memory),
            const SizedBox(height: 8),
            for (final c in soon) ...[
              _ComingUpCard(
                item: c,
                categoryName: catName[c.event.categoryId] ?? '',
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 16),
          ],
          if (occasions.isNotEmpty) ...[
            const Overline('Yearly occasions'),
            const SizedBox(height: 4),
            for (final e in occasions)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(e.title),
                subtitle: Text(formatMemoryDate(e), style: text.bodySmall),
                trailing: Text(
                  countdownText(daysLeft(nextDateOf(e, today)!, today)),
                  style: text.labelMedium,
                ),
                onTap: () => context.push('/memories/event/${e.id}'),
              ),
            const SizedBox(height: 16),
          ],
          if (groups.isNotEmpty) const Overline('Timeline'),
          for (final g in groups) ...[
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 4),
              child: Text(
                g.month == null
                    ? 'Sometime in ${g.year}'
                    : DateFormat('MMMM y').format(DateTime(g.year, g.month!)),
                style: text.titleMedium,
              ),
            ),
            for (final e in g.events)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(e.title),
                subtitle: Text(
                  [formatMemoryDate(e), ?e.place].join(' · '),
                  style: text.bodySmall,
                ),
                trailing: StatusPill(
                  label: catName[e.categoryId] ?? '',
                  color: Aura.memory,
                ),
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
    return AuraCard(
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
          StatusPill(label: countdownText(item.daysLeft), color: Aura.memory),
        ],
      ),
    );
  }
}
