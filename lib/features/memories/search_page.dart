import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import 'memories_repository.dart';
import 'memory_dates.dart';
import 'memory_search.dart';

/// Search by text with filters for category, person, year and attached media.
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _query = TextEditingController();
  int? _categoryId;
  String? _person;
  int? _year;
  bool _hasMedia = false;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events =
        ref.watch(memoryEventsProvider).value ?? const <MemoryEvent>[];
    final cats =
        ref.watch(memoryCategoriesProvider).value ?? const <MemoryCategory>[];
    final media =
        ref.watch(memoryMediaProvider).value ?? const <MemoryMediaItem>[];
    final text = Theme.of(context).textTheme;
    final people = {
      for (final e in events)
        if (e.person != null) e.person!,
    }.toList()..sort();
    final years = {
      for (final e in events)
        if (e.year != null) e.year!,
    }.toList()..sort((a, b) => b.compareTo(a));
    final results = filterEvents(
      events,
      MemoryFilter(
        query: _query.text,
        categoryId: _categoryId,
        person: _person,
        year: _year,
        hasMedia: _hasMedia,
      ),
      withMedia: {for (final m in media) m.eventId},
    )..sort((a, b) => timelineKey(b).compareTo(timelineKey(a)));
    final catName = {for (final c in cats) c.id: c.name};

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: ListView(
        padding: const EdgeInsets.all(Aura.margin),
        children: [
          TextField(
            controller: _query,
            decoration: const InputDecoration(
              labelText: 'Search title, person, place, notes',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final c in cats)
                FilterChip(
                  label: Text(c.name),
                  selected: _categoryId == c.id,
                  onSelected: (v) =>
                      setState(() => _categoryId = v ? c.id : null),
                ),
              FilterChip(
                avatar: const Icon(Icons.photo_outlined, size: 18),
                label: const Text('Has photos or videos'),
                selected: _hasMedia,
                onSelected: (v) => setState(() => _hasMedia = v),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String?>(
                  initialValue: _person,
                  decoration: const InputDecoration(labelText: 'Person'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Anyone')),
                    for (final p in people)
                      DropdownMenuItem(value: p, child: Text(p)),
                  ],
                  onChanged: (v) => setState(() => _person = v),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int?>(
                  initialValue: _year,
                  decoration: const InputDecoration(labelText: 'Year'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Any')),
                    for (final y in years)
                      DropdownMenuItem(value: y, child: Text('$y')),
                  ],
                  onChanged: (v) => setState(() => _year = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('${results.length} found', style: text.bodySmall),
          for (final e in results)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(e.title),
              subtitle: Text(
                [
                  formatMemoryDate(e),
                  catName[e.categoryId] ?? '',
                  ?e.person,
                  ?e.place,
                ].where((s) => s.isNotEmpty).join(' · '),
                style: text.bodySmall,
              ),
              onTap: () => context.push('/memories/event/${e.id}'),
            ),
        ],
      ),
    );
  }
}
