/// Фрагмент текста предпросмотра: обычный или выделенный (жирный курсив в UI).
class ReportTextSegment {
  final String text;
  final bool emphasized;

  const ReportTextSegment(this.text, {this.emphasized = false});
}

/// Итог работы генератора: готовые тексты для копирования.
class GeneratedReport {
  final String descriptionText;
  final String conclusionText;
  final String recommendationText;
  final String fullText;

  /// Сегменты для предпросмотра: [emphasized] — фразы из переопределений находок.
  final List<ReportTextSegment> previewSegments;

  const GeneratedReport({
    required this.descriptionText,
    required this.conclusionText,
    required this.recommendationText,
    required this.fullText,
    this.previewSegments = const [],
  });

  /// Текст для буфера обмена: как [fullText], но без заголовка «ЗАКЛЮЧЕНИЕ:».
  String get textForClipboard => reportTextForClipboard(fullText);
}

/// Убирает заголовок «ЗАКЛЮЧЕНИЕ:» из готового текста отчёта.
String reportTextForClipboard(String reportText) {
  return reportText
      .replaceFirst(RegExp(r'^ЗАКЛЮЧЕНИЕ:\s*', multiLine: true), '')
      .trim();
}
