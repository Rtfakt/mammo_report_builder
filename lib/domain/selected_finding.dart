import 'benign_calcification_type.dart';
import 'calcification_distribution.dart';
import 'finding_type.dart';
import 'implant_placement.dart';
import 'mammography_catalog.dart';
import 'quadrant.dart';

/// Одна добавленная находка на конкретной стороне: тип + (опционально)
/// локализация, размер и детали кальцинатов. Сторона хранится не здесь,
/// а тем, в чей список [BreastExamSide.findings] эта запись добавлена.
class SelectedFinding {
  final FindingType findingType;
  final Quadrant? quadrant;
  final String? size;
  final CalcificationDistribution? calcificationDistribution;
  final List<BenignCalcificationType> calcificationTypes;
  final ImplantPlacement? implantPlacement;

  const SelectedFinding({
    required this.findingType,
    this.quadrant,
    this.size,
    this.calcificationDistribution,
    this.calcificationTypes = const [],
    this.implantPlacement,
  });

  Map<String, dynamic> toJson() => {
    'findingId': findingType.id,
    'quadrant': quadrant?.name,
    'size': size,
    'calcificationDistribution': calcificationDistribution?.name,
    'calcificationTypes': calcificationTypes.map((t) => t.name).toList(),
    'implantPlacement': implantPlacement?.name,
  };

  factory SelectedFinding.fromJson(Map<String, dynamic> json) {
    final quadrantName = json['quadrant'] as String?;
    final distributionName = json['calcificationDistribution'] as String?;
    final typeNames = json['calcificationTypes'] as List?;
    final implantPlacementName = json['implantPlacement'] as String?;
    return SelectedFinding(
      findingType: findingById(json['findingId'] as String),
      quadrant: quadrantName == null
          ? null
          : Quadrant.values.byName(quadrantName),
      size: json['size'] as String?,
      calcificationDistribution: distributionName == null
          ? null
          : CalcificationDistribution.values.byName(distributionName),
      calcificationTypes: typeNames == null
          ? const []
          : typeNames
                .map((n) => BenignCalcificationType.values.byName(n as String))
                .toList(),
      implantPlacement: implantPlacementName == null
          ? null
          : ImplantPlacement.values.byName(implantPlacementName),
    );
  }
}
