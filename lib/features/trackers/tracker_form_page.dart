import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/pearl_colors.dart';
import '../../core/widgets/pearl_widgets.dart';
import 'tracker_icons.dart';
import 'tracker_logic.dart';
import 'trackers_repository.dart';

/// Create a tracker, or edit one when [id] is given (the type can't change).
class TrackerFormPage extends ConsumerStatefulWidget {
  const TrackerFormPage({super.key, this.id});

  final int? id;

  @override
  ConsumerState<TrackerFormPage> createState() => _TrackerFormPageState();
}

class _TrackerFormPageState extends ConsumerState<TrackerFormPage> {
  final _name = TextEditingController();
  String _icon = 'star';
  TrackerType _type = TrackerType.habit;
  Tracker? _existing;
  bool _loaded = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Enter a name')));
      return;
    }
    final repo = ref.read(trackersRepositoryProvider);
    final existing = _existing;
    if (existing == null) {
      await repo.addTracker(name, _icon, _type);
    } else {
      await repo.updateTracker(existing.copyWith(name: name, icon: _icon));
    }
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.id != null && !_loaded) {
      final t = (ref.watch(trackersProvider).value ?? const <Tracker>[])
          .where((t) => t.id == widget.id)
          .firstOrNull;
      if (t == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Edit tracker')),
          body: const SizedBox.shrink(),
        );
      }
      _existing = t;
      _name.text = t.name;
      _icon = t.icon;
      _type = TrackerType.values.firstWhere(
        (x) => x.name == t.type,
        orElse: () => TrackerType.habit,
      );
      _loaded = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'New tracker' : 'Edit tracker'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Pearl.margin),
        children: [
          TextField(
            controller: _name,
            autofocus: widget.id == null,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'e.g. Meditate',
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle('Type'),
          Segmented<TrackerType>(
            expand: true,
            segments: const [
              (TrackerType.habit, 'Yes / No habit'),
              (TrackerType.duration, 'Timer'),
            ],
            selected: _type,
            onChanged: widget.id != null
                ? null
                : (v) => setState(() => _type = v),
          ),
          const SizedBox(height: 20),
          const SectionTitle('Icon'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final e in trackerIcons.entries)
                InkWell(
                  onTap: () => setState(() => _icon = e.key),
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _icon == e.key
                          ? context.pearl.anchor
                          : context.pearl.raised,
                      border: Border.all(
                        color: _icon == e.key
                            ? context.pearl.anchor
                            : context.pearl.hairline,
                      ),
                    ),
                    child: Icon(
                      e.value,
                      color: _icon == e.key
                          ? context.pearl.onAnchor
                          : context.pearl.ink,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          PillButton(label: 'Save', onPressed: _save),
        ],
      ),
    );
  }
}
