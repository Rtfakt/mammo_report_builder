import 'birads_category.dart';
import 'description_slot.dart';
import 'finding_type.dart';

/// Каталог находок для конструктора маммографических заключений.
///
/// Находки сгруппированы по категориям BI-RADS. Чтобы добавить новую
/// находку — добавьте один [FindingType] с нужной [BiRadsCategory].
/// UI (диалог выбора, показ "Сторона"/"Локализация"/"Размер"/
/// "Распределение"/"Расположение импланта") и генератор текста
/// подхватят её автоматически.
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
    conclusionFragment: 'Признаки фиброзно-жировой инволюции молочных желёз.',
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
    recommendationFragment: 'Рекомендовано УЗИ молочных желёз.',
    conclusionFragment: 'Признаки фиброзно-кистозных изменений молочных желёз.',
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
          'В проекции {quadrant} определяется округлое образование с четкими ровными контурами размером до {size} ',
    },
    category: BiRadsCategory.birads2,
    conclusionFragment:
        'Признаки доброкачественного образования {side} молочной железы',
  ),
  const FindingType(
    id: 'birads2_calcifications',
    label: 'Кальцинаты доброкачественные',
    isPathology: true,
    requiresLocalization: false,
    requiresCalcificationDetails: true,
    defaultsToBothSides: true,
    descriptionOverrides: {
      DescriptionSlot.calcifications:
          'Кальцинаты доброкачественные - да (распределение {distribution}, {calcificationType}), злокачественные - нет.',
    },
    category: BiRadsCategory.birads2,
    conclusionFragment: 'Доброкачественные обызвествления молочных желёз.',
  ),
  const FindingType(
    id: 'birads2_intramammary_ln',
    label: 'Интрамаммарные лимфатические узлы',
    isPathology: true,
    requiresLocalization: true,
    requiresSize: true,
    descriptionOverrides: {
      DescriptionSlot.lymphNodes:
          'Определяются интрамаммарные лимфатические узлы размером до {size} в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads2,
    conclusionFragment:
        'Интрамаммарные лимфатические узлы {side} молочной железы.',
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
    conclusionFragment: 'Галактоцеле {side} молочной железы.',
  ),
  const FindingType(
    id: 'birads2_hamartoma',
    label: 'Гамартома',
    isPathology: true,
    requiresLocalization: true,
    descriptionOverrides: {
      DescriptionSlot.nodules: 'Определяется гамартома в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads2,
    conclusionFragment: 'Признаки гамартомы в {side} молочной железы.',
  ),
  const FindingType(
    id: 'birads2_implants',
    label: 'Импланты',
    isPathology: true,
    requiresLocalization: false,
    requiresImplantPlacement: true,
    defaultsToBothSides: true,
    combineBilateralSides: true,
    descriptionOverrides: {
      DescriptionSlot.implants:
          '{implantAdverb} визуализируется тень эндопротеза, положение его правильное, форма округлая, целостность импланта не нарушена.',
    },
    category: BiRadsCategory.birads2,
    conclusionFragment: '{implantAdjective} импланты молочной железы {sides}.',
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
    conclusionFragment:
        'Послеоперационные рубцовые изменения {side} молочной железы в проекции {quadrant}.',
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
    conclusionFragment: 'Признаки постлучевых изменений молочных желёз.',
  ),

  // ───────────────────────── BI-RADS 3 ─────────────────────────
  const FindingType(
    id: 'birads3_fibroadenoma',
    label: 'Фиброаденома? Киста?',
    isPathology: true,
    requiresLocalization: true,
    requiresSize: true,
    descriptionOverrides: {
      DescriptionSlot.nodules:
          'В проекции {quadrant} определяется округлое образование с четкими контурами, размером до {size}  может соответствовать фиброаденоме или кисте, ',
    },
    category: BiRadsCategory.birads3,
    conclusionFragment: 'Фиброаденома? Киста? в {side} молочной железе',
  ),
  const FindingType(
    id: 'birads3_focal_asymmetry',
    label: 'Очаговая асимметрия ткани',
    isPathology: true,
    requiresLocalization: true,
    descriptionOverrides: {
      DescriptionSlot.asymmetry:
          'Участков ассиметрии - да, определяется очаговая асимметрия неправильной формы в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads3,
    conclusionFragment:
        'Очаговая асимметрия ткани {side} молочной железы в проекции {quadrant}.',
  ),
  const FindingType(
    id: 'birads3_microcalcifications',
    label: 'Единичная группа точечных микрокальцинатов',
    isPathology: true,
    requiresLocalization: true,
    descriptionOverrides: {
      DescriptionSlot.calcifications:
          'Определяется единичная группа точечных микрокальцинатов в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads3,
    conclusionFragment:
        'Единичная группа точечных микрокальцинатов в {side} молочной железе в проекции {quadrant}.',
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
    conclusionFragment:
        'Признаки воспалительных изменений {side} молочной железы (мастит).',
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
    conclusionFragment:
        'Втяжение соска {side} молочной железы без видимого объёмного образования.',
  ),

  // ───────────────────────── BI-RADS 4a ─────────────────────────
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
    conclusionFragment:
        'Рентген-картина атипичной фиброаденомы {side} молочной железы',
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
    conclusionFragment: 'Локальная асимметрия ткани {side} молочной железы',
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
    conclusionFragment:
        'Нарушение архитектоники {side} молочной железы в проекции {quadrant}.',
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
    conclusionFragment: 'Абсцесс {side} молочной железы в проекции.',
  ),

  // ───────────────────────── BI-RADS 4b ─────────────────────────
  const FindingType(
    id: 'birads4b_amorphous_calcifications',
    label: 'Сгруппированные аморфные/плеоморфные микрокальцинаты',
    isPathology: true,
    requiresLocalization: true,
    descriptionOverrides: {
      DescriptionSlot.calcifications:
          'Злокачественные кальцинаты - да, определяются сгруппированные аморфные или мелкие плеоморфные микрокальцинаты в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads4b,
    conclusionFragment:
        'Сгруппированные аморфные/плеоморфные микрокальцинаты в {side} молочной железе в проекции {quadrant}.',
  ),
  const FindingType(
    id: 'birads4b_indistinct_mass',
    label: 'Образование с нечеткими краями',
    isPathology: true,
    requiresLocalization: true,
    requiresSize: true,
    descriptionOverrides: {
      DescriptionSlot.nodules:
          'Определяется образование с нечеткими контурами размером до {size} в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads4b,
    conclusionFragment:
        'Рентген-картина недифференцированного солидного образования с нечетко выраженными краями',
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
    conclusionFragment:
        'Увеличение размеров ранее выявленного образования до {size} в проекции {quadrant} {side} молочной железы.',
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
    conclusionFragment:
        'Дефекты наполнения {side} молочной железы при дуктографии.',
  ),
  const FindingType(
    id: 'birads4b_suspicious_ln',
    label: 'Л/у с подозрением на метастатическое поражение',
    isPathology: true,
    requiresLocalization: true,
    requiresSize: true,
    descriptionOverrides: {
      DescriptionSlot.lymphNodes:
          'Определяется увеличенный лимфатический узел размером до {size} в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads4b,
    conclusionFragment:
        'Рентген-картина увеличенных лимфатических узлов {side} молочной железы.',
  ),

  // ───────────────────────── BI-RADS 4c ─────────────────────────
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
    conclusionFragment:
        'Скопление плеоморфных микрокальцинатов с нарастанием в динамике в {side} молочной железе.',
  ),
  const FindingType(
    id: 'birads4c_malignant_mass',
    label: 'Узловое образование с признаками рака',
    isPathology: true,
    requiresLocalization: true,
    requiresSize: true,
    descriptionOverrides: {
      DescriptionSlot.nodules:
          'Определяется узловое образование с лучистыми контурами размером до {size} в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads4c,
    conclusionFragment:
        'Узловое образование с признаками рака размером до {size} в {side} молочной железе.',
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
    conclusionFragment:
        'Объёмное образование высокой плотности с неровными лучистыми контурами размером до {size} в {side} молочной железе в проекции {quadrant}.',
  ),
  const FindingType(
    id: 'birads5_linear_calcifications',
    label:
        'Сегментарное/линейное распределение мелких линейных и плеоморфных кальцинатов',
    isPathology: true,
    requiresLocalization: true,
    descriptionOverrides: {
      DescriptionSlot.calcifications:
          'Кальцинаты - да, определяется сегментарное или линейное распределение мелких линейных и плеоморфных кальцинатов в проекции {quadrant}.',
    },
    category: BiRadsCategory.birads5,
    conclusionFragment:
        'Сегментарное/линейное распределение мелких линейных и плеоморфных кальцинатов в {side} молочной железе в проекции {quadrant}.',
  ),
  const FindingType(
    id: 'birads5_spiculated_with_calcifications',
    label:
        'Образование с лучистым контуром в сочетании с плеоморфными кальцинатами',
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
    conclusionFragment:
        'Объёмное образование с неровным лучистым контуром размером до {size} с плеоморфными кальцинатами в {side} молочной железе в проекции {quadrant}.',
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
    conclusionFragment:
        'Верифицированный неоперированный рак {side} молочной железы.',
  ),
];

FindingType findingById(String id) =>
    mammographyFindingCatalog.firstWhere((f) => f.id == id);

List<FindingType> findingsByCategory(BiRadsCategory category) =>
    mammographyFindingCatalog.where((f) => f.category == category).toList();
