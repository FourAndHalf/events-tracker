import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import 'memories_repository.dart';
import 'memory_dates.dart';

/// Add a memory, or edit one when [id] is given.
class EventFormPage extends ConsumerStatefulWidget {
  const EventFormPage({super.key, this.id});

  final int? id;

  @override
  ConsumerState<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends ConsumerState<EventFormPage> {
  final _title = TextEditingController();
  final _person = TextEditingController();
  final _place = TextEditingController();
  final _description = TextEditingController();
  final _yearText = TextEditingController();
  MemoryKind _kind = MemoryKind.oneTime;
  DatePrecision _precision = DatePrecision.day;
  int? _month;
  int? _day;
  bool _yearKnown = true; // occasions may leave the starting year out
  int? _categoryId;
  MemoryEvent? _existing;
  bool _loaded = false;

  @override
  void dispose() {
    for (final c in [_title, _person, _place, _description, _yearText]) {
      c.dispose();
    }
    super.dispose();
  }

  void _load(MemoryEvent e) {
    _existing = e;
    _title.text = e.title;
    _person.text = e.person ?? '';
    _place.text = e.place ?? '';
    _description.text = e.description ?? '';
    _kind = e.kind == MemoryKind.occasion.name
        ? MemoryKind.occasion
        : MemoryKind.oneTime;
    _precision = DatePrecision.values.firstWhere(
      (p) => p.name == e.precision,
      orElse: () => DatePrecision.day,
    );
    _month = e.month;
    _day = e.day;
    _yearKnown = e.year != null;
    _yearText.text = e.year?.toString() ?? '';
    _categoryId = e.categoryId;
    _loaded = true;
  }

  // Replace a message still on screen instead of queueing behind it.
  void _toast(String m) => ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(m)));

  String? _clean(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _pickDay() async {
    final year = int.tryParse(_yearText.text.trim());
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime(
        year ?? DateTime.now().year,
        _month ?? DateTime.now().month,
        _day ?? DateTime.now().day,
      ),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (d == null) return;
    setState(() {
      _month = d.month;
      _day = d.day;
      _yearText.text = d.year.toString();
    });
  }

  Future<void> _addCategory() async {
    final c = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New category'),
        content: TextField(
          controller: c,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, c.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    c.dispose();
    if (name == null || name.isEmpty) return;
    final id = await ref.read(memoriesRepositoryProvider).addCategory(name);
    if (mounted) setState(() => _categoryId = id);
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    if (title.isEmpty) return _toast('Enter a title');
    final cat = _categoryId;
    if (cat == null) return _toast('Choose a category');

    final occasion = _kind == MemoryKind.occasion;
    final precision = occasion ? DatePrecision.day : _precision;
    int? year;
    if (!occasion || _yearKnown) {
      year = int.tryParse(_yearText.text.trim());
      if (year == null || year < 1900 || year > 2100) {
        return _toast('Enter a year between 1900 and 2100');
      }
    }
    int? month = _month;
    int? day = _day;
    if (precision == DatePrecision.year) {
      month = null;
      day = null;
    } else if (precision == DatePrecision.month) {
      day = null;
      if (month == null) return _toast('Choose a month');
    } else if (month == null || day == null) {
      return _toast('Pick the date');
    }

    final repo = ref.read(memoriesRepositoryProvider);
    final existing = _existing;
    if (existing == null) {
      await repo.addEvent(
        MemoryEventsCompanion.insert(
          title: title,
          categoryId: cat,
          createdAt: DateTime.now(),
          kind: Value(_kind.name),
          precision: Value(precision.name),
          year: Value(year),
          month: Value(month),
          day: Value(day),
          person: Value(_clean(_person)),
          place: Value(_clean(_place)),
          description: Value(_clean(_description)),
        ),
      );
    } else {
      await repo.updateEvent(
        existing.copyWith(
          title: title,
          categoryId: cat,
          kind: _kind.name,
          precision: precision.name,
          year: Value(year),
          month: Value(month),
          day: Value(day),
          person: Value(_clean(_person)),
          place: Value(_clean(_place)),
          description: Value(_clean(_description)),
        ),
      );
    }
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final cats =
        (ref.watch(memoryCategoriesProvider).value ?? const <MemoryCategory>[])
            .where((c) => !c.archived || c.id == _categoryId)
            .toList();
    if (widget.id != null && !_loaded) {
      final e = (ref.watch(memoryEventsProvider).value ?? const <MemoryEvent>[])
          .where((e) => e.id == widget.id)
          .firstOrNull;
      if (e == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Edit memory')),
          body: const SizedBox.shrink(),
        );
      }
      _load(e);
    }
    if (_categoryId == null && cats.isNotEmpty) {
      _categoryId = cats
          .firstWhere((c) => c.name == 'Other', orElse: () => cats.last)
          .id;
    }
    final occasion = _kind == MemoryKind.occasion;
    final precision = occasion ? DatePrecision.day : _precision;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Add memory' : 'Edit memory'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Aura.margin),
        children: [
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Happened once'),
                selected: !occasion,
                onSelected: (_) => setState(() => _kind = MemoryKind.oneTime),
              ),
              ChoiceChip(
                label: const Text('Repeats every year'),
                selected: occasion,
                onSelected: (_) => setState(() => _kind = MemoryKind.occasion),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _title,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: occasion
                  ? 'Title, e.g. Mum\'s birthday'
                  : 'Title, e.g. Trip to Goa',
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              for (final c in cats)
                ChoiceChip(
                  label: Text(c.name),
                  selected: _categoryId == c.id,
                  onSelected: (_) => setState(() => _categoryId = c.id),
                ),
              ActionChip(
                avatar: const Icon(Icons.add, size: 18),
                label: const Text('New'),
                onPressed: _addCategory,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!occasion) ...[
            Wrap(
              spacing: 8,
              children: [
                for (final (p, label) in [
                  (DatePrecision.day, 'Exact date'),
                  (DatePrecision.month, 'Month and year'),
                  (DatePrecision.year, 'Year only'),
                ])
                  ChoiceChip(
                    label: Text(label),
                    selected: _precision == p,
                    onSelected: (_) => setState(() => _precision = p),
                  ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          if (precision == DatePrecision.day)
            OutlinedButton.icon(
              onPressed: _pickDay,
              icon: const Icon(Icons.event),
              label: Text(
                _month == null || _day == null
                    ? 'Pick the date'
                    : DateFormat('d MMM')
                              .format(DateTime(2000, _month!, _day!)) +
                          (_yearKnown && _yearText.text.isNotEmpty
                              ? ' ${_yearText.text}'
                              : ''),
              ),
            ),
          if (precision == DatePrecision.month)
            DropdownButtonFormField<int>(
              initialValue: _month,
              decoration: const InputDecoration(labelText: 'Month'),
              items: [
                for (var m = 1; m <= 12; m++)
                  DropdownMenuItem(
                    value: m,
                    child: Text(DateFormat('MMMM').format(DateTime(2000, m))),
                  ),
              ],
              onChanged: (v) => setState(() => _month = v),
            ),
          if (precision != DatePrecision.day) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _yearText,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Year'),
            ),
          ],
          if (occasion)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('I know the starting year'),
              subtitle: const Text('Shows "30th birthday" style counts'),
              value: _yearKnown,
              onChanged: (v) => setState(() => _yearKnown = v),
            ),
          const SizedBox(height: 16),
          TextField(
            controller: _person,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Person (optional)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _place,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Place (optional)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _description,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
            ),
          ),
          const SizedBox(height: 24),
          PillButton(label: 'Save', color: Aura.memory, onPressed: _save),
        ],
      ),
    );
  }
}
