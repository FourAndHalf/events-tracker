import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import 'media_logic.dart';
import 'media_storage.dart';
import 'media_widgets.dart';
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
    final media =
        (ref.watch(memoryMediaProvider).value ?? const <MemoryMediaItem>[])
            .where((m) => m.eventId == id)
            .toList();
    final cover = coverOf(e, media);
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
          const SizedBox(height: 24),
          const Overline('Photos and videos', color: Aura.memory),
          const SizedBox(height: 8),
          MediaPickButtons(
            onPicked: (files) async {
              await importMedia(
                repo: ref.read(memoriesRepositoryProvider),
                root: await memoriesRoot(),
                eventId: e.id,
                files: files,
              );
            },
          ),
          const SizedBox(height: 12),
          if (media.isEmpty)
            Text('Nothing attached yet.', style: text.bodySmall),
          GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (var i = 0; i < media.length; i++)
                GestureDetector(
                  onTap: () =>
                      context.push('/memories/viewer/${e.id}?index=$i'),
                  onLongPress: () =>
                      _mediaMenu(context, ref, e, media[i], cover),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      MediaThumb(item: media[i]),
                      if (cover?.id == media[i].id)
                        const Positioned(
                          left: 6,
                          top: 6,
                          child: Icon(
                            Icons.star,
                            size: 18,
                            color: Aura.moneyHi,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
          if (media.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Long-press to set the cover or remove. '
                '${formatBytes(totalMediaBytes(media))} used.',
                style: text.bodySmall,
              ),
            ),
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
    final gone = await ref.read(memoriesRepositoryProvider).deleteEvent(e.id);
    await deleteFiles(gone.paths);
    if (context.mounted) context.pop();
  }

  Future<void> _mediaMenu(
    BuildContext context,
    WidgetRef ref,
    MemoryEvent e,
    MemoryMediaItem m,
    MemoryMediaItem? cover,
  ) async {
    final repo = ref.read(memoriesRepositoryProvider);
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (cover?.id != m.id && !m.isVideo)
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text('Use as cover'),
                onTap: () => Navigator.pop(ctx, 'cover'),
              ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Remove'),
              onTap: () => Navigator.pop(ctx, 'remove'),
            ),
          ],
        ),
      ),
    );
    if (choice == 'cover') await repo.setCover(e.id, m.id);
    if (choice == 'remove') {
      final gone = await repo.deleteMedia(m.id);
      await deleteFiles(gone.paths);
    }
  }
}
