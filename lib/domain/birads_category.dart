/// Категории BI-RADS, используемые в маммографических заключениях.
///
/// [rank] используется для определения наивысшей категории при наличии
/// нескольких находок в одной молочной железе.
enum BiRadsCategory {
  birads2('BI-RADS 2', 'BIRADS 2', 2, 'Динамический контроль через 1 год.'),
  birads3('BI-RADS 3', 'BIRADS 3', 3, 'Контроль через 6 месяцев.'),
  birads4a('BI-RADS 4а', 'BIRADS 4а', 4, null),
  birads4b('BI-RADS 4б', 'BIRADS 4б', 5, null),
  birads4c('BI-RADS 4в', 'BIRADS 4в', 6, null),
  birads5('BI-RADS 5', 'BIRADS 5', 7, null),
  birads6('BI-RADS 6', 'BIRADS 6', 8, null);

  final String label;
  final String code;
  final int rank;
  final String? followUpText;

  const BiRadsCategory(this.label, this.code, this.rank, this.followUpText);
}
