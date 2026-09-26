import 'package:flutter/material.dart';

import '../../core/theme/aura_colors.dart';
import '../../core/widgets/aura_widgets.dart';

typedef WakeAnswer = ({int? quality, String? note});

/// Asks for a 1-5 quality rating and an optional note. Returns null if skipped.
Future<WakeAnswer?> showWakePrompt(BuildContext context) {
  return showDialog<WakeAnswer>(
    context: context,
    builder: (_) => const _WakePrompt(),
  );
}

class _WakePrompt extends StatefulWidget {
  const _WakePrompt();

  @override
  State<_WakePrompt> createState() => _WakePromptState();
}

class _WakePromptState extends State<_WakePrompt> {
  int? _quality;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('How did you sleep?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QualityPicker(
            value: _quality,
            onChanged: (v) => setState(() => _quality = v),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _note,
            decoration: const InputDecoration(hintText: 'Note (optional)'),
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Skip'),
        ),
        PillButton(
          label: 'Save',
          onPressed: _quality == null
              ? null
              : () => Navigator.pop(context, (
                  quality: _quality,
                  note: _note.text.trim().isEmpty ? null : _note.text.trim(),
                )),
        ),
      ],
    );
  }
}

/// Row of five circular 1-5 toggles.
class QualityPicker extends StatelessWidget {
  const QualityPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 1; i <= 5; i++)
          GestureDetector(
            onTap: () => onChanged(value == i ? null : i),
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value == i ? Aura.sleep : Aura.input,
                border: Border.all(color: value == i ? Aura.sleep : Aura.rim),
              ),
              child: Text(
                '$i',
                style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: value == i ? Aura.canvas : Aura.text),
              ),
            ),
          ),
      ],
    );
  }
}
