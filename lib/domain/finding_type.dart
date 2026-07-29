import 'description_slot.dart';
import 'quadrant.dart';

/// Конфигурация одной находки из каталога BI-RADS ("Патология / Заключение").
///
/// Чтобы добавить новую находку — достаточно добавить один экземпляр
/// [FindingType] в `mammography_catalog.dart`. UI и генератор текста
/// не нужно менять: видимость полей "Сторона" и "Локализация" и содержимое
/// текста управляются флагами и шаблонами ниже.
class FindingType {
  /// Стабильный идентификатор для хранения/сериализации (не меняйте после
  /// того как находка уже где-то сохранена в истории).
  final String id;

  /// Название в UI и в тексте заключения (регистр как для показа в UI;
  /// в заключении будет приведено к верхнему регистру).
  final String label;

  /// "Норма" — единственная находка, для которой это false: тогда поле
  /// "Сторона" не показывается (находка описывает только текущую панель).
  final bool isPathology;

  /// Показывать ли селектор квадранта при добавлении находки.
  final bool requiresLocalization;

  /// Переопределения строк-чеклиста блока "Описание". Строка может
  /// содержать плейсхолдер `{quadrant}`, который будет заменён на
  /// текстовую форму выбранного квадранта.
  final Map<DescriptionSlot, String> descriptionOverrides;

  /// Код BI-RADS, используемый при построении "Заключения".
  /// `null` — находка не добавляет отдельную строку в заключение (Норма).
  final String? biradsCode;

  /// Дополнительная рекомендация, специфичная для находки
  /// (например, дообследование при локальной асимметрии).
  final String? recommendationFragment;

  /// Текст интервала динамического контроля по умолчанию для этой находки.
  final String? followUpText;

  const FindingType({
    required this.id,
    required this.label,
    required this.isPathology,
    required this.requiresLocalization,
    this.descriptionOverrides = const {},
    this.biradsCode,
    this.recommendationFragment,
    this.followUpText,
  });

  /// Строка для "Заключения", например "ЛОКАЛЬНАЯ АСИММЕТРИЯ (BIRADS 0)".
  String get conclusionText =>
      biradsCode == null ? label.toUpperCase() : '${label.toUpperCase()} ($biradsCode)';

  String? overrideFor(DescriptionSlot slot, {Quadrant? quadrant}) {
    final template = descriptionOverrides[slot];
    if (template == null) return null;
    if (quadrant == null) return template;
    return template.replaceAll('{quadrant}', quadrant.inTextForm);
  }
}
