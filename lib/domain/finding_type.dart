import 'birads_category.dart';
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

  /// Показывать ли поле ввода размера образования при добавлении находки.
  final bool requiresSize;

  /// Переопределения строк-чеклиста блока "Описание". Строка может
  /// содержать плейсхолдеры `{quadrant}` и `{size}`, которые будут заменены
  /// на соответствующие значения из [SelectedFinding].
  final Map<DescriptionSlot, String> descriptionOverrides;

  /// Категория BI-RADS, к которой относится находка.
  /// `null` — находка не добавляет отдельную строку в заключение (Норма).
  final BiRadsCategory? category;

  /// Дополнительная рекомендация, специфичная для находки
  /// (например, дообследование при локальной асимметрии).
  final String? recommendationFragment;

  const FindingType({
    required this.id,
    required this.label,
    required this.isPathology,
    required this.requiresLocalization,
    this.requiresSize = false,
    this.descriptionOverrides = const {},
    this.category,
    this.recommendationFragment,
  });

  /// Строка для "Заключения", например "ЛОКАЛЬНАЯ АСИММЕТРИЯ (BIRADS 4а)".
  String get conclusionText =>
      category == null ? label.toUpperCase() : '${label.toUpperCase()} (${category!.code})';

  String? overrideFor(DescriptionSlot slot, {Quadrant? quadrant, String? size}) {
    final template = descriptionOverrides[slot];
    if (template == null) return null;
    var result = template;
    if (quadrant != null) result = result.replaceAll('{quadrant}', quadrant.inTextForm);
    result = result.replaceAll('{size}', size?.isNotEmpty == true ? size! : '__ мм');
    return result;
  }
}
