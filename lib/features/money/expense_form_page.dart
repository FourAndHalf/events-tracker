import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/db/settings_repository.dart';
import '../../core/money/money_format.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import 'budget_logic.dart';
import 'money_repository.dart';
import 'receipt_storage.dart';

/// Add (id == null) or edit an expense.
class ExpenseFormPage extends ConsumerStatefulWidget {
  const ExpenseFormPage({super.key, this.id});

  final int? id;

  @override
  ConsumerState<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends ConsumerState<ExpenseFormPage> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  final _item = TextEditingController();
  final _store = TextEditingController();
  int? _categoryId;
  DateTime _date = DateTime.now();
  String _method = paymentMethods.first;
  DateTime? _warranty;
  String? _receipt;
  Expense? _existing;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    final id = widget.id;
    if (id == null) {
      _loaded = true;
    } else {
      ref.read(moneyRepositoryProvider).getExpense(id).then((e) {
        if (!mounted || e == null) return;
        setState(() {
          _existing = e;
          _amount.text = (e.amountCents / 100).toStringAsFixed(2);
          _note.text = e.note ?? '';
          _item.text = e.item ?? '';
          _store.text = e.store ?? '';
          _categoryId = e.categoryId;
          _date = e.date;
          _method = e.paymentMethod;
          _warranty = e.warrantyOrReturnBy;
          _receipt = e.receiptPath;
          _loaded = true;
        });
      });
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    _item.dispose();
    _store.dispose();
    super.dispose();
  }

  String? _clean(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _pickDate({required bool warranty}) async {
    final initial = (warranty ? _warranty : null) ?? _date;
    final d = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (d == null) return;
    setState(() => warranty ? _warranty = d : _date = d);
  }

  Future<void> _addReceipt(ImageSource source) async {
    final path = await pickReceipt(source);
    if (path != null && mounted) setState(() => _receipt = path);
  }

  Future<void> _addReceiptFromFiles() async {
    final path = await pickReceiptFromFiles();
    if (path != null && mounted) setState(() => _receipt = path);
  }

  Future<void> _save() async {
    final cents = parseCents(_amount.text);
    if (cents == null) {
      _toast('Enter an amount greater than 0, e.g. 12.50');
      return;
    }
    final cat = _categoryId;
    if (cat == null) {
      _toast('Choose a category');
      return;
    }
    final repo = ref.read(moneyRepositoryProvider);
    final existing = _existing;
    if (existing == null) {
      await repo.addExpense(
        ExpensesCompanion.insert(
          amountCents: cents,
          categoryId: cat,
          date: _date,
          paymentMethod: _method,
          note: Value(_clean(_note)),
          item: Value(_clean(_item)),
          store: Value(_clean(_store)),
          warrantyOrReturnBy: Value(_warranty),
          receiptPath: Value(_receipt),
        ),
      );
    } else {
      await repo.updateExpense(
        existing.copyWith(
          amountCents: cents,
          categoryId: cat,
          date: _date,
          paymentMethod: _method,
          note: Value(_clean(_note)),
          item: Value(_clean(_item)),
          store: Value(_clean(_store)),
          warrantyOrReturnBy: Value(_warranty),
          receiptPath: Value(_receipt),
        ),
      );
    }
    await _warnIfNearBudget(cat);
    if (mounted) context.pop();
  }

  /// Shows a warning at 80% and 100% of the category's monthly budget.
  Future<void> _warnIfNearBudget(int categoryId) async {
    final repo = ref.read(moneyRepositoryProvider);
    final cats = await repo.watchCategories().first;
    final budget = cats.firstWhere((c) => c.id == categoryId).budgetCents;
    if (budget == null || budget <= 0) return;
    final all = await repo.watchExpenses().first;
    final spent = spendByCategory(all, _date)[categoryId] ?? 0;
    final level = budgetLevel(spent, budget);
    if (level == BudgetLevel.ok || !mounted) return;
    final name = cats.firstWhere((c) => c.id == categoryId).name;
    final pct = budgetPercent(spent, budget).round();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          level == BudgetLevel.over
              ? '$name is over budget ($pct% used)'
              : '$name is at $pct% of its budget',
        ),
      ),
    );
  }

  // Replace a message still on screen instead of queueing behind it.
  void _toast(String m) => ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    final cats = (ref.watch(categoriesProvider).value ?? const <Category>[])
        .where((c) => !c.archived || c.id == _categoryId)
        .toList();
    final sym = ref.watch(settingsProvider).value?.currencySymbol ?? '₹';
    final dateFmt = DateFormat('EEE, d MMM y');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Add expense' : 'Edit expense'),
      ),
      body: !_loaded
          ? const SizedBox.shrink()
          : ListView(
              padding: const EdgeInsets.all(Aura.margin),
              children: [
                TextField(
                  controller: _amount,
                  autofocus: widget.id == null,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: Theme.of(context).textTheme.displaySmall,
                  decoration: InputDecoration(
                    prefixText: '$sym ',
                    hintText: '0.00',
                  ),
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
                const Overline('Date'),
                const SizedBox(height: 8),
                PillButton(
                  ghost: true,
                  icon: Icons.calendar_today,
                  label: dateFmt.format(_date),
                  onPressed: () => _pickDate(warranty: false),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _note,
                  decoration: const InputDecoration(
                    hintText: 'Note (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    initiallyExpanded:
                        _item.text.isNotEmpty ||
                        _store.text.isNotEmpty ||
                        _warranty != null ||
                        _receipt != null,
                    title: Text(
                      'Purchase details',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    childrenPadding: const EdgeInsets.only(bottom: 8),
                    children: [
                      TextField(
                        controller: _item,
                        decoration: const InputDecoration(hintText: 'Item'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _store,
                        decoration: const InputDecoration(hintText: 'Store'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: PillButton(
                              ghost: true,
                              icon: Icons.shield_outlined,
                              label: _warranty == null
                                  ? 'Warranty / return-by'
                                  : dateFmt.format(_warranty!),
                              onPressed: () => _pickDate(warranty: true),
                            ),
                          ),
                          if (_warranty != null)
                            IconButton(
                              onPressed: () => setState(() => _warranty = null),
                              icon: const Icon(Icons.close),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_receipt != null)
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                Aura.innerRadius,
                              ),
                              child: Image.file(
                                File(_receipt!),
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const SizedBox(
                                  height: 80,
                                  child: Center(
                                    child: Text('Receipt file missing'),
                                  ),
                                ),
                              ),
                            ),
                            IconButton.filled(
                              onPressed: () => setState(() => _receipt = null),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            Row(
                              spacing: 8,
                              children: [
                                Expanded(
                                  child: PillButton(
                                    ghost: true,
                                    icon: Icons.photo_camera_outlined,
                                    label: 'Camera',
                                    onPressed: () =>
                                        _addReceipt(ImageSource.camera),
                                  ),
                                ),
                                Expanded(
                                  child: PillButton(
                                    ghost: true,
                                    icon: Icons.photo_library_outlined,
                                    label: 'Gallery',
                                    onPressed: () =>
                                        _addReceipt(ImageSource.gallery),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: PillButton(
                                ghost: true,
                                icon: Icons.cloud_outlined,
                                label: 'Google Photos',
                                onPressed: _addReceiptFromFiles,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PillButton(label: 'Save', color: Aura.money, onPressed: _save),
              ],
            ),
    );
  }
}
