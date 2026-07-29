import 'acr_density.dart';

/// Стандартные "строки-чеклист" блока "Описание", как в диктовке врача.
/// Находка может переопределить текст любого слота (кроме [structure],
/// у которого дефолт зависит от плотности, но тоже переопределяем).
enum DescriptionSlot {
  skin,
  structure,
  calcifications,
  asymmetry,
  nodules,
  architecture,
  lymphNodes,
  vesselCalcification;

  String defaultText(AcrDensity density) => switch (this) {
        DescriptionSlot.skin =>
          'Кожные покровы, сосок, ареола без особенностей.',
        DescriptionSlot.structure => density.defaultStructureSentence,
        DescriptionSlot.calcifications =>
          'Кальцинаты доброкачественные - нет, злокачественные - нет.',
        DescriptionSlot.asymmetry => 'Участков ассиметрии - нет.',
        DescriptionSlot.nodules => 'Узловые образования не определяются.',
        DescriptionSlot.architecture => 'Нарушение архитектоники - нет.',
        DescriptionSlot.lymphNodes => 'Лимфатические узлы не увеличены.',
        DescriptionSlot.vesselCalcification =>
          'Обызвествления сосудов нет.',
      };
}
