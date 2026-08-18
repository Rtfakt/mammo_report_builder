import 'benign_calcification_type.dart';
import 'birads_category.dart';
import 'breast_exam_side.dart';
import 'breast_side.dart';
import 'description_slot.dart';
import 'generated_report.dart';
import 'mammography_exam.dart';
import 'selected_finding.dart';

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
    for (final slot in DescriptionSlot.values)
      slot: slot.defaultText(side.density),
  };

  for (final finding in side.findings) {
    for (final slot in DescriptionSlot.values) {
      final override = finding.findingType.overrideFor(
        slot,
        quadrant: finding.quadrant,
        size: finding.size,
        calcificationDistribution: finding.calcificationDistribution,
        calcificationTypes: finding.calcificationTypes,
        implantPlacement: finding.implantPlacement,
      );
      if (override != null) {
        slots[slot] = override;
      }
    }
    if (finding.calcificationTypes.contains(BenignCalcificationType.vascular)) {
      slots[DescriptionSlot.vesselCalcification] = 'Обызвествления сосудов да.';
    }
  }

  final sentences = [
    side.density.densitySentence,
    slots[DescriptionSlot.skin]!,
    slots[DescriptionSlot.structure]!,
    slots[DescriptionSlot.implants]!,
    slots[DescriptionSlot.calcifications]!,
    slots[DescriptionSlot.asymmetry]!,
    slots[DescriptionSlot.nodules]!,
    slots[DescriptionSlot.architecture]!,
    slots[DescriptionSlot.lymphNodes]!,
    slots[DescriptionSlot.vesselCalcification]!,
  ];

  return sentences.where((s) => s.trim().isNotEmpty).join(' ');
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
  // (например, двустороннее ФЖИ даёт одну строку). Находки с
  // combineBilateralSides склеиваются в «справа и слева».
  final findingTexts = <String>[];
  final consumedLeft = <int>{};

  for (final finding in exam.right.findings) {
    final text = _conclusionTextFor(
      finding,
      side: exam.right.side,
      leftFindings: exam.left.findings,
      consumedLeft: consumedLeft,
    );
    if (text != null && !findingTexts.contains(text)) {
      findingTexts.add(text);
    }
  }

  for (var i = 0; i < exam.left.findings.length; i++) {
    if (consumedLeft.contains(i)) continue;
    final finding = exam.left.findings[i];
    final text = finding.findingType.conclusionFor(
      sideLabel: exam.left.side.genitiveLabel,
      sidesAdverb: 'слева',
      quadrant: finding.quadrant,
      size: finding.size,
      calcificationDistribution: finding.calcificationDistribution,
      calcificationTypes: finding.calcificationTypes,
      implantPlacement: finding.implantPlacement,
    );
    if (text != null && !findingTexts.contains(text)) {
      findingTexts.add(text);
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

String? _conclusionTextFor(
  SelectedFinding finding, {
  required BreastSide side,
  required List<SelectedFinding> leftFindings,
  required Set<int> consumedLeft,
}) {
  var sidesAdverb = side == BreastSide.right ? 'справа' : 'слева';

  if (finding.findingType.combineBilateralSides) {
    for (var i = 0; i < leftFindings.length; i++) {
      if (consumedLeft.contains(i)) continue;
      if (!_sameConclusionSignature(finding, leftFindings[i])) continue;
      consumedLeft.add(i);
      sidesAdverb = 'справа и слева';
      break;
    }
  }

  return finding.findingType.conclusionFor(
    sideLabel: side.genitiveLabel,
    sidesAdverb: sidesAdverb,
    quadrant: finding.quadrant,
    size: finding.size,
    calcificationDistribution: finding.calcificationDistribution,
    calcificationTypes: finding.calcificationTypes,
    implantPlacement: finding.implantPlacement,
  );
}

bool _sameConclusionSignature(SelectedFinding a, SelectedFinding b) {
  if (a.findingType.id != b.findingType.id) return false;
  if (a.implantPlacement != b.implantPlacement) return false;
  if (a.quadrant != b.quadrant) return false;
  if (a.size != b.size) return false;
  if (a.calcificationDistribution != b.calcificationDistribution) return false;
  if (a.calcificationTypes.length != b.calcificationTypes.length) return false;
  for (var i = 0; i < a.calcificationTypes.length; i++) {
    if (a.calcificationTypes[i] != b.calcificationTypes[i]) return false;
  }
  return true;
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
