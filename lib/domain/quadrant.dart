/// 8 стандартных вариантов локализации в молочной железе:
/// квадранты и границы между ними.
enum Quadrant {
  upperOuter,
  upperInner,
  lowerOuter,
  lowerInner,
  centralZone,
  upperQuadrantsBorder,
  lowerQuadrantsBorder,
  retroareolarZone;

  /// Короткая подпись для UI (чипы, дропдауны).
  String get label => switch (this) {
        Quadrant.upperOuter => 'Верхне-наружный квадрант (ВНК)',
        Quadrant.upperInner => 'Верхне-внутренний квадрант (ВВК)',
        Quadrant.lowerOuter => 'Нижне-наружный квадрант (ННК)',
        Quadrant.lowerInner => 'Нижне-внутренний квадрант (НВК)',
        Quadrant.centralZone => 'Центральная зона',
        Quadrant.upperQuadrantsBorder => 'Граница верхних квадрантов',
        Quadrant.lowerQuadrantsBorder => 'Граница нижних квадрантов',
        Quadrant.retroareolarZone => 'Ретроареолярная зона',
      };

  /// Форма для подстановки в текст описания, например
  /// "...в проекции верхне-наружного квадранта.".
  String get inTextForm => switch (this) {
        Quadrant.upperOuter => 'верхне-наружного квадранта',
        Quadrant.upperInner => 'верхне-внутреннего квадранта',
        Quadrant.lowerOuter => 'нижне-наружного квадранта',
        Quadrant.lowerInner => 'нижне-внутреннего квадранта',
        Quadrant.centralZone => 'центральной зоны',
        Quadrant.upperQuadrantsBorder => 'границы верхних квадрантов',
        Quadrant.lowerQuadrantsBorder => 'границы нижних квадрантов',
        Quadrant.retroareolarZone => 'ретроареолярной зоны',
      };
}
