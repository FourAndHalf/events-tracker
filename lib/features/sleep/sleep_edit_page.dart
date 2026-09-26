import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';
import 'sleep_repository.dart';
import 'wake_prompt.dart';

class SleepEditPage extends ConsumerStatefulWidget {
  const SleepEditPage({super.key, required this.id});

  final int id;

  @override
  ConsumerState<SleepEditPage> createState() => _SleepEditPageState();
}

class _SleepEditPageState extends ConsumerState<SleepEditPage> {
  SleepSession? _session;
  late DateTime _sleepAt;
  DateTime? _wakeAt;
  int? _quality;
  final _note = TextEditingController();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    ref.read(sleepRepositoryProvider).get(widget.id).then((s) {
      if (!mounted || s == null) return;
      setState(() {
        _session = s;
        _sleepAt = s.sleepAt;
        _wakeAt = s.wakeAt;
        _quality = s.quality;
        _note.text = s.note ?? '';
        _loaded = true;
      });
    });
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<DateTime?> _pick(DateTime initial) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (date == null || !mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _save() async {
    final wake = _wakeAt;
    if (wake != null && !wake.isAfter(_sleepAt)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wake time must be after sleep time')),
      );
      return;
    }
    final note = _note.text.trim();
    await ref
        .read(sleepRepositoryProvider)
        .update(
          _session!.copyWith(
            sleepAt: _sleepAt,
            wakeAt: Value(wake),
            quality: Value(_quality),
            note: Value(note.isEmpty ? null : note),
          ),
        );
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this night?'),
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
    await ref.read(sleepRepositoryProvider).delete(widget.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('EEE d MMM, h:mm a');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit sleep'),
        actions: [
          IconButton(
            onPressed: _loaded ? _delete : null,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: !_loaded
          ? const SizedBox.shrink()
          : ListView(
              padding: const EdgeInsets.all(Aura.margin),
              children: [
                const Overline('Went to sleep'),
                const SizedBox(height: 8),
                PillButton(
                  ghost: true,
                  icon: Icons.bedtime,
                  label: fmt.format(_sleepAt),
                  onPressed: () async {
                    final d = await _pick(_sleepAt);
                    if (d != null) setState(() => _sleepAt = d);
                  },
                ),
                const SizedBox(height: 20),
                const Overline('Woke up'),
                const SizedBox(height: 8),
                PillButton(
                  ghost: true,
                  icon: Icons.wb_sunny_outlined,
                  label: _wakeAt == null
                      ? 'Not woken yet'
                      : fmt.format(_wakeAt!),
                  onPressed: () async {
                    final d = await _pick(_wakeAt ?? DateTime.now());
                    if (d != null) setState(() => _wakeAt = d);
                  },
                ),
                const SizedBox(height: 20),
                const Overline('Quality'),
                const SizedBox(height: 8),
                QualityPicker(
                  value: _quality,
                  onChanged: (v) => setState(() => _quality = v),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _note,
                  decoration: const InputDecoration(
                    hintText: 'Note (optional)',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                PillButton(label: 'Save', onPressed: _save),
              ],
            ),
    );
  }
}
