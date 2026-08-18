import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../domain/acr_density.dart';
import '../domain/breast_exam_side.dart';
import '../domain/breast_side.dart';
import '../domain/exam_controller.dart';
import '../domain/finding_type.dart';
import '../domain/generated_report.dart';
import '../domain/mammography_catalog.dart';
import '../domain/mammography_exam.dart';
import '../domain/report_generator.dart';
import '../domain/selected_finding.dart';
import 'widgets/add_finding_dialog.dart';
import 'widgets/side_panel.dart';

/// Главный экран конструктора.
///
/// Левая колонка — текст сгенерированного заключения и кнопки действий.
/// Правая колонка — плотность, быстрые заключения (Норма / ФЖИ / ФКИ)
/// и добавление находок по каждой стороне.
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

        return LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;

            final leftPanel = _ReportPanel(
              report: report,
              onCopy: () => _copy(context, report.fullText),
              onSave: onSave == null ? null : () => onSave!(report),
            );

            final rightPanel = _ControlsPanel(
              exam: exam,
              controller: controller,
              onAddFinding: (side) => _addFinding(context, side),
            );

            if (isWide) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: leftPanel),
                    const SizedBox(width: 16),
                    SizedBox(width: 340, child: rightPanel),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [rightPanel, const SizedBox(height: 16), leftPanel],
              ),
            );
          },
        );
      },
    );
  }

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Текст скопирован в буфер обмена'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _addFinding(BuildContext context, BreastSide side) async {
    final exam = controller.exam;
    final result = await showAddFindingDialog(
      context,
      currentSide: side,
      unavailableSides: {
        if (exam.right.isRemoved) BreastSide.right,
        if (exam.left.isRemoved) BreastSide.left,
      },
    );
    if (result == null) return;

    final finding = SelectedFinding(
      findingType: result.findingType,
      quadrant: result.quadrant,
      size: result.size,
      calcificationDistribution: result.calcificationDistribution,
      calcificationTypes: result.calcificationTypes,
      implantPlacement: result.implantPlacement,
    );

    controller.update((exam) {
      var updated = exam;
      for (final target in result.sides) {
        updated = updated.sideUpdated(target, (s) {
          if (s.isRemoved) return s;
          return s.addFinding(finding);
        });
      }
      return updated;
    });
  }
}

// ---------------------------------------------------------------------------
// Левая колонка: текст заключения + кнопки
// ---------------------------------------------------------------------------

class _ReportPanel extends StatelessWidget {
  final GeneratedReport report;
  final VoidCallback onCopy;
  final VoidCallback? onSave;

  const _ReportPanel({
    required this.report,
    required this.onCopy,
    required this.onSave,
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
              'Предпросмотр',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),
            SelectableText(
              report.fullText,
              style: const TextStyle(fontFamily: 'monospace', height: 1.4),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Копировать'),
                ),
                if (onSave != null)
                  OutlinedButton.icon(
                    onPressed: onSave,
                    icon: const Icon(Icons.save_outlined, size: 18),
                    label: const Text('Сохранить в историю'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Правая колонка: плотность + быстрые заключения + находки
// ---------------------------------------------------------------------------

class _ControlsPanel extends StatelessWidget {
  final MammographyExam exam;
  final ExamController controller;
  final void Function(BreastSide side) onAddFinding;

  const _ControlsPanel({
    required this.exam,
    required this.controller,
    required this.onAddFinding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DensityCard(exam: exam, controller: controller),
        const SizedBox(height: 12),
        _QuickConclusionsCard(controller: controller),
        const SizedBox(height: 12),
        SidePanel(
          data: exam.right,
          showDensitySelector: !exam.sameDensityBothSides,
          onDensityChanged: (d) =>
              controller.update((e) => e.withSideDensity(BreastSide.right, d)),
          onAddFinding: () => onAddFinding(BreastSide.right),
          onRemoveFinding: (i) => controller.update(
            (e) => e.sideUpdated(BreastSide.right, (s) => s.removeFindingAt(i)),
          ),
          onRemovedChanged: (removed) => controller.update(
            (e) =>
                e.sideUpdated(BreastSide.right, (s) => s.withRemoved(removed)),
          ),
        ),
        const SizedBox(height: 12),
        SidePanel(
          data: exam.left,
          showDensitySelector: !exam.sameDensityBothSides,
          onDensityChanged: (d) =>
              controller.update((e) => e.withSideDensity(BreastSide.left, d)),
          onAddFinding: () => onAddFinding(BreastSide.left),
          onRemoveFinding: (i) => controller.update(
            (e) => e.sideUpdated(BreastSide.left, (s) => s.removeFindingAt(i)),
          ),
          onRemovedChanged: (removed) => controller.update(
            (e) =>
                e.sideUpdated(BreastSide.left, (s) => s.withRemoved(removed)),
          ),
        ),
      ],
    );
  }
}

class _DensityCard extends StatelessWidget {
  final MammographyExam exam;
  final ExamController controller;

  const _DensityCard({required this.exam, required this.controller});

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
              'Плотность молочной железы',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            FilterChip(
              label: const Text('Одинаковая с обеих сторон'),
              selected: exam.sameDensityBothSides,
              onSelected: (checked) => controller.update(
                (e) => e.copyWith(sameDensityBothSides: checked),
              ),
            ),
            if (exam.sameDensityBothSides) ...[
              const SizedBox(height: 12),
              SegmentedButton<AcrDensity>(
                segments: AcrDensity.values
                    .map((d) => ButtonSegment(value: d, label: Text(d.code)))
                    .toList(),
                selected: {exam.right.density},
                onSelectionChanged: (s) =>
                    controller.update((e) => e.withDensity(s.first)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuickConclusionsCard extends StatelessWidget {
  final ExamController controller;

  const _QuickConclusionsCard({required this.controller});

  void _apply(FindingType finding) {
    controller.update((exam) {
      final selected = SelectedFinding(findingType: finding);
      return exam.copyWith(
        right: exam.right.isRemoved
            ? exam.right
            : BreastExamSide(
                side: exam.right.side,
                density: exam.right.density,
              ).addFinding(selected),
        left: exam.left.isRemoved
            ? exam.left
            : BreastExamSide(
                side: exam.left.side,
                density: exam.left.density,
              ).addFinding(selected),
      );
    });
  }

  void _setNorma() {
    controller.update(
      (exam) => exam.copyWith(
        right: exam.right.isRemoved
            ? exam.right
            : exam.right.copyWith(findings: const []),
        left: exam.left.isRemoved
            ? exam.left
            : exam.left.copyWith(findings: const []),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fzhi = findingById('fatty_involution');
    final fki = findingById('fibrocystic_mastopathy');

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Частые заключения',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: _setNorma,
                  child: const Text('Норма'),
                ),
                OutlinedButton(
                  onPressed: () => _apply(fzhi),
                  child: const Text('ФЖИ'),
                ),
                OutlinedButton(
                  onPressed: () => _apply(fki),
                  child: const Text('ФКИ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
