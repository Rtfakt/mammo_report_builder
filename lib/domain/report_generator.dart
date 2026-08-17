import 'birads_category.dart';
import 'breast_exam_side.dart';
import 'description_slot.dart';
import 'generated_report.dart';
import 'mammography_exam.dart';

/// Чистая функция: MammographyExam -> готовый текст описания/заключения.
///
/// Никакого состояния и побочных эффектов — благодаря этому она полностью
/// покрывается юнит-тестами (см. test/report_generator_test.dart) и не
/// зависит от того, как именно UI собрал [MammographyExam].
GeneratedReport generateMammographyReport(MammographyExam exam) {
  final rightDescription = _buildSideDescription(exam.right);
  final leftDescription = _buildSideDescription(exam.left);

  final descriptionText =
      '${exam.right.side.fullLabel}:\n$rightDescription\n\n'
      '${exam.left.side.fullLabel}:\n$leftDescription';

  final conclusionText = _buildConclusion(exam);
  final recommendationText = _buildRecommendations(exam);

  final buffer = StringBuffer()
    ..writeln(descriptionText)
    ..writeln()
    ..writeln('ЗАКЛЮЧЕНИЕ:')
    ..writeln(conclusionText);

  if (recommendationText.isNotEmpty) {
    buffer
      ..writeln()
      ..writeln('РЕКОМЕНДОВАНО:')
      ..writeln(recommendationText);
  }

  return GeneratedReport(
    descriptionText: descriptionText,
    conclusionText: conclusionText,
    recommendationText: recommendationText,
    fullText: buffer.toString().trim(),
  );
}

String _buildSideDescription(BreastExamSide side) {
  final slots = <DescriptionSlot, String>{
    for (final slot in DescriptionSlot.values) slot: slot.defaultText(side.density),
  };

  for (final finding in side.findings) {
    for (final slot in DescriptionSlot.values) {
      final override = finding.findingType.overrideFor(
        slot,
        quadrant: finding.quadrant,
        size: finding.size,
      );
      if (override != null) {
        slots[slot] = override;
      }
    }
  }

  final sentences = [
    side.density.densitySentence,
    slots[DescriptionSlot.skin]!,
    slots[DescriptionSlot.structure]!,
    slots[DescriptionSlot.calcifications]!,
    slots[DescriptionSlot.asymmetry]!,
    slots[DescriptionSlot.nodules]!,
    slots[DescriptionSlot.architecture]!,
    slots[DescriptionSlot.lymphNodes]!,
    slots[DescriptionSlot.vesselCalcification]!,
  ];

  return sentences.join(' ');
}

/// Определяет наивысшую категорию BI-RADS среди патологических находок стороны.
/// Возвращает `null` если патологических находок нет.
BiRadsCategory? _maxCategory(BreastExamSide side) {
  BiRadsCategory? max;
  for (final finding in side.findings) {
    final cat = finding.findingType.category;
    if (cat == null) continue;
    if (max == null || cat.rank > max.rank) max = cat;
  }
  return max;
}

String _buildConclusion(MammographyExam exam) {
  final rightCat = _maxCategory(exam.right);
  final leftCat = _maxCategory(exam.left);

  if (rightCat == null && leftCat == null) {
    return 'Без очаговой патологии.\nBIRADS 1 справа и слева.';
  }

  // Собираем тексты находок, дедуплицируя одинаковые строки
  // (например, двустороннее ФЖИ даёт одну строку).
  final findingTexts = <String>[];
  for (final side in [exam.right, exam.left]) {
    for (final finding in side.findings) {
      final text = finding.findingType.conclusionFor(
        sideLabel: side.side.genitiveLabel,
        quadrant: finding.quadrant,
        size: finding.size,
      );
      if (text != null && !findingTexts.contains(text)) {
        findingTexts.add(text);
      }
    }
  }

  final rightLabel = rightCat?.code ?? 'BIRADS 1';
  final leftLabel = leftCat?.code ?? 'BIRADS 1';
  final biRadsLine = rightLabel == leftLabel
      ? '$rightLabel справа и слева.'
      : '$rightLabel справа.\n$leftLabel слева.';

  if (findingTexts.isEmpty) return biRadsLine;

  return '${findingTexts.join(' ')}\n$biRadsLine';
}

String _buildRecommendations(MammographyExam exam) {
  final recommendations = <String>{};
  final followUps = <String>{};

  if (exam.right.density.requiresAdjunctUltrasound ||
      exam.left.density.requiresAdjunctUltrasound) {
    recommendations.add(
      'УЗИ молочных желёз (рентгенологически плотные железы).',
    );
  }

  for (final side in [exam.right, exam.left]) {
    for (final finding in side.findings) {
      final rec = finding.findingType.recommendationFragment;
      if (rec != null) recommendations.add(rec);
    }
  }

  // followUpText берётся из максимальной категории BI-RADS каждой стороны
  for (final side in [exam.right, exam.left]) {
    final cat = _maxCategory(side);
    if (cat?.followUpText != null) followUps.add(cat!.followUpText!);
  }

  // Если патологии нет — стандартный интервал контроля 1 год
  if (exam.right.findings.isEmpty && exam.left.findings.isEmpty) {
    followUps.add('Динамический контроль через 1 год.');
  }

  return [...recommendations, ...followUps].join('\n');
}
