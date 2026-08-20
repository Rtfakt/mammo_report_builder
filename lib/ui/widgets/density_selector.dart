import 'package:flutter/material.dart';

import '../../domain/acr_density.dart';

/// Взаимоисключающий выбор плотности ACR A–D.
///
/// Галочку не показываем: выбранный сегмент и так выделен заливкой, а иконка
/// сжимает короткие подписи и заставляет буквы переноситься вертикально.
class DensitySelector extends StatelessWidget {
  final AcrDensity value;
  final ValueChanged<AcrDensity> onChanged;

  const DensitySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<AcrDensity>(
      showSelectedIcon: false,
      expandedInsets: EdgeInsets.zero,
      // SegmentedButton игнорирует minimumSize; высота сегментов идёт из padding.
      style: SegmentedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
        visualDensity: VisualDensity.standard,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      segments: [
        for (final density in AcrDensity.values)
          ButtonSegment(
            value: density,
            label: Text(density.code, maxLines: 1),
          ),
      ],
      selected: {value},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}
