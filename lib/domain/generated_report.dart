/// Итог работы генератора: готовые тексты для копирования.
class GeneratedReport {
  final String descriptionText;
  final String conclusionText;
  final String recommendationText;
  final String fullText;

  const GeneratedReport({
    required this.descriptionText,
    required this.conclusionText,
    required this.recommendationText,
    required this.fullText,
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
