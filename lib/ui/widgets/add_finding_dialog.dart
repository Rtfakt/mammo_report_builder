import 'package:flutter/material.dart';

import '../../domain/birads_category.dart';
import '../../domain/breast_side.dart';
import '../../domain/finding_type.dart';
import '../../domain/mammography_catalog.dart';
import '../../domain/quadrant.dart';

/// Результат диалога "Добавить находку": сама находка, набор сторон,
/// на которые её нужно добавить (обычно одна — текущая панель, но можно
/// сразу отметить "обе стороны" для типового двустороннего случая),
/// локализация и размер, если находка их требует.
class AddFindingResult {
  final FindingType findingType;
  final Set<BreastSide> sides;
  final Quadrant? quadrant;
  final String? size;

  const AddFindingResult({
    required this.findingType,
    required this.sides,
    this.quadrant,
    this.size,
  });
}

Future<AddFindingResult?> showAddFindingDialog(
  BuildContext context, {
  required BreastSide currentSide,
}) {
  return showDialog<AddFindingResult>(
    context: context,
    builder: (context) => _AddFindingDialog(currentSide: currentSide),
  );
}

class _AddFindingDialog extends StatefulWidget {
  final BreastSide currentSide;

  const _AddFindingDialog({required this.currentSide});

  @override
  State<_AddFindingDialog> createState() => _AddFindingDialogState();
}

class _AddFindingDialogState extends State<_AddFindingDialog> {
  BiRadsCategory? _selectedCategory;
  FindingType? _selectedFinding;
  late Set<BreastSide> _sides;
  Quadrant? _quadrant;
  final TextEditingController _sizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sides = {widget.currentSide};
  }

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  bool get _isOnStep1 => _selectedCategory == null;

  bool get _canConfirm {
    final finding = _selectedFinding;
    if (finding == null) return false;
    if (_sides.isEmpty) return false;
    if (finding.requiresLocalization && _quadrant == null) return false;
    return true;
  }

  void _selectCategory(BiRadsCategory category) {
    final findings = findingsByCategory(category);
    setState(() {
      _selectedCategory = category;
      _selectedFinding = null;
      _quadrant = null;
      _sizeController.clear();

      // BI-RADS 6 содержит единственную находку — выбираем её автоматически
      if (findings.length == 1) {
        _selectedFinding = findings.first;
      }
    });
  }

  void _goBack() {
    setState(() {
      _selectedCategory = null;
      _selectedFinding = null;
      _quadrant = null;
      _sizeController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          if (!_isOnStep1)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _goBack,
              tooltip: 'Назад к выбору категории',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          if (!_isOnStep1) const SizedBox(width: 8),
          Expanded(
            child: Text(_isOnStep1 ? 'Категория BI-RADS' : 'Выберите находку'),
          ),
        ],
      ),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: _isOnStep1 ? _buildStep1() : _buildStep2(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        if (!_isOnStep1)
          FilledButton(
            onPressed: _canConfirm ? _confirm : null,
            child: const Text('Добавить'),
          ),
      ],
    );
  }

  Widget _buildStep1() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Выберите категорию BI-RADS для добавляемой находки:',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 16),
        ...BiRadsCategory.values.map((cat) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _CategoryTile(
              category: cat,
              onTap: () => _selectCategory(cat),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStep2() {
    final category = _selectedCategory!;
    final findings = findingsByCategory(category);
    final selected = _selectedFinding;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок выбранной категории
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            category.label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Список находок в категории (если больше одной)
        if (findings.length > 1) ...[
          const Text('Патология / Заключение', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: findings.map((finding) {
              final isSelected = finding.id == selected?.id;
              return ChoiceChip(
                label: Text(finding.label),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    _selectedFinding = finding;
                    _quadrant = null;
                    _sizeController.clear();
                  });
                },
              );
            }).toList(),
          ),
        ] else if (findings.length == 1) ...[
          // Единственная находка — просто показываем название
          Text(
            findings.first.label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],

        // Поле размера
        if (selected != null && selected.requiresSize) ...[
          const SizedBox(height: 20),
          const Text('Размер образования', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _sizeController,
            decoration: const InputDecoration(
              hintText: 'Например: 12 мм',
              border: OutlineInputBorder(),
              suffixText: 'мм',
              isDense: true,
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],

        // Сторона
        if (selected != null && selected.isPathology) ...[
          const SizedBox(height: 20),
          const Text('Сторона', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: BreastSide.values.map((side) {
              final isChecked = _sides.contains(side);
              return FilterChip(
                label: Text(side.label),
                selected: isChecked,
                onSelected: (checked) {
                  setState(() {
                    if (checked) {
                      _sides.add(side);
                    } else {
                      _sides.remove(side);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],

        // Локализация
        if (selected != null && selected.requiresLocalization) ...[
          const SizedBox(height: 20),
          const Text('Локализация', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<Quadrant>(
            initialValue: _quadrant,
            isExpanded: true,
            hint: const Text('Выберите квадрант'),
            items: Quadrant.values
                .map((q) => DropdownMenuItem(value: q, child: Text(q.label)))
                .toList(),
            onChanged: (value) => setState(() => _quadrant = value),
          ),
        ],
      ],
    );
  }

  void _confirm() {
    final finding = _selectedFinding!;
    Navigator.of(context).pop(
      AddFindingResult(
        findingType: finding,
        sides: _sides,
        quadrant: _quadrant,
        size: _sizeController.text.trim().isEmpty ? null : _sizeController.text.trim(),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final BiRadsCategory category;
  final VoidCallback onTap;

  const _CategoryTile({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(category, context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(8),
          color: color.withValues(alpha: 0.07),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                category.label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _categoryDescription(category),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }

  Color _categoryColor(BiRadsCategory cat, BuildContext context) {
    switch (cat) {
      case BiRadsCategory.birads2:
        return Colors.green.shade600;
      case BiRadsCategory.birads3:
        return Colors.lightGreen.shade600;
      case BiRadsCategory.birads4a:
        return Colors.orange.shade400;
      case BiRadsCategory.birads4b:
        return Colors.orange.shade700;
      case BiRadsCategory.birads4c:
        return Colors.deepOrange.shade700;
      case BiRadsCategory.birads5:
        return Colors.red.shade700;
      case BiRadsCategory.birads6:
        return Colors.red.shade900;
    }
  }

  String _categoryDescription(BiRadsCategory cat) {
    switch (cat) {
      case BiRadsCategory.birads2:
        return 'Доброкачественные изменения';
      case BiRadsCategory.birads3:
        return 'Вероятно доброкачественное. Контроль через 6 мес.';
      case BiRadsCategory.birads4a:
        return 'Низкая вероятность злокачественности';
      case BiRadsCategory.birads4b:
        return 'Промежуточная вероятность злокачественности';
      case BiRadsCategory.birads4c:
        return 'Высокая вероятность злокачественности';
      case BiRadsCategory.birads5:
        return 'Достоверно злокачественные изменения';
      case BiRadsCategory.birads6:
        return 'Верифицированный неоперированный рак';
    }
  }
}
