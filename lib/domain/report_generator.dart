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
  final rightSegments = _buildSideDescriptionSegments(exam.right);
  final leftSegments = _buildSideDescriptionSegments(exam.left);
  final rightDescription = _joinSegmentTexts(rightSegments);
  final leftDescription = _joinSegmentTexts(leftSegments);

  final rightHeading = _sideHeading(exam.right);
  final leftHeading = _sideHeading(exam.left);

  final descriptionText =
      '$rightHeading:\n$rightDescription\n\n'
      '$leftHeading:\n$leftDescription';

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

  final fullText = buffer.toString().trim();

  final previewSegments = <ReportTextSegment>[
    ReportTextSegment('$rightHeading:\n'),
    ...rightSegments,
    const ReportTextSegment('\n\n'),
    ReportTextSegment('$leftHeading:\n'),
    ...leftSegments,
    ReportTextSegment('\n\nЗАКЛЮЧЕНИЕ:\n$conclusionText'),
    if (recommendationText.isNotEmpty)
      ReportTextSegment('\n\nРЕКОМЕНДОВАНО:\n$recommendationText'),
  ];

  return GeneratedReport(
    descriptionText: descriptionText,
    conclusionText: conclusionText,
    recommendationText: recommendationText,
    fullText: fullText,
    previewSegments: previewSegments,
  );
}

String _sideHeading(BreastExamSide side) =>
    side.isRemoved ? side.side.removedHeading : side.side.fullLabel;

String _joinSegmentTexts(List<ReportTextSegment> segments) =>
    segments.map((s) => s.text).join();

/// Собирает описание стороны: дефолтные фразы и переопределения находок.
/// Переопределённые слоты помечаются [ReportTextSegment.emphasized].
List<ReportTextSegment> _buildSideDescriptionSegments(BreastExamSide side) {
  if (side.isRemoved) {
    return const [ReportTextSegment('Удалена')];
  }

  final slots = <DescriptionSlot, String>{
    for (final slot in DescriptionSlot.values)
      slot: slot.defaultText(side.density),
  };
  final overridden = <DescriptionSlot>{};

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
        overridden.add(slot);
      }
    }
    if (finding.calcificationTypes.contains(BenignCalcificationType.vascular)) {
      slots[DescriptionSlot.vesselCalcification] = 'Обызвествления сосудов да.';
      overridden.add(DescriptionSlot.vesselCalcification);
    }
  }

  final parts = <({String text, bool emphasized})>[
    (text: side.density.densitySentence, emphasized: false),
    for (final slot in DescriptionSlot.values)
      (text: slots[slot]!, emphasized: overridden.contains(slot)),
  ];

  final segments = <ReportTextSegment>[];
  for (final part in parts) {
    final text = part.text.trim().isEmpty ? '' : part.text;
    if (text.isEmpty) continue;
    if (segments.isNotEmpty) {
      segments.add(const ReportTextSegment(' '));
    }
    segments.add(ReportTextSegment(text, emphasized: part.emphasized));
  }
  return segments;
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
  final rightActive = !exam.right.isRemoved;
  final leftActive = !exam.left.isRemoved;
  final rightCat = rightActive ? _maxCategory(exam.right) : null;
  final leftCat = leftActive ? _maxCategory(exam.left) : null;

  final removedSentences = [
    if (exam.right.isRemoved) exam.right.side.removedConclusionSentence,
    if (exam.left.isRemoved) exam.left.side.removedConclusionSentence,
  ];

  if (!rightActive && !leftActive) {
    return removedSentences.join(' ');
  }

  final biRadsLine = _biRadsLine(
    rightActive: rightActive,
    leftActive: leftActive,
    rightCat: rightCat,
    leftCat: leftCat,
  );

  if (rightCat == null && leftCat == null) {
    return [
      ...removedSentences,
      'Без очаговой патологии.',
      biRadsLine,
    ].join('\n');
  }

  // Собираем тексты находок, дедуплицируя одинаковые строки
  // (например, двустороннее ФЖИ даёт одну строку). Находки с
  // combineBilateralSides склеиваются в «справа и слева».
  final findingTexts = <String>[];
  final consumedLeft = <int>{};
  final leftFindings = leftActive
      ? exam.left.findings
      : const <SelectedFinding>[];

  if (rightActive) {
    for (final finding in exam.right.findings) {
      final text = _conclusionTextFor(
        finding,
        side: exam.right.side,
        leftFindings: leftFindings,
        consumedLeft: consumedLeft,
      );
      if (text != null && !findingTexts.contains(text)) {
        findingTexts.add(text);
      }
    }
  }

  if (leftActive) {
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
  }

  final body = [...removedSentences, ...findingTexts].join(' ');

  if (body.isEmpty) return biRadsLine;
  return '$body\n$biRadsLine';
}

String _biRadsLine({
  required bool rightActive,
  required bool leftActive,
  required BiRadsCategory? rightCat,
  required BiRadsCategory? leftCat,
}) {
  if (rightActive && leftActive) {
    final rightLabel = rightCat?.code ?? 'BIRADS 1';
    final leftLabel = leftCat?.code ?? 'BIRADS 1';
    return rightLabel == leftLabel
        ? '$rightLabel справа и слева.'
        : '$rightLabel справа.\n$leftLabel слева.';
  }
  if (rightActive) return '${rightCat?.code ?? 'BIRADS 1'} справа.';
  if (leftActive) return '${leftCat?.code ?? 'BIRADS 1'} слева.';
  return '';
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

  final activeSides = [
    if (!exam.right.isRemoved) exam.right,
    if (!exam.left.isRemoved) exam.left,
  ];

  if (activeSides.any((s) => s.density.requiresAdjunctUltrasound)) {
    recommendations.add(
      'УЗИ молочных желёз (рентгенологически плотные железы).',
    );
  }

  for (final side in activeSides) {
    for (final finding in side.findings) {
      final rec = finding.findingType.recommendationFragment;
      if (rec != null) recommendations.add(rec);
    }
  }

  // followUpText берётся из максимальной категории BI-RADS каждой оставшейся стороны
  for (final side in activeSides) {
    final cat = _maxCategory(side);
    if (cat?.followUpText != null) followUps.add(cat!.followUpText!);
  }

  // Если патологии нет — стандартный интервал контроля 1 год
  if (activeSides.every((s) => s.findings.isEmpty)) {
    followUps.add('Динамический контроль через 1 год.');
  }

  return [...recommendations, ...followUps].join('\n');
}
