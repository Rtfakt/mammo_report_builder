import 'acr_density.dart';
import 'breast_side.dart';
import 'selected_finding.dart';

/// Данные по одной стороне (правая/левая молочная железа): плотность и
/// список добавленных находок.
class BreastExamSide {
  final BreastSide side;
  final AcrDensity density;
  final List<SelectedFinding> findings;

  const BreastExamSide({
    required this.side,
    required this.density,
    this.findings = const [],
  });

  /// Пусто или содержит только фоновое состояние — считается "нормой".
  bool get hasOnlyNormalFindings => findings.every((f) => !f.findingType.isPathology);

  BreastExamSide copyWith({
    AcrDensity? density,
    List<SelectedFinding>? findings,
  }) {
    return BreastExamSide(
      side: side,
      density: density ?? this.density,
      findings: findings ?? this.findings,
    );
  }

  BreastExamSide addFinding(SelectedFinding finding) =>
      copyWith(findings: [...findings, finding]);

  BreastExamSide removeFindingAt(int index) {
    final updated = [...findings]..removeAt(index);
    return copyWith(findings: updated);
  }

  Map<String, dynamic> toJson() => {
        'side': side.name,
        'density': density.name,
        'findings': findings.map((f) => f.toJson()).toList(),
      };

  factory BreastExamSide.fromJson(Map<String, dynamic> json) {
    return BreastExamSide(
      side: BreastSide.values.byName(json['side'] as String),
      density: AcrDensity.values.byName(json['density'] as String),
      findings: (json['findings'] as List)
          .map((f) => SelectedFinding.fromJson(f as Map<String, dynamic>))
          .toList(),
    );
  }
}
