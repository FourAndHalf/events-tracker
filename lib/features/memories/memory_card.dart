import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/pearl_colors.dart';
import '../../core/widgets/pearl_widgets.dart';
import 'media_logic.dart';
import 'media_widgets.dart';
import 'memories_repository.dart';
import 'memory_dates.dart';

/// Dashboard card: the next occasion with its countdown, plus today's
/// "On this day" memory with its thumbnail.
class MemoryCard extends ConsumerWidget {
  const MemoryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events =
        ref.watch(memoryEventsProvider).value ?? const <MemoryEvent>[];
    final media =
        ref.watch(memoryMediaProvider).value ?? const <MemoryMediaItem>[];
    final cats =
        ref.watch(memoryCategoriesProvider).value ?? const <MemoryCategory>[];
    final text = Theme.of(context).textTheme;
    final today = DateTime.now();

    if (events.isEmpty) {
      return Module(
        onTap: () => context.go('/memories'),
        child: Row(
          children: [
            const IconChip(icon: Icons.cake_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Memories: add a birthday or a moment to remember',
                style: text.bodyMedium,
              ),
            ),
            Icon(Icons.chevron_right, color: context.pearl.muted),
          ],
        ),
      );
    }

    final next = comingUp(events, today, withinDays: 366).firstOrNull;
    final memory = onThisDay(events, today).firstOrNull;
    final catName = {for (final c in cats) c.id: c.name};
    final memoryCover = memory == null
        ? null
        : coverOf(memory, media.where((m) => m.eventId == memory.id).toList());

    String? nextSubtitle;
    if (next != null && next.event.kind == MemoryKind.occasion.name) {
      final n = ordinalCount(next.event.year, next.date.year);
      if (n != null) {
        nextSubtitle = nthLabel(n, catName[next.event.categoryId] ?? '');
      }
    }

    return Module(
      onTap: () => context.go('/memories'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModuleHeader(
            title: 'Memories',
            subtitle: 'Coming up',
            trailing: Icon(
              Icons.north_east,
              size: 18,
              color: context.pearl.muted,
            ),
          ),
          if (next != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(next.event.title, style: text.titleMedium),
                      if (nextSubtitle != null)
                        Text(nextSubtitle, style: text.bodySmall),
                    ],
                  ),
                ),
                StatusBadge(
                  label: countdownText(next.daysLeft),
                  tone: next.daysLeft == 0
                      ? BadgeTone.champagne
                      : BadgeTone.neutral,
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text('No occasions coming up', style: text.bodySmall),
          ],
          if (memory != null) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: () => context.push('/memories/event/${memory.id}'),
              child: InnerPanel(
                child: Row(
                  children: [
                    if (memoryCover != null) ...[
                      MediaThumb(item: memoryCover, size: 48, badge: false),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('On this day', style: text.bodySmall),
                          Text(memory.title, style: text.titleSmall),
                          Text(
                            yearsAgo(memory, today) ?? '',
                            style: text.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
