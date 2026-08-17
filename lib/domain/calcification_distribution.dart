/// Распределение доброкачественных кальцинатов по BI-RADS.
enum CalcificationDistribution {
  diffuse,
  regional,
  single;

  /// Подпись в UI (чипы).
  String get label => switch (this) {
    CalcificationDistribution.diffuse => 'Диффузное',
    CalcificationDistribution.regional => 'Региональное',
    CalcificationDistribution.single => 'Единичное',
  };

  /// Форма для подстановки в текст описания.
  String get inTextForm => switch (this) {
    CalcificationDistribution.diffuse => 'диффузное',
    CalcificationDistribution.regional => 'региональное',
    CalcificationDistribution.single => 'единичное',
  };
}
