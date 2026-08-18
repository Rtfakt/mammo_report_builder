import 'acr_density.dart';
import 'breast_side.dart';
import 'selected_finding.dart';

/// Данные по одной стороне (правая/левая молочная железа): плотность и
/// список добавленных находок.
class BreastExamSide {
  final BreastSide side;
  final AcrDensity density;
  final List<SelectedFinding> findings;

  /// Молочная железа удалена (мастэктомия): описание/заключение особые,
  /// BI-RADS для этой стороны не выставляется.
  final bool isRemoved;

  const BreastExamSide({
    required this.side,
    required this.density,
    this.findings = const [],
    this.isRemoved = false,
  });

  /// Пусто или содержит только фоновое состояние — считается "нормой".
  bool get hasOnlyNormalFindings =>
      findings.every((f) => !f.findingType.isPathology);

  BreastExamSide copyWith({
    AcrDensity? density,
    List<SelectedFinding>? findings,
    bool? isRemoved,
  }) {
    return BreastExamSide(
      side: side,
      density: density ?? this.density,
      findings: findings ?? this.findings,
      isRemoved: isRemoved ?? this.isRemoved,
    );
  }

  BreastExamSide addFinding(SelectedFinding finding) =>
      copyWith(findings: [...findings, finding]);

  BreastExamSide removeFindingAt(int index) {
    final updated = [...findings]..removeAt(index);
    return copyWith(findings: updated);
  }

  /// Отметить железу как удалённую (находки сбрасываются) или вернуть её.
  BreastExamSide withRemoved(bool removed) =>
      copyWith(isRemoved: removed, findings: removed ? const [] : findings);

  Map<String, dynamic> toJson() => {
    'side': side.name,
    'density': density.name,
    'findings': findings.map((f) => f.toJson()).toList(),
    'isRemoved': isRemoved,
  };

  factory BreastExamSide.fromJson(Map<String, dynamic> json) {
    return BreastExamSide(
      side: BreastSide.values.byName(json['side'] as String),
      density: AcrDensity.values.byName(json['density'] as String),
      findings: (json['findings'] as List)
          .map((f) => SelectedFinding.fromJson(f as Map<String, dynamic>))
          .toList(),
      isRemoved: json['isRemoved'] as bool? ?? false,
    );
  }
}
