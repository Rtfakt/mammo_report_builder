import 'benign_calcification_type.dart';
import 'birads_category.dart';
import 'calcification_distribution.dart';
import 'description_slot.dart';
import 'quadrant.dart';

/// Конфигурация одной находки из каталога BI-RADS ("Патология / Заключение").
///
/// Чтобы добавить новую находку — достаточно добавить один экземпляр
/// [FindingType] в `mammography_catalog.dart`. UI и генератор текста
/// не нужно менять: видимость полей "Сторона"/"Локализация"/"Размер"/
/// "Распределение" и содержимое текста управляются флагами и шаблонами ниже.
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

  /// Показывать ли поля распределения и типа кальцинатов.
  final bool requiresCalcificationDetails;

  /// Переопределения строк-чеклиста блока "Описание". Строка может
  /// содержать плейсхолдеры `{quadrant}`, `{size}`, `{distribution}` и
  /// `{calcificationType}`, которые будут заменены на соответствующие
  /// значения из [SelectedFinding].
  final Map<DescriptionSlot, String> descriptionOverrides;

  /// Категория BI-RADS, к которой относится находка.
  /// `null` — находка не добавляет отдельную строку в заключение (Норма).
  final BiRadsCategory? category;

  /// Дополнительная рекомендация, специфичная для находки
  /// (например, дообследование при локальной асимметрии).
  final String? recommendationFragment;

  /// Шаблон текста для раздела ЗАКЛЮЧЕНИЕ. Поддерживает плейсхолдеры
  /// `{side}` (родительный падеж: "правой"/"левой"), `{quadrant}`, `{size}`,
  /// `{distribution}`, `{calcificationType}`.
  final String? conclusionFragment;

  const FindingType({
    required this.id,
    required this.label,
    required this.isPathology,
    required this.requiresLocalization,
    this.requiresSize = false,
    this.requiresCalcificationDetails = false,
    this.descriptionOverrides = const {},
    this.category,
    this.recommendationFragment,
    this.conclusionFragment,
  });

  /// Возвращает текст заключения с подставленными значениями,
  /// либо `null` если [conclusionFragment] не задан.
  String? conclusionFor({
    required String sideLabel,
    Quadrant? quadrant,
    String? size,
    CalcificationDistribution? calcificationDistribution,
    List<BenignCalcificationType> calcificationTypes = const [],
  }) {
    if (conclusionFragment == null) return null;
    return _applyPlaceholders(
      conclusionFragment!,
      sideLabel: sideLabel,
      quadrant: quadrant,
      size: size,
      calcificationDistribution: calcificationDistribution,
      calcificationTypes: calcificationTypes,
    );
  }

  String? overrideFor(
    DescriptionSlot slot, {
    Quadrant? quadrant,
    String? size,
    CalcificationDistribution? calcificationDistribution,
    List<BenignCalcificationType> calcificationTypes = const [],
  }) {
    final template = descriptionOverrides[slot];
    if (template == null) return null;
    return _applyPlaceholders(
      template,
      sideLabel: '',
      quadrant: quadrant,
      size: size,
      calcificationDistribution: calcificationDistribution,
      calcificationTypes: calcificationTypes,
    );
  }

  String _applyPlaceholders(
    String template, {
    required String sideLabel,
    Quadrant? quadrant,
    String? size,
    CalcificationDistribution? calcificationDistribution,
    required List<BenignCalcificationType> calcificationTypes,
  }) {
    var result = template;
    result = result.replaceAll('{side}', sideLabel);
    if (quadrant != null) {
      result = result.replaceAll('{quadrant}', quadrant.inTextForm);
    }
    result = result.replaceAll(
      '{size}',
      size?.isNotEmpty == true ? size! : '__ мм',
    );
    if (calcificationDistribution != null) {
      result = result.replaceAll(
        '{distribution}',
        calcificationDistribution.inTextForm,
      );
    }
    if (calcificationTypes.isNotEmpty) {
      result = result.replaceAll(
        '{calcificationType}',
        calcificationTypes.map((t) => t.inTextForm).join(', '),
      );
    }
    return result;
  }
}
