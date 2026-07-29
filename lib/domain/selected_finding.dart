import 'finding_type.dart';
import 'mammography_catalog.dart';
import 'quadrant.dart';

/// Одна добавленная находка на конкретной стороне: тип + (опционально)
/// локализация. Сторона хранится не здесь, а тем, в чей список
/// [BreastExamSide.findings] эта запись добавлена.
class SelectedFinding {
  final FindingType findingType;
  final Quadrant? quadrant;

  const SelectedFinding({required this.findingType, this.quadrant});

  Map<String, dynamic> toJson() => {
        'findingId': findingType.id,
        'quadrant': quadrant?.name,
      };

  factory SelectedFinding.fromJson(Map<String, dynamic> json) {
    final quadrantName = json['quadrant'] as String?;
    return SelectedFinding(
      findingType: findingById(json['findingId'] as String),
      quadrant: quadrantName == null
          ? null
          : Quadrant.values.byName(quadrantName),
    );
  }
}
