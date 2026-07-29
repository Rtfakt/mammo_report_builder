import 'package:flutter/material.dart';

import '../../domain/breast_side.dart';
import '../../domain/finding_type.dart';
import '../../domain/mammography_catalog.dart';
import '../../domain/quadrant.dart';

/// Результат диалога "Добавить находку": сама находка, набор сторон,
/// на которые её нужно добавить (обычно одна — текущая панель, но можно
/// сразу отметить "обе стороны" для типового двустороннего случая),
/// и локализация, если находка её требует.
class AddFindingResult {
  final FindingType findingType;
  final Set<BreastSide> sides;
  final Quadrant? quadrant;

  const AddFindingResult({
    required this.findingType,
    required this.sides,
    this.quadrant,
  });
}

Future<AddFindingResult?> showAddFindingDialog(
  BuildContext context, {
  required BreastSide currentSide,
}) {
  return showDialog<AddFindingResult>(
    context: context,
    builder: (context) => _AddFindingDialog(currentSide: currentSide),
  );
}

class _AddFindingDialog extends StatefulWidget {
  final BreastSide currentSide;

  const _AddFindingDialog({required this.currentSide});

  @override
  State<_AddFindingDialog> createState() => _AddFindingDialogState();
}

class _AddFindingDialogState extends State<_AddFindingDialog> {
  FindingType? _selected;
  late Set<BreastSide> _sides;
  Quadrant? _quadrant;

  @override
  void initState() {
    super.initState();
    _sides = {widget.currentSide};
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
    final canConfirm = selected != null &&
        _sides.isNotEmpty &&
        (!selected.requiresLocalization || _quadrant != null);

    return AlertDialog(
      title: const Text('Добавить находку'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Патология / Заключение', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: mammographyFindingCatalog.map((finding) {
                final isSelected = finding.id == selected?.id;
                return ChoiceChip(
                  label: Text(finding.label),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selected = finding;
                      _quadrant = null;
                    });
                  },
                );
              }).toList(),
            ),
            if (selected != null && selected.isPathology) ...[
              const SizedBox(height: 20),
              const Text('Сторона', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: BreastSide.values.map((side) {
                  final isChecked = _sides.contains(side);
                  return FilterChip(
                    label: Text(side.label),
                    selected: isChecked,
                    onSelected: (checked) {
                      setState(() {
                        if (checked) {
                          _sides.add(side);
                        } else {
                          _sides.remove(side);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
            if (selected != null && selected.requiresLocalization) ...[
              const SizedBox(height: 20),
              const Text('Локализация', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButtonFormField<Quadrant>(
                initialValue: _quadrant,
                isExpanded: true,
                hint: const Text('Выберите квадрант'),
                items: Quadrant.values
                    .map((q) => DropdownMenuItem(value: q, child: Text(q.label)))
                    .toList(),
                onChanged: (value) => setState(() => _quadrant = value),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: canConfirm
              ? () => Navigator.of(context).pop(
                    AddFindingResult(
                      findingType: selected,
                      sides: _sides,
                      quadrant: _quadrant,
                    ),
                  )
              : null,
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}
