import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
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
      return AuraCard(
        onTap: () => context.push('/memories'),
        child: Row(
          children: [
            const IconBadge(icon: Icons.cake_outlined, color: Aura.memory),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Memories: add a birthday or a moment to remember',
                style: text.bodyMedium,
              ),
            ),
            const Icon(Icons.chevron_right, color: Aura.textSecondary),
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

    return AuraCard(
      onTap: () => context.push('/memories'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: Overline('Memories', color: Aura.memory)),
              const Icon(Icons.chevron_right, color: Aura.textSecondary),
            ],
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
                StatusPill(
                  label: countdownText(next.daysLeft),
                  color: Aura.memory,
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text('No occasions coming up', style: text.bodySmall),
          ],
          if (memory != null) ...[
            const Divider(color: Aura.rim, height: 24),
            InkWell(
              onTap: () => context.push('/memories/event/${memory.id}'),
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
                        const Overline('On this day'),
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
          ],
        ],
      ),
    );
  }
}
