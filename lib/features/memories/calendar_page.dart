import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/aura_colors.dart';
import 'memories_repository.dart';
import 'memory_dates.dart';
import 'memory_search.dart';

/// Month grid marking days with occasions and events; tap a day to list them.
class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  late DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  late DateTime _selected = DateTime.now();

  void _shift(int by) => setState(() {
    _month = DateTime(_month.year, _month.month + by);
    _selected = DateTime(_month.year, _month.month);
  });

  @override
  Widget build(BuildContext context) {
    final events =
        ref.watch(memoryEventsProvider).value ?? const <MemoryEvent>[];
    final text = Theme.of(context).textTheme;
    final marks = markedDays(events, _month.year, _month.month);
    final days = DateUtils.getDaysInMonth(_month.year, _month.month);
    final blanks = leadingBlanks(_month.year, _month.month);
    final now = DateTime.now();
    final onSelected = eventsOnDay(events, _selected);

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: ListView(
        padding: const EdgeInsets.all(Aura.margin),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Previous month',
                onPressed: () => _shift(-1),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  DateFormat('MMMM y').format(_month),
                  textAlign: TextAlign.center,
                  style: text.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'Next month',
                onPressed: () => _shift(1),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          Row(
            children: [
              for (final d in const ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                Expanded(
                  child: Center(child: Text(d, style: text.labelSmall)),
                ),
            ],
          ),
          const SizedBox(height: 4),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (var i = 0; i < blanks; i++) const SizedBox.shrink(),
              for (var d = 1; d <= days; d++)
                _DayCell(
                  day: d,
                  marked: marks.containsKey(d),
                  selected:
                      _selected.year == _month.year &&
                      _selected.month == _month.month &&
                      _selected.day == d,
                  today:
                      now.year == _month.year &&
                      now.month == _month.month &&
                      now.day == d,
                  onTap: () => setState(
                    () => _selected = DateTime(_month.year, _month.month, d),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            DateFormat('EEEE d MMMM').format(_selected),
            style: text.titleMedium,
          ),
          if (onSelected.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Nothing on this day.', style: text.bodySmall),
            ),
          for (final e in onSelected)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(e.title),
              subtitle: Text(
                e.kind == MemoryKind.occasion.name
                    ? 'Every year'
                    : formatMemoryDate(e),
                style: text.bodySmall,
              ),
              onTap: () => context.push('/memories/event/${e.id}'),
            ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.marked,
    required this.selected,
    required this.today,
    required this.onTap,
  });

  final int day;
  final bool marked;
  final bool selected;
  final bool today;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? Aura.memory.withValues(alpha: 0.25) : null,
          border: today ? Border.all(color: Aura.memory) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$day'),
            SizedBox(
              height: 6,
              child: marked
                  ? const Icon(Icons.circle, size: 5, color: Aura.memory)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
