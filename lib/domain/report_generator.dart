import 'breast_exam_side.dart';
import 'description_slot.dart';
import 'generated_report.dart';
import 'mammography_catalog.dart';
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
      final override = finding.findingType.overrideFor(slot, quadrant: finding.quadrant);
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

class _ConclusionEntry {
  final String key;
  final String text;
  const _ConclusionEntry(this.key, this.text);
}

List<_ConclusionEntry> _pathologyEntries(BreastExamSide side) {
  final seen = <String>{};
  final entries = <_ConclusionEntry>[];
  for (final finding in side.findings) {
    if (!finding.findingType.isPathology) continue;
    final key = '${finding.findingType.id}|${finding.findingType.biradsCode ?? ''}';
    if (!seen.add(key)) continue;
    entries.add(_ConclusionEntry(key, finding.findingType.conclusionText));
  }
  return entries;
}

String _buildConclusion(MammographyExam exam) {
  final rightEntries = _pathologyEntries(exam.right);
  final leftEntries = _pathologyEntries(exam.left);

  if (rightEntries.isEmpty && leftEntries.isEmpty) {
    return 'Без очаговой патологии.\nBIRADS 1 справа и слева.';
  }

  final lines = <String>[];
  final usedRight = <int>{};
  final usedLeft = <int>{};

  for (var i = 0; i < rightEntries.length; i++) {
    for (var j = 0; j < leftEntries.length; j++) {
      if (usedLeft.contains(j)) continue;
      if (rightEntries[i].key == leftEntries[j].key) {
        lines.add('${rightEntries[i].text} справа и слева.');
        usedRight.add(i);
        usedLeft.add(j);
        break;
      }
    }
  }

  for (var i = 0; i < rightEntries.length; i++) {
    if (!usedRight.contains(i)) lines.add('${rightEntries[i].text} справа.');
  }
  for (var j = 0; j < leftEntries.length; j++) {
    if (!usedLeft.contains(j)) lines.add('${leftEntries[j].text} слева.');
  }

  return lines.join('\n');
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
      final followUp = finding.findingType.followUpText;
      if (followUp != null) followUps.add(followUp);
    }
  }

  // Ни одной находки не добавлено ни с одной стороны — по умолчанию это
  // равнозначно "Норме", поэтому подставляем стандартный интервал контроля
  // без необходимости явно добавлять чип "Норма".
  if (exam.right.findings.isEmpty && exam.left.findings.isEmpty) {
    final defaultFollowUp = normaFinding.followUpText;
    if (defaultFollowUp != null) followUps.add(defaultFollowUp);
  }

  return [...recommendations, ...followUps].join('\n');
}
