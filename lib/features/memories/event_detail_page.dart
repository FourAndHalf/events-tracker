import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import 'memories_repository.dart';
import 'memory_dates.dart';

class EventDetailPage extends ConsumerWidget {
  const EventDetailPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final e = (ref.watch(memoryEventsProvider).value ?? const <MemoryEvent>[])
        .where((x) => x.id == id)
        .firstOrNull;
    if (e == null) {
      return Scaffold(appBar: AppBar(), body: const SizedBox.shrink());
    }
    final catName =
        (ref.watch(memoryCategoriesProvider).value ?? const <MemoryCategory>[])
            .where((c) => c.id == e.categoryId)
            .firstOrNull
            ?.name ??
        '';
    final text = Theme.of(context).textTheme;
    final today = DateTime.now();
    final occasion = e.kind == MemoryKind.occasion.name;

    String? headline;
    if (occasion) {
      final next = nextDateOf(e, today);
      if (next != null) {
        final n = ordinalCount(e.year, next.year);
        headline =
            '${countdownText(daysLeft(next, today))}'
            '${n == null ? '' : ' · ${nthLabel(n, catName)}'}'
            ' (${DateFormat('EEE d MMM y').format(next)})';
      }
    } else {
      final upcoming = nextDateOf(e, today);
      headline = upcoming != null
          ? countdownText(daysLeft(upcoming, today))
          : yearsAgo(e, today);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory'),
        actions: [
          IconButton(
            tooltip: 'Edit',
            onPressed: () => context.push('/memories/edit/${e.id}'),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Delete',
            onPressed: () => _delete(context, ref, e),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Aura.margin),
        children: [
          Text(e.title, style: text.headlineSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              StatusPill(label: catName, color: Aura.memory),
              StatusPill(
                label: occasion ? 'Every year' : 'One-time',
                color: Aura.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          AuraCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Overline('When', color: Aura.memory),
                const SizedBox(height: 8),
                Text(formatMemoryDate(e), style: text.titleLarge),
                if (headline != null) Text(headline, style: text.bodyMedium),
              ],
            ),
          ),
          if (e.person != null || e.place != null) ...[
            const SizedBox(height: 12),
            if (e.person != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.person_outline),
                title: Text(e.person!),
              ),
            if (e.place != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.place_outlined),
                title: Text(e.place!),
              ),
          ],
          if (e.description != null) ...[
            const SizedBox(height: 12),
            Text(e.description!, style: text.bodyMedium),
          ],
        ],
      ),
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    MemoryEvent e,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this memory?'),
        content: const Text('Its photos and videos are deleted too.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(memoriesRepositoryProvider).deleteEvent(e.id);
    if (context.mounted) context.pop();
  }
}
