import 'acr_density.dart';
import 'breast_exam_side.dart';
import 'breast_side.dart';

/// Полное состояние конструктора для одного исследования:
/// плотность и находки для правой и левой стороны.
class MammographyExam {
  final BreastExamSide right;
  final BreastExamSide left;

  /// Если true — UI показывает один общий селектор плотности,
  /// применяющийся сразу к обеим сторонам (типовой случай).
  final bool sameDensityBothSides;

  const MammographyExam({
    required this.right,
    required this.left,
    this.sameDensityBothSides = true,
  });

  factory MammographyExam.initial() => const MammographyExam(
        right: BreastExamSide(side: BreastSide.right, density: AcrDensity.c),
        left: BreastExamSide(side: BreastSide.left, density: AcrDensity.c),
        sameDensityBothSides: true,
      );

  MammographyExam copyWith({
    BreastExamSide? right,
    BreastExamSide? left,
    bool? sameDensityBothSides,
  }) {
    return MammographyExam(
      right: right ?? this.right,
      left: left ?? this.left,
      sameDensityBothSides: sameDensityBothSides ?? this.sameDensityBothSides,
    );
  }

  /// Меняет плотность: если [sameDensityBothSides], применяет к обеим
  /// сторонам одним действием.
  MammographyExam withDensity(AcrDensity density) {
    if (sameDensityBothSides) {
      return copyWith(
        right: right.copyWith(density: density),
        left: left.copyWith(density: density),
      );
    }
    return this;
  }

  MammographyExam withSideDensity(BreastSide side, AcrDensity density) {
    return side == BreastSide.right
        ? copyWith(right: right.copyWith(density: density))
        : copyWith(left: left.copyWith(density: density));
  }

  MammographyExam sideUpdated(BreastSide side, BreastExamSide Function(BreastExamSide) fn) {
    return side == BreastSide.right ? copyWith(right: fn(right)) : copyWith(left: fn(left));
  }

  Map<String, dynamic> toJson() => {
        'right': right.toJson(),
        'left': left.toJson(),
        'sameDensityBothSides': sameDensityBothSides,
      };

  factory MammographyExam.fromJson(Map<String, dynamic> json) {
    return MammographyExam(
      right: BreastExamSide.fromJson(json['right'] as Map<String, dynamic>),
      left: BreastExamSide.fromJson(json['left'] as Map<String, dynamic>),
      sameDensityBothSides: json['sameDensityBothSides'] as bool? ?? false,
    );
  }
}
