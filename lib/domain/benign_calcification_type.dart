/// Морфологический тип доброкачественных кальцинатов.
enum BenignCalcificationType {
  vascular,
  round,
  coarse;

  /// Подпись в UI (чипы).
  String get label => switch (this) {
    BenignCalcificationType.vascular => 'Сосудистые',
    BenignCalcificationType.round => 'Круглые',
    BenignCalcificationType.coarse => 'Крупные',
  };

  /// Форма для подстановки в текст описания (согласуется с «кальцинаты»).
  String get inTextForm => switch (this) {
    BenignCalcificationType.vascular => 'сосудистые',
    BenignCalcificationType.round => 'круглые',
    BenignCalcificationType.coarse => 'крупные',
  };
}
