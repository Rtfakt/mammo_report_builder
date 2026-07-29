import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../domain/acr_density.dart';
import '../domain/breast_side.dart';
import '../domain/exam_controller.dart';
import '../domain/generated_report.dart';
import '../domain/mammography_exam.dart';
import '../domain/report_generator.dart';
import '../domain/selected_finding.dart';
import 'widgets/add_finding_dialog.dart';
import 'widgets/side_panel.dart';

/// Главный экран конструктора: выбор плотности и находок для обеих сторон
/// + живой предпросмотр готового текста.
class ConstructorPage extends StatelessWidget {
  final ExamController controller;
  final Future<void> Function(GeneratedReport report)? onSave;

  const ConstructorPage({super.key, required this.controller, this.onSave});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final exam = controller.exam;
        final report = generateMammographyReport(exam);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDensityBar(context, exam),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final panels = [
                    Expanded(
                      child: SidePanel(
                        data: exam.right,
                        showDensitySelector: !exam.sameDensityBothSides,
                        onDensityChanged: (d) =>
                            controller.update((e) => e.withSideDensity(BreastSide.right, d)),
                        onAddFinding: () => _addFinding(context, BreastSide.right),
                        onRemoveFinding: (i) => controller.update(
                          (e) => e.sideUpdated(BreastSide.right, (s) => s.removeFindingAt(i)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16, height: 16),
                    Expanded(
                      child: SidePanel(
                        data: exam.left,
                        showDensitySelector: !exam.sameDensityBothSides,
                        onDensityChanged: (d) =>
                            controller.update((e) => e.withSideDensity(BreastSide.left, d)),
                        onAddFinding: () => _addFinding(context, BreastSide.left),
                        onRemoveFinding: (i) => controller.update(
                          (e) => e.sideUpdated(BreastSide.left, (s) => s.removeFindingAt(i)),
                        ),
                      ),
                    ),
                  ];
                  final isWide = constraints.maxWidth > 700;
                  return isWide ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: panels) : Column(children: panels);
                },
              ),
              const SizedBox(height: 24),
              _PreviewSection(report: report, onSave: onSave == null ? null : () => onSave!(report)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDensityBar(BuildContext context, MammographyExam exam) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 12,
          children: [
            FilterChip(
              label: const Text('Одинаковая плотность с обеих сторон'),
              selected: exam.sameDensityBothSides,
              onSelected: (checked) => controller.update((e) => e.copyWith(sameDensityBothSides: checked)),
            ),
            if (exam.sameDensityBothSides)
              SegmentedButton<AcrDensity>(
                segments: AcrDensity.values.map((d) => ButtonSegment(value: d, label: Text(d.code))).toList(),
                selected: {exam.right.density},
                onSelectionChanged: (s) => controller.update((e) => e.withDensity(s.first)),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _addFinding(BuildContext context, BreastSide side) async {
    final result = await showAddFindingDialog(context, currentSide: side);
    if (result == null) return;

    final finding = SelectedFinding(
      findingType: result.findingType,
      quadrant: result.quadrant,
    );

    controller.update((exam) {
      var updated = exam;
      for (final target in result.sides) {
        updated = updated.sideUpdated(target, (s) => s.addFinding(finding));
      }
      return updated;
    });
  }
}

class _PreviewSection extends StatelessWidget {
  final GeneratedReport report;
  final VoidCallback? onSave;

  const _PreviewSection({required this.report, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                Text('Предпросмотр', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (onSave != null)
                      OutlinedButton.icon(
                        onPressed: onSave,
                        icon: const Icon(Icons.save_outlined, size: 18),
                        label: const Text('Сохранить в историю'),
                      ),
                    FilledButton.icon(
                      onPressed: () => _copy(context, report.fullText),
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('Скопировать всё'),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            SelectableText(report.fullText, style: const TextStyle(fontFamily: 'monospace', height: 1.4)),
          ],
        ),
      ),
    );
  }

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Текст скопирован в буфер обмена'), duration: Duration(seconds: 2)),
    );
  }
}
