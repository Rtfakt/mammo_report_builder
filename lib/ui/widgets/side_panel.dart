import 'package:flutter/material.dart';

import '../../domain/acr_density.dart';
import '../../domain/breast_exam_side.dart';
import '../../domain/quadrant.dart';
import '../../domain/selected_finding.dart';

/// Панель одной стороны молочной железы: плотность (если не управляется
/// общим переключателем "одинаково с обеих сторон") + список находок.
class SidePanel extends StatelessWidget {
  final BreastExamSide data;
  final bool showDensitySelector;
  final ValueChanged<AcrDensity> onDensityChanged;
  final VoidCallback onAddFinding;
  final ValueChanged<int> onRemoveFinding;

  const SidePanel({
    super.key,
    required this.data,
    required this.showDensitySelector,
    required this.onDensityChanged,
    required this.onAddFinding,
    required this.onRemoveFinding,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.side.label,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (showDensitySelector) ...[
              Text(
                'Плотность (ACR)',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              _DensitySelector(
                value: data.density,
                onChanged: onDensityChanged,
              ),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                Text('Находки', style: Theme.of(context).textTheme.labelLarge),
                const Spacer(),
                TextButton.icon(
                  onPressed: onAddFinding,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Добавить'),
                ),
              ],
            ),
            if (data.findings.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Норма (находок не добавлено)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < data.findings.length; i++)
                    InputChip(
                      label: Text(_findingChipLabel(data.findings[i])),
                      onDeleted: () => onRemoveFinding(i),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _findingChipLabel(SelectedFinding finding) {
    final parts = <String>[finding.findingType.label];
    if (finding.quadrant != null) {
      parts.add(_shortQuadrant(finding.quadrant!));
    }
    if (finding.calcificationDistribution != null) {
      parts.add(finding.calcificationDistribution!.label.toLowerCase());
    }
    if (finding.calcificationTypes.isNotEmpty) {
      parts.add(finding.calcificationTypes.map((t) => t.inTextForm).join(', '));
    }
    if (finding.implantPlacement != null) {
      parts.add(finding.implantPlacement!.label.toLowerCase());
    }
    return parts.join(' · ');
  }

  String _shortQuadrant(Quadrant q) => q.label.split(' (').first;
}

class _DensitySelector extends StatelessWidget {
  final AcrDensity value;
  final ValueChanged<AcrDensity> onChanged;

  const _DensitySelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<AcrDensity>(
      segments: AcrDensity.values
          .map((d) => ButtonSegment(value: d, label: Text(d.code)))
          .toList(),
      selected: {value},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}
