import 'package:flutter_test/flutter_test.dart';
import 'package:mammo_report_builder/domain/acr_density.dart';
import 'package:mammo_report_builder/domain/benign_calcification_type.dart';
import 'package:mammo_report_builder/domain/breast_exam_side.dart';
import 'package:mammo_report_builder/domain/breast_side.dart';
import 'package:mammo_report_builder/domain/calcification_distribution.dart';
import 'package:mammo_report_builder/domain/implant_placement.dart';
import 'package:mammo_report_builder/domain/mammography_catalog.dart';
import 'package:mammo_report_builder/domain/mammography_exam.dart';
import 'package:mammo_report_builder/domain/quadrant.dart';
import 'package:mammo_report_builder/domain/report_generator.dart';
import 'package:mammo_report_builder/domain/selected_finding.dart';

void main() {
  group('generateMammographyReport', () {
    test(
      'обе стороны без находок -> норма, BIRADS 1, без доп. рекомендаций по УЗИ',
      () {
        final exam = MammographyExam(
          right: const BreastExamSide(
            side: BreastSide.right,
            density: AcrDensity.b,
          ),
          left: const BreastExamSide(
            side: BreastSide.left,
            density: AcrDensity.b,
          ),
        );

        final report = generateMammographyReport(exam);

        expect(
          report.conclusionText,
          'Без очаговой патологии.\nBIRADS 1 справа и слева.',
        );
        expect(
          report.recommendationText,
          contains('Динамический контроль через 1 год.'),
        );
        expect(
          report.recommendationText,
          isNot(contains('УЗИ молочных желёз')),
        );
        expect(report.descriptionText, contains('ПРАВАЯ МОЛОЧНАЯ ЖЕЛЕЗА'));
        expect(report.descriptionText, contains('ЛЕВАЯ МОЛОЧНАЯ ЖЕЛЕЗА'));
      },
    );

    test(
      'одинаковая находка ACR-D с обеих сторон -> объединяются в одну строку заключения, как в реальном примере',
      () {
        final finding = SelectedFinding(
          findingType: findingById('fibrocystic_mastopathy'),
        );
        final exam = MammographyExam(
          right: BreastExamSide(
            side: BreastSide.right,
            density: AcrDensity.d,
            findings: [finding],
          ),
          left: BreastExamSide(
            side: BreastSide.left,
            density: AcrDensity.d,
            findings: [finding],
          ),
        );

        final report = generateMammographyReport(exam);

        expect(
          report.conclusionText,
          'ФИБРОЗНО-КИСТОЗНАЯ МАСТОПАТИЯ (ФКМ) (BIRADS 2) справа и слева.',
        );
        expect(
          report.recommendationText,
          contains('УЗИ молочных желёз (рентгенологически плотные железы).'),
        );
        expect(
          report.descriptionText,
          contains(
            'Тип плотности ACR-D (железистый компонент более 75%), соответствует возрасту.',
          ),
        );
      },
    );

    test(
      'локальная асимметрия только справа с локализацией -> раздельная строка + текст с квадрантом',
      () {
        final finding = SelectedFinding(
          findingType: findingById('local_asymmetry'),
          quadrant: Quadrant.upperOuter,
        );
        final exam = MammographyExam(
          right: BreastExamSide(
            side: BreastSide.right,
            density: AcrDensity.c,
            findings: [finding],
          ),
          left: const BreastExamSide(
            side: BreastSide.left,
            density: AcrDensity.c,
          ),
        );

        final report = generateMammographyReport(exam);

        expect(
          report.conclusionText,
          'ЛОКАЛЬНАЯ АСИММЕТРИЯ (BIRADS 0) справа.',
        );
        expect(
          report.descriptionText,
          contains(
            'определяется локальная асимметрия ткани в проекции верхне-наружного квадранта',
          ),
        );
        expect(
          report.recommendationText,
          contains('Дообследование: прицельная рентгенография с компрессией'),
        );
      },
    );

    test(
      'BIRADS 2 с одной стороны и 4a с другой -> follow-up только от наивысшей категории',
      () {
        final rightFinding = SelectedFinding(
          findingType: findingById('fatty_involution'),
        );
        final leftFinding = SelectedFinding(
          findingType: findingById('birads4a_atypical_fibroadenoma'),
          quadrant: Quadrant.upperOuter,
          size: '10 мм',
        );
        final exam = MammographyExam(
          right: BreastExamSide(
            side: BreastSide.right,
            density: AcrDensity.b,
            findings: [rightFinding],
          ),
          left: BreastExamSide(
            side: BreastSide.left,
            density: AcrDensity.b,
            findings: [leftFinding],
          ),
        );

        final report = generateMammographyReport(exam);

        expect(report.conclusionText, contains('BIRADS 2 справа.'));
        expect(report.conclusionText, contains('BIRADS 4a слева.'));
        expect(
          report.recommendationText,
          isNot(contains('Динамический контроль через 1 год.')),
        );
      },
    );

    test(
      'разные находки на разных сторонах -> две отдельные строки заключения',
      () {
        final rightFinding = SelectedFinding(
          findingType: findingById('fatty_involution'),
        );
        final leftFinding = SelectedFinding(
          findingType: findingById('fibrocystic_mastopathy'),
        );
        final exam = MammographyExam(
          right: BreastExamSide(
            side: BreastSide.right,
            density: AcrDensity.a,
            findings: [rightFinding],
          ),
          left: BreastExamSide(
            side: BreastSide.left,
            density: AcrDensity.b,
            findings: [leftFinding],
          ),
        );

        final report = generateMammographyReport(exam);

        expect(
          report.conclusionText,
          contains('ФИБРОЗНО-ЖИРОВАЯ ИНВОЛЮЦИЯ (ФЖИ) (BIRADS 2) справа.'),
        );
        expect(
          report.conclusionText,
          contains('ФИБРОЗНО-КИСТОЗНАЯ МАСТОПАТИЯ (ФКМ) (BIRADS 2) слева.'),
        );
      },
    );

    test(
      'доброкачественные кальцинаты подставляют распределение и тип в описание и заключение',
      () {
        final finding = SelectedFinding(
          findingType: findingById('birads2_calcifications'),
          calcificationDistribution: CalcificationDistribution.diffuse,
          calcificationTypes: const [
            BenignCalcificationType.vascular,
            BenignCalcificationType.round,
          ],
        );
        final exam = MammographyExam(
          right: BreastExamSide(
            side: BreastSide.right,
            density: AcrDensity.b,
            findings: [finding],
          ),
          left: const BreastExamSide(
            side: BreastSide.left,
            density: AcrDensity.b,
          ),
        );

        final report = generateMammographyReport(exam);

        expect(
          report.descriptionText,
          contains(
            'Кальцинаты доброкачественные - да (распределение диффузное, сосудистые, круглые), злокачественные - нет.',
          ),
        );
        expect(report.descriptionText, contains('Обызвествления сосудов да.'));
        expect(
          report.conclusionText,
          contains(
            'Доброкачественные обызвествления молочных желёз (сосудистые, круглые, распределение диффузное).',
          ),
        );
      },
    );

    test('интрамаммарные лимфоузлы подставляют размер и квадрант в описание', () {
      final finding = SelectedFinding(
        findingType: findingById('birads2_intramammary_ln'),
        quadrant: Quadrant.upperOuter,
        size: '8 мм',
      );
      final exam = MammographyExam(
        right: BreastExamSide(
          side: BreastSide.right,
          density: AcrDensity.b,
          findings: [finding],
        ),
        left: const BreastExamSide(
          side: BreastSide.left,
          density: AcrDensity.b,
        ),
      );

      final report = generateMammographyReport(exam);

      expect(
        report.descriptionText,
        contains(
          'Определяются интрамаммарные лимфатические узлы размером до 8 мм в проекции верхне-наружного квадранта.',
        ),
      );
      expect(
        report.conclusionText,
        contains('Интрамаммарные лимфатические узлы правой молочной железы.'),
      );
    });

    test(
      'ретромаммарные импланты с обеих сторон -> описание и заключение справа и слева',
      () {
        final finding = SelectedFinding(
          findingType: findingById('birads2_implants'),
          implantPlacement: ImplantPlacement.retromammary,
        );
        final exam = MammographyExam(
          right: BreastExamSide(
            side: BreastSide.right,
            density: AcrDensity.b,
            findings: [finding],
          ),
          left: BreastExamSide(
            side: BreastSide.left,
            density: AcrDensity.b,
            findings: [finding],
          ),
        );

        final report = generateMammographyReport(exam);

        expect(
          report.descriptionText,
          contains(
            'Ретромаммарно визуализируется тень эндопротеза, положение его правильное, форма округлая, целостность импланта не нарушена.',
          ),
        );
        expect(
          report.conclusionText,
          contains('Ретромаммарные импланты молочной железы справа и слева.'),
        );
      },
    );

    test('субмускулярный имплант только справа -> заключение только справа', () {
      final finding = SelectedFinding(
        findingType: findingById('birads2_implants'),
        implantPlacement: ImplantPlacement.submuscular,
      );
      final exam = MammographyExam(
        right: BreastExamSide(
          side: BreastSide.right,
          density: AcrDensity.b,
          findings: [finding],
        ),
        left: const BreastExamSide(
          side: BreastSide.left,
          density: AcrDensity.b,
        ),
      );

      final report = generateMammographyReport(exam);

      expect(
        report.descriptionText,
        contains(
          'Субмускулярно визуализируется тень эндопротеза, положение его правильное, форма округлая, целостность импланта не нарушена.',
        ),
      );
      expect(
        report.conclusionText,
        contains('Субмускулярные импланты молочной железы справа.'),
      );
      expect(report.conclusionText, isNot(contains('справа и слева')));
    });

    test(
      'разное расположение имплантов на разных сторонах -> две строки заключения',
      () {
        final rightFinding = SelectedFinding(
          findingType: findingById('birads2_implants'),
          implantPlacement: ImplantPlacement.retromammary,
        );
        final leftFinding = SelectedFinding(
          findingType: findingById('birads2_implants'),
          implantPlacement: ImplantPlacement.submuscular,
        );
        final exam = MammographyExam(
          right: BreastExamSide(
            side: BreastSide.right,
            density: AcrDensity.b,
            findings: [rightFinding],
          ),
          left: BreastExamSide(
            side: BreastSide.left,
            density: AcrDensity.b,
            findings: [leftFinding],
          ),
        );

        final report = generateMammographyReport(exam);

        expect(
          report.conclusionText,
          contains('Ретромаммарные импланты молочной железы справа.'),
        );
        expect(
          report.conclusionText,
          contains('Субмускулярные импланты молочной железы слева.'),
        );
      },
    );

    test(
      'левая железа удалена, правая норма -> описание «Удалена», BIRADS только справа',
      () {
        final exam = MammographyExam(
          right: const BreastExamSide(
            side: BreastSide.right,
            density: AcrDensity.b,
          ),
          left: const BreastExamSide(
            side: BreastSide.left,
            density: AcrDensity.b,
            isRemoved: true,
          ),
        );

        final report = generateMammographyReport(exam);

        expect(
          report.descriptionText,
          contains('ПРАВАЯ МОЛОЧНАЯ ЖЕЛЕЗА В ДВУХ ПРОЕКЦИЯХ'),
        );
        expect(
          report.descriptionText,
          contains('ЛЕВАЯ МОЛОЧНАЯ ЖЕЛЕЗА:\nУдалена'),
        );
        expect(
          report.descriptionText,
          isNot(contains('ЛЕВАЯ МОЛОЧНАЯ ЖЕЛЕЗА В ДВУХ ПРОЕКЦИЯХ')),
        );
        expect(
          report.conclusionText,
          'Левая молочная железа удалена.\n'
          'Без очаговой патологии.\n'
          'BIRADS 1 справа.',
        );
        expect(report.conclusionText, isNot(contains('слева')));
      },
    );

    test('правая железа удалена, слева ФКИ -> BIRADS только слева', () {
      final finding = SelectedFinding(
        findingType: findingById('fibrocystic_mastopathy'),
      );
      final exam = MammographyExam(
        right: const BreastExamSide(
          side: BreastSide.right,
          density: AcrDensity.c,
          isRemoved: true,
        ),
        left: BreastExamSide(
          side: BreastSide.left,
          density: AcrDensity.c,
          findings: [finding],
        ),
      );

      final report = generateMammographyReport(exam);

      expect(
        report.descriptionText,
        contains('ПРАВАЯ МОЛОЧНАЯ ЖЕЛЕЗА:\nУдалена'),
      );
      expect(
        report.conclusionText,
        contains('Правая молочная железа удалена.'),
      );
      expect(report.conclusionText, contains('BIRADS 2 слева.'));
      expect(report.conclusionText, isNot(contains('справа и слева')));
      expect(report.conclusionText, isNot(contains('BIRADS 2 справа')));
      expect(
        report.recommendationText,
        contains('Рекомендовано УЗИ молочных желёз.'),
      );
    });

    test(
      'удалённая железа с ACR-D не добавляет рекомендацию УЗИ, если оставшаяся ACR-B',
      () {
        final exam = MammographyExam(
          right: const BreastExamSide(
            side: BreastSide.right,
            density: AcrDensity.b,
          ),
          left: const BreastExamSide(
            side: BreastSide.left,
            density: AcrDensity.d,
            isRemoved: true,
          ),
        );

        final report = generateMammographyReport(exam);

        expect(
          report.recommendationText,
          isNot(contains('УЗИ молочных желёз')),
        );
      },
    );

    test('без находок — ни один сегмент предпросмотра не выделен', () {
      final exam = MammographyExam(
        right: const BreastExamSide(
          side: BreastSide.right,
          density: AcrDensity.b,
        ),
        left: const BreastExamSide(
          side: BreastSide.left,
          density: AcrDensity.b,
        ),
      );

      final report = generateMammographyReport(exam);

      expect(report.previewSegments, isNotEmpty);
      expect(report.previewSegments.every((s) => !s.emphasized), isTrue);
      expect(
        report.previewSegments.map((s) => s.text).join(),
        report.fullText,
      );
    });

    test(
      'несколько находок — каждая переопределённая фраза описания выделена',
      () {
        final fzhi = SelectedFinding(
          findingType: findingById('fatty_involution'),
        );
        final mass = SelectedFinding(
          findingType: findingById('birads2_benign_mass'),
          quadrant: Quadrant.upperOuter,
          size: '12 мм',
        );
        final exam = MammographyExam(
          right: BreastExamSide(
            side: BreastSide.right,
            density: AcrDensity.b,
            findings: [fzhi, mass],
          ),
          left: const BreastExamSide(
            side: BreastSide.left,
            density: AcrDensity.b,
          ),
        );

        final report = generateMammographyReport(exam);
        final emphasized = report.previewSegments
            .where((s) => s.emphasized)
            .map((s) => s.text)
            .toList();

        expect(emphasized, hasLength(2));
        expect(
          emphasized,
          contains(
            'Структура представлена преимущественно элементами жировой ткани с участками фиброза, что соответствует фиброзно-жировой инволюции.',
          ),
        );
        expect(
          emphasized,
          contains(
            'В проекции верхне-наружного квадранта определяется округлое образование с четкими ровными контурами размером до 12 мм ',
          ),
        );
        for (final text in emphasized) {
          expect(report.descriptionText, contains(text.trim()));
        }
        expect(report.fullText, isNot(contains('**')));
        expect(report.textForClipboard, isNot(contains('**')));
        expect(
          report.previewSegments.map((s) => s.text).join(),
          report.fullText,
        );
      },
    );
  });
}
