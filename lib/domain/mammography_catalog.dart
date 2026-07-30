import 'birads_category.dart';
import 'description_slot.dart';
import 'finding_type.dart';

/// Каталог находок для конструктора маммографических заключений.
///
/// Находки сгруппированы по категориям BI-RADS. Чтобы добавить новую
/// находку — добавьте один [FindingType] с нужной [BiRadsCategory].
/// UI (диалог выбора, показ "Сторона"/"Локализация"/"Размер") и генератор
/// текста подхватят её автоматически.
final List<FindingType> mammographyFindingCatalog = [
  // ─── Быстрые заключения (используются в "Частые заключения") ───
  const FindingType(
    id: 'fatty_involution',
    label: 'Фиброзно-жировая инволюция (ФЖИ)',
    isPathology: true,
    requiresLocalization: false,
    descriptionOverrides: {
      DescriptionSlot.structure:
          'Структура представлена преимущественно элементами жировой ткани с участками фиброза, что соответствует фиброзно-жировой инволюции.',
    },
    category: BiRadsCategory.birads2,
  ),
  const FindingType(
    id: 'fibrocystic_mastopathy',
    label: 'Фиброзно-кистозные изменения (ФКИ)',
    isPathology: true,
    requiresLocalization: false,
    descriptionOverrides: {
      DescriptionSlot.structure:
          'Структура представлена диффузным чередованием фиброзного, железистого и кистозного компонентов, что соответствует фиброзно-кистозным изменениям.',
    },
    category: BiRadsCategory.birads2,
  ),

  // ───────────────────────── BI-RADS 2 ─────────────────────────
  const FindingType(
    id: 'birads2_benign_mass',
    label: 'Доброкачественное образование',
    isPathology: true,
    requiresLocalization: true,
    requiresSize: true,
    descriptionOverrides: {
      DescriptionSlot.nodules:
          'Определяется округлое образование с четкими ровными контурами размером до {size} в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads2,
  ),
  const FindingType(
    id: 'birads2_calcifications',
    label: 'Доброкачественные обызвествления',
    isPathology: true,
    requiresLocalization: false,
    descriptionOverrides: {
      DescriptionSlot.calcifications:
          'Кальцинаты доброкачественные - да (распределение диффузное/региональное/единичное), злокачественные - нет.',
    },
    category: BiRadsCategory.birads2,
  ),
  const FindingType(
    id: 'birads2_intramammary_ln',
    label: 'Интрамаммарные лимфатические узлы',
    isPathology: true,
    requiresLocalization: true,
    descriptionOverrides: {
      DescriptionSlot.lymphNodes:
          'Определяются интрамаммарные лимфатические узлы в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads2,
  ),
  const FindingType(
    id: 'birads2_galactocele',
    label: 'Галактоцеле',
    isPathology: true,
    requiresLocalization: true,
    descriptionOverrides: {
      DescriptionSlot.nodules:
          'Определяется галактоцеле в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads2,
  ),
  const FindingType(
    id: 'birads2_hamartoma',
    label: 'Гамартома',
    isPathology: true,
    requiresLocalization: true,
    descriptionOverrides: {
      DescriptionSlot.nodules:
          'Определяется гамартома в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads2,
  ),
  const FindingType(
    id: 'birads2_implants',
    label: 'Имплантаты молочных желез',
    isPathology: true,
    requiresLocalization: false,
    descriptionOverrides: {
      DescriptionSlot.structure:
          'Определяются имплантаты молочных желез. Капсула без признаков деформации.',
    },
    category: BiRadsCategory.birads2,
  ),
  const FindingType(
    id: 'birads2_postop',
    label: 'Послеоперационные рубцовые изменения',
    isPathology: true,
    requiresLocalization: true,
    descriptionOverrides: {
      DescriptionSlot.architecture:
          'Нарушение архитектоники - да, рубцовые послеоперационные изменения в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads2,
  ),
  const FindingType(
    id: 'birads2_radiation_edema',
    label: 'Отек после лучевой терапии',
    isPathology: true,
    requiresLocalization: false,
    descriptionOverrides: {
      DescriptionSlot.skin:
          'Кожные покровы утолщены, отечны, что может соответствовать изменениям после лучевой терапии.',
    },
    category: BiRadsCategory.birads2,
  ),

  // ───────────────────────── BI-RADS 3 ─────────────────────────
  const FindingType(
    id: 'birads3_fibroadenoma',
    label: 'Фиброаденома?',
    isPathology: true,
    requiresLocalization: true,
    requiresSize: true,
    descriptionOverrides: {
      DescriptionSlot.nodules:
          'Определяется образование с четкими контурами, предположительно соответствующее фиброаденоме, размером до {size} в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads3,
  ),
  const FindingType(
    id: 'birads3_cyst',
    label: 'Киста?',
    isPathology: true,
    requiresLocalization: true,
    requiresSize: true,
    descriptionOverrides: {
      DescriptionSlot.nodules:
          'Определяется образование с четкими контурами, предположительно соответствующее кисте, размером до {size} в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads3,
  ),
  const FindingType(
    id: 'birads3_focal_asymmetry',
    label: 'Очаговая асимметрия ткани',
    isPathology: true,
    requiresLocalization: true,
    descriptionOverrides: {
      DescriptionSlot.asymmetry:
          'Участков ассиметрии - да, определяется очаговая асимметрия ткани в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads3,
  ),
  const FindingType(
    id: 'birads3_microcalcifications',
    label: 'Единичная группа точечных микрокальцинатов',
    isPathology: true,
    requiresLocalization: true,
    descriptionOverrides: {
      DescriptionSlot.calcifications:
          'Кальцинаты доброкачественные - нет, определяется единичная группа точечных микрокальцинатов в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads3,
  ),
  const FindingType(
    id: 'birads3_mastitis',
    label: 'Мастит',
    isPathology: true,
    requiresLocalization: false,
    descriptionOverrides: {
      DescriptionSlot.structure:
          'Структура неоднородная, определяются признаки воспалительных изменений (мастит).',
    },
    category: BiRadsCategory.birads3,
  ),
  const FindingType(
    id: 'birads3_nipple_retraction',
    label: 'Втяжение соска',
    isPathology: true,
    requiresLocalization: false,
    descriptionOverrides: {
      DescriptionSlot.skin:
          'Определяется втяжение соска без видимого объемного образования.',
    },
    category: BiRadsCategory.birads3,
  ),

  // ───────────────────────── BI-RADS 4а ─────────────────────────
  const FindingType(
    id: 'birads4a_atypical_fibroadenoma',
    label: 'Образование с частично размытым контуром (атипичная фиброаденома)',
    isPathology: true,
    requiresLocalization: true,
    requiresSize: true,
    descriptionOverrides: {
      DescriptionSlot.nodules:
          'Определяется объемное образование с частично размытым контуром размером до {size} в проекции {quadrant}, не исключается атипичная фиброаденома.',
    },
    category: BiRadsCategory.birads4a,
  ),
  const FindingType(
    id: 'birads4a_local_asymmetry',
    label: 'Локальная асимметрия',
    isPathology: true,
    requiresLocalization: true,
    descriptionOverrides: {
      DescriptionSlot.asymmetry:
          'Участков ассиметрии - да, определяется локальная асимметрия ткани в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads4a,
    recommendationFragment:
        'Дообследование: прицельная рентгенография с компрессией и/или УЗИ молочных желёз для уточнения характера выявленных изменений.',
  ),
  const FindingType(
    id: 'birads4a_architecture_distortion',
    label: 'Нарушение архитектоники',
    isPathology: true,
    requiresLocalization: true,
    descriptionOverrides: {
      DescriptionSlot.architecture:
          'Нарушение архитектоники - да, в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads4a,
  ),
  const FindingType(
    id: 'birads4a_abscess',
    label: 'Абсцесс',
    isPathology: true,
    requiresLocalization: true,
    requiresSize: true,
    descriptionOverrides: {
      DescriptionSlot.nodules:
          'Определяется образование с нечеткими контурами размером до {size} в проекции {quadrant}, соответствующее абсцессу.',
    },
    category: BiRadsCategory.birads4a,
  ),

  // ───────────────────────── BI-RADS 4б ─────────────────────────
  const FindingType(
    id: 'birads4b_amorphous_calcifications',
    label: 'Сгруппированные аморфные/плеоморфные микрокальцинаты',
    isPathology: true,
    requiresLocalization: true,
    descriptionOverrides: {
      DescriptionSlot.calcifications:
          'Кальцинаты - да, определяются сгруппированные аморфные или мелкие плеоморфные микрокальцинаты в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads4b,
  ),
  const FindingType(
    id: 'birads4b_indistinct_mass',
    label: 'Образование с нечеткими краями',
    isPathology: true,
    requiresLocalization: true,
    requiresSize: true,
    descriptionOverrides: {
      DescriptionSlot.nodules:
          'Определяется образование с нечеткими краями размером до {size} в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads4b,
  ),
  const FindingType(
    id: 'birads4b_growing_mass',
    label: 'Увеличение размеров ранее выявленного образования',
    isPathology: true,
    requiresLocalization: true,
    requiresSize: true,
    descriptionOverrides: {
      DescriptionSlot.nodules:
          'Определяется увеличение размеров ранее выявленного образования до {size} в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads4b,
  ),
  const FindingType(
    id: 'birads4b_ductography_defect',
    label: 'Дефекты наполнения при дуктографии',
    isPathology: true,
    requiresLocalization: false,
    descriptionOverrides: {
      DescriptionSlot.nodules:
          'При дуктографии определяются дефекты наполнения.',
    },
    category: BiRadsCategory.birads4b,
  ),
  const FindingType(
    id: 'birads4b_suspicious_ln',
    label: 'Л/у с подозрением на метастатическое поражение',
    isPathology: true,
    requiresLocalization: true,
    descriptionOverrides: {
      DescriptionSlot.lymphNodes:
          'Определяется увеличенный лимфатический узел с подозрением на метастатическое поражение в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads4b,
  ),

  // ───────────────────────── BI-RADS 4в ─────────────────────────
  const FindingType(
    id: 'birads4c_pleomorphic_calcifications',
    label: 'Скопление плеоморфных микрокальцинатов (нарастание в динамике)',
    isPathology: true,
    requiresLocalization: true,
    descriptionOverrides: {
      DescriptionSlot.calcifications:
          'Кальцинаты - да, определяется скопление плеоморфных микрокальцинатов с увеличением количества в динамике в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads4c,
  ),
  const FindingType(
    id: 'birads4c_malignant_mass',
    label: 'Узловое образование с признаками рака',
    isPathology: true,
    requiresLocalization: true,
    requiresSize: true,
    descriptionOverrides: {
      DescriptionSlot.nodules:
          'Определяется узловое образование с признаками рака размером до {size} в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads4c,
  ),

  // ───────────────────────── BI-RADS 5 ─────────────────────────
  const FindingType(
    id: 'birads5_spiculated_mass',
    label: 'Образование высокой плотности с неровными лучистыми контурами',
    isPathology: true,
    requiresLocalization: true,
    requiresSize: true,
    descriptionOverrides: {
      DescriptionSlot.nodules:
          'Определяется объемное образование высокой плотности с неровными лучистыми контурами размером до {size} в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads5,
  ),
  const FindingType(
    id: 'birads5_linear_calcifications',
    label: 'Сегментарное/линейное распределение мелких линейных и плеоморфных кальцинатов',
    isPathology: true,
    requiresLocalization: true,
    descriptionOverrides: {
      DescriptionSlot.calcifications:
          'Кальцинаты - да, определяется сегментарное или линейное распределение мелких линейных и плеоморфных кальцинатов в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads5,
  ),
  const FindingType(
    id: 'birads5_spiculated_with_calcifications',
    label: 'Образование с лучистым контуром в сочетании с плеоморфными кальцинатами',
    isPathology: true,
    requiresLocalization: true,
    requiresSize: true,
    descriptionOverrides: {
      DescriptionSlot.nodules:
          'Определяется объемное образование с неровным лучистым контуром размером до {size} в проекции {quadrant}.',
      DescriptionSlot.calcifications:
          'Кальцинаты - да, плеоморфные, в сочетании с выявленным образованием.',
    },
    category: BiRadsCategory.birads5,
  ),

  // ───────────────────────── BI-RADS 6 ─────────────────────────
  const FindingType(
    id: 'birads6_verified_cancer',
    label: 'Верифицированный неоперированный рак молочной железы',
    isPathology: true,
    requiresLocalization: false,
    descriptionOverrides: {
      DescriptionSlot.nodules:
          'Определяются признаки верифицированного неоперированного рака молочной железы.',
    },
    category: BiRadsCategory.birads6,
  ),
];

FindingType findingById(String id) =>
    mammographyFindingCatalog.firstWhere((f) => f.id == id);

List<FindingType> findingsByCategory(BiRadsCategory category) =>
    mammographyFindingCatalog.where((f) => f.category == category).toList();
