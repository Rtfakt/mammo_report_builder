import 'finding_type.dart';
import 'mammography_catalog.dart';
import 'quadrant.dart';

/// Одна добавленная находка на конкретной стороне: тип + (опционально)
/// локализация и размер. Сторона хранится не здесь, а тем, в чей список
/// [BreastExamSide.findings] эта запись добавлена.
class SelectedFinding {
  final FindingType findingType;
  final Quadrant? quadrant;
  final String? size;

  const SelectedFinding({required this.findingType, this.quadrant, this.size});

  Map<String, dynamic> toJson() => {
        'findingId': findingType.id,
        'quadrant': quadrant?.name,
        'size': size,
      };

  factory SelectedFinding.fromJson(Map<String, dynamic> json) {
    final quadrantName = json['quadrant'] as String?;
    return SelectedFinding(
      findingType: findingById(json['findingId'] as String),
      quadrant: quadrantName == null
          ? null
          : Quadrant.values.byName(quadrantName),
      size: json['size'] as String?,
    );
  }
}
