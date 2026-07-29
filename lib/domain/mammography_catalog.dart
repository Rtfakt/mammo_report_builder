import 'description_slot.dart';
import 'finding_type.dart';

/// Каталог находок для конструктора маммографических заключений (MVP).
///
/// Это единственное место, которое нужно редактировать, чтобы добавить
/// новую категорию BI-RADS: просто добавьте новый [FindingType] в список.
/// UI (список выбора, показ "Сторона"/"Локализация") и генератор текста
/// подхватят её автоматически.
///
/// Формулировки и коды BIRADS ниже — по стандартной лучевой терминологии,
/// перед реальным использованием рекомендуется вычитать их как врачу-эксперту.
final List<FindingType> mammographyFindingCatalog = [
  const FindingType(
    id: 'norma',
    label: 'Норма',
    isPathology: false,
    requiresLocalization: false,
    biradsCode: null,
    followUpText: 'Динамический контроль через 1 год.',
  ),
  const FindingType(
    id: 'local_asymmetry',
    label: 'Локальная асимметрия',
    isPathology: true,
    requiresLocalization: true,
    descriptionOverrides: {
      DescriptionSlot.asymmetry:
          'Участков ассиметрии - да, определяется локальная асимметрия ткани в проекции {quadrant}.',
    },
    biradsCode: 'BIRADS 0',
    recommendationFragment:
        'Дообследование: прицельная рентгенография с компрессией и/или УЗИ молочных желёз для уточнения характера выявленных изменений.',
  ),
  const FindingType(
    id: 'fatty_involution',
    label: 'Фиброзно-жировая инволюция (ФЖИ)',
    isPathology: true,
    requiresLocalization: false,
    descriptionOverrides: {
      DescriptionSlot.structure:
          'Структура представлена преимущественно элементами жировой ткани с участками фиброза, что соответствует фиброзно-жировой инволюции.',
    },
    biradsCode: 'BIRADS 2',
    followUpText: 'Динамический контроль через 1 год.',
  ),
  const FindingType(
    id: 'fibrocystic_mastopathy',
    label: 'Фиброзно-кистозная мастопатия (ФКМ)',
    isPathology: true,
    requiresLocalization: false,
    descriptionOverrides: {
      DescriptionSlot.structure:
          'Структура представлена диффузным чередованием фиброзного, железистого и кистозного компонентов, что соответствует фиброзно-кистозной мастопатии.',
    },
    biradsCode: 'BIRADS 2',
    followUpText: 'Динамический контроль через 1 год.',
  ),
];

FindingType findingById(String id) =>
    mammographyFindingCatalog.firstWhere((f) => f.id == id);

FindingType get normaFinding => findingById('norma');
