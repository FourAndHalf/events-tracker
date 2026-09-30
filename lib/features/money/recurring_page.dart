import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/db/settings_repository.dart';
import '../../core/money/money_format.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import 'money_repository.dart';
import 'recurring_logic.dart';
import 'recurring_repository.dart';

/// Rules that add an expense automatically each week, month or year.
class RecurringPage extends ConsumerWidget {
  const RecurringPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules =
        ref.watch(recurringProvider).value ?? const <RecurringExpense>[];
    final cats = ref.watch(categoriesProvider).value ?? const <Category>[];
    final sym = ref.watch(settingsProvider).value?.currencySymbol ?? '₹';
    final text = Theme.of(context).textTheme;
    final catName = {for (final c in cats) c.id: c.name};
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('Recurring expenses')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/money/recurring/add'),
        backgroundColor: Aura.money,
        foregroundColor: Aura.canvas,
        icon: const Icon(Icons.add),
        label: const Text('Recurring'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Aura.margin,
          Aura.margin,
          Aura.margin,
          96,
        ),
        children: [
          if (rules.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  'Rent, subscriptions, insurance: add them once and they are logged automatically.',
                  textAlign: TextAlign.center,
                  style: text.bodySmall,
                ),
              ),
            ),
          for (final r in rules) ...[
            AuraCard(
              onTap: () => context.push('/money/recurring/edit/${r.id}'),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${formatMoney(r.amountCents, sym)} · ${Frequency.parse(r.frequency).label}',
                          style: text.titleMedium,
                        ),
                        Text(
                          [
                            r.note ?? r.item ?? catName[r.categoryId] ?? '',
                            if (r.active)
                              'next ${DateFormat('d MMM y').format(nextDue(Frequency.parse(r.frequency), r.startDate, now))}'
                            else
                              'paused',
                          ].where((s) => s.isNotEmpty).join(' · '),
                          style: text.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: r.active,
                    onChanged: (v) => ref
                        .read(recurringRepositoryProvider)
                        .update(r.copyWith(active: v)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

/// Add a recurring rule, or edit one when [id] is given.
class RecurringFormPage extends ConsumerStatefulWidget {
  const RecurringFormPage({super.key, this.id});

  final int? id;

  @override
  ConsumerState<RecurringFormPage> createState() => _RecurringFormPageState();
}

class _RecurringFormPageState extends ConsumerState<RecurringFormPage> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  final _store = TextEditingController();
  int? _categoryId;
  String _method = paymentMethods.first;
  Frequency _frequency = Frequency.monthly;
  DateTime _start = DateTime.now();
  RecurringExpense? _existing;
  bool _loaded = false;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    _store.dispose();
    super.dispose();
  }

  void _load(RecurringExpense r) {
    _existing = r;
    _amount.text = (r.amountCents / 100).toStringAsFixed(2);
    _note.text = r.note ?? '';
    _store.text = r.store ?? '';
    _categoryId = r.categoryId;
    _method = r.paymentMethod;
    _frequency = Frequency.parse(r.frequency);
    _start = r.startDate;
    _loaded = true;
  }

  void _toast(String m) => ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(m)));

  String? _clean(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _save() async {
    final cents = parseCents(_amount.text);
    if (cents == null) {
      return _toast('Enter an amount greater than 0, e.g. 12.50');
    }
    final cat = _categoryId;
    if (cat == null) return _toast('Choose a category');
    final repo = ref.read(recurringRepositoryProvider);
    final existing = _existing;
    if (existing == null) {
      await repo.add(
        RecurringExpensesCompanion.insert(
          amountCents: cents,
          categoryId: cat,
          paymentMethod: _method,
          startDate: DateTime(_start.year, _start.month, _start.day),
          frequency: Value(_frequency.name),
          note: Value(_clean(_note)),
          store: Value(_clean(_store)),
        ),
      );
    } else {
      // Changing the schedule restarts it from the new start date; expenses
      // already created stay as they are.
      final scheduleChanged =
          existing.frequency != _frequency.name || existing.startDate != _start;
      await repo.update(
        existing.copyWith(
          amountCents: cents,
          categoryId: cat,
          paymentMethod: _method,
          startDate: DateTime(_start.year, _start.month, _start.day),
          frequency: _frequency.name,
          note: Value(_clean(_note)),
          store: Value(_clean(_store)),
          lastGeneratedDate: scheduleChanged
              ? Value(_lastBefore(_start))
              : Value(existing.lastGeneratedDate),
        ),
      );
    }
    if (mounted) context.pop();
  }

  /// When the schedule is edited, skip anything before today that would
  /// otherwise be created again for dates that already passed.
  DateTime? _lastBefore(DateTime start) {
    final today = DateTime.now();
    final t = DateTime(today.year, today.month, today.day);
    final s = DateTime(start.year, start.month, start.day);
    return s.isBefore(t) ? t : null;
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this rule?'),
        content: const Text('Expenses it already created are kept.'),
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
    await ref.read(recurringRepositoryProvider).delete(widget.id!);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final cats = (ref.watch(categoriesProvider).value ?? const <Category>[])
        .where((c) => !c.archived || c.id == _categoryId)
        .toList();
    final sym = ref.watch(settingsProvider).value?.currencySymbol ?? '₹';
    if (widget.id != null && !_loaded) {
      final r =
          (ref.watch(recurringProvider).value ?? const <RecurringExpense>[])
              .where((r) => r.id == widget.id)
              .firstOrNull;
      if (r == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Edit recurring')),
          body: const SizedBox.shrink(),
        );
      }
      _load(r);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Add recurring' : 'Edit recurring'),
        actions: [
          if (widget.id != null)
            IconButton(
              tooltip: 'Delete',
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Aura.margin),
        children: [
          TextField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: Theme.of(context).textTheme.displaySmall,
            decoration: InputDecoration(prefixText: '$sym ', hintText: '0.00'),
          ),
          const SizedBox(height: 20),
          const Overline('Repeats'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final f in Frequency.values)
                ChoiceChip(
                  label: Text(f.label),
                  selected: _frequency == f,
                  selectedColor: Aura.money.withValues(alpha: 0.25),
                  onSelected: (_) => setState(() => _frequency = f),
                ),
            ],
          ),
          const SizedBox(height: 20),
          const Overline('First / next date'),
          const SizedBox(height: 8),
          PillButton(
            ghost: true,
            icon: Icons.calendar_today,
            label: DateFormat('EEE, d MMM y').format(_start),
            onPressed: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: _start,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (d != null) setState(() => _start = d);
            },
          ),
          const SizedBox(height: 20),
          const Overline('Category'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in cats)
                ChoiceChip(
                  label: Text(c.name),
                  selected: _categoryId == c.id,
                  selectedColor: Aura.money.withValues(alpha: 0.25),
                  onSelected: (_) => setState(() => _categoryId = c.id),
                ),
            ],
          ),
          const SizedBox(height: 20),
          const Overline('Payment method'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final m in paymentMethods)
                ChoiceChip(
                  label: Text(m),
                  selected: _method == m,
                  selectedColor: Aura.money.withValues(alpha: 0.25),
                  onSelected: (_) => setState(() => _method = m),
                ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _note,
            decoration: const InputDecoration(hintText: 'Note, e.g. Rent'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _store,
            decoration: const InputDecoration(hintText: 'Store (optional)'),
          ),
          const SizedBox(height: 24),
          PillButton(label: 'Save', color: Aura.money, onPressed: _save),
        ],
      ),
    );
  }
}
